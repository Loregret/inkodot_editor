@tool
extends EditorExportPlugin

const DEMO_SOURCE := "res://ink_demos"
const DEMO_DEST_NAME := "ink"

## Marker that must be present in project.godot for this plugin to act.
## Prevents the copier from firing when the editor is installed as a plugin
## in someone else's project that happens to contain a folder named ink_demos.
const STANDALONE_MARKER := "inkodot/is_standalone_app"

## Files whose extension matches any of these are skipped during the copy.
## Godot's `.import` companions aren't real content — they're editor metadata
## that regenerates on demand and shouldn't be shipped to the user.
const SKIPPED_EXTENSIONS := ["import"]

## Directory names that should never be walked into.
const SKIPPED_DIRECTORIES := [".import", ".godot"]

var _export_path := ""


func _get_name() -> String:
	return "InkDemoCopier"


func _export_begin(_features: PackedStringArray, _is_debug: bool, path: String, _flags: int) -> void:
	# `path` is whatever the user chose in the export dialog:
	#   Windows/Linux : /path/to/Game.exe
	#   macOS         : /path/to/Game.app  (or .zip)
	# We stash it and do the copy at the end, after the export finishes.
	_export_path = path


func _export_end() -> void:
	# Only act in the standalone app itself. In a user's project the plugin
	# is loaded (it's part of the addon) but does nothing on export.
	if not _is_standalone_app():
		return

	if _export_path.is_empty():
		push_warning("[Inkodot] Export path unknown; skipping ink_demos copy.")
		return

	if not DirAccess.dir_exists_absolute(DEMO_SOURCE):
		# Not an error — projects that don't ship demos simply skip this.
		return

	# _export_path.get_base_dir() gives the folder the user picked, which is
	# where "ink/" should live. For macOS .app bundles this correctly puts it
	# *outside* the bundle, matching what GetStandaloneRoot() looks for at
	# runtime (it walks up out of Contents/MacOS/).
	var dest_dir := _export_path.get_base_dir().path_join(DEMO_DEST_NAME)

	if DirAccess.dir_exists_absolute(dest_dir):
		# Don't clobber an existing folder — the user might have authored
		# their own .ink files into it since the last export.
		print("[Inkodot] '%s' already exists — skipping demo copy." % dest_dir)
		return

	var err := _copy_recursive(DEMO_SOURCE, dest_dir)
	if err != OK:
		push_warning("[Inkodot] Failed to copy demos to '%s' (error %d)." % [dest_dir, err])
	else:
		print("[Inkodot] Copied demos to '%s'." % dest_dir)


## True only when the current project declares itself as the standalone app.
func _is_standalone_app() -> bool:
	return bool(ProjectSettings.get_setting(STANDALONE_MARKER, false))


## Recursively copies a res:// tree to an absolute OS path, skipping
## editor-generated metadata (`.import` files, `.import/` and `.godot/`
## directories). Returns OK on success, or the first error encountered.
func _copy_recursive(src_res: String, dst_abs: String) -> Error:
	var src_abs := ProjectSettings.globalize_path(src_res)

	var src_dir := DirAccess.open(src_abs)
	if not src_dir:
		return DirAccess.get_open_error()

	var mk_err := DirAccess.make_dir_recursive_absolute(dst_abs)
	if mk_err != OK and mk_err != ERR_ALREADY_EXISTS:
		return mk_err

	for file in src_dir.get_files():
		if _should_skip_file(file):
			continue

		var err := DirAccess.copy_absolute(
			src_abs.path_join(file),
			dst_abs.path_join(file))
		if err != OK:
			return err

	for sub in src_dir.get_directories():
		if _should_skip_directory(sub):
			continue

		var err := _copy_recursive(src_res.path_join(sub), dst_abs.path_join(sub))
		if err != OK:
			return err

	return OK


## True if the filename should be excluded from the copy.
## Matches `foo.import` and any other suffix chain ending in `.import`.
func _should_skip_file(file_name: String) -> bool:
	var ext := file_name.get_extension().to_lower()
	return ext in SKIPPED_EXTENSIONS


## True if a directory should not be descended into.
func _should_skip_directory(dir_name: String) -> bool:
	return dir_name in SKIPPED_DIRECTORIES
