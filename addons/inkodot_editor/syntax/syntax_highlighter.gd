@tool
extends SyntaxHighlighter

@export var default_color := Color.LIGHT_GRAY
@export var comment_color := Color.DARK_SLATE_GRAY
@export var keyword_color := Color.SKY_BLUE
@export var knot_color := Color.GOLD
@export var stitch_color := Color.SEA_GREEN
@export var divert_color := Color.GOLD
@export var tag_color := Color.PURPLE
@export var logic_color := Color.OLIVE_DRAB
@export var variable_color := Color.GOLD
@export var string_color := Color.WHITE
@export var choice_color := Color.GREEN
@export var brackets_color := Color("#83a24f")
@export var glue_color := Color.GREEN
@export var bbcode_color := Color.HOT_PINK


func _get_line_syntax_highlighting(line: int) -> Dictionary:
	var result := {}
	var working_text := get_text_edit().get_line(line)
	
	# Early returns for empty lines or comment-only lines
	if working_text.strip_edges().is_empty():
		return result
	
	# Highlight different syntax elements
	_highlight_choices(working_text, result)
	_highlight_strings(working_text, result)
	_highlight_tags(working_text, result)
	_highlight_knots_and_stitches(working_text, result)
	_highlight_diverts(working_text, result)
	_highlight_variables(working_text, result)
	_highlight_logic(working_text, result)
	_highlight_brackets(working_text, result)
	_highlight_comments(working_text, result)
	_highlight_glue(working_text, result)
	_highlight_bbcode(working_text, result)
	
	return result

func _highlight_knots_and_stitches(working_text: String, result: Dictionary) -> void:
	# Knots: === knot_name ===
	var knot_regex := RegEx.create_from_string("^[\\s]*===.*$")
	for match_result in knot_regex.search_all(working_text):
		var start := match_result.get_start()
		var end := match_result.get_end()
		_set_color_range(result, start, end, knot_color)
	
	# Stitches: = stitch_name
	if working_text.strip_edges().begins_with("=") and not working_text.strip_edges().begins_with("=="):
		var start := working_text.find("=")
		var end := working_text.length()
		_set_color_range(result, start, end, stitch_color)

func _highlight_choices(text: String, result: Dictionary) -> void:
	# Choices: *, +, - (with optional spaces)
	var choice_regex := RegEx.create_from_string("^[\\*|\\+|\\-|\\s]*")
	for match_result in choice_regex.search_all(text):
		var start := match_result.get_start()
		var end := match_result.get_end()
		_set_color_range(result, start, end, choice_color)

func _highlight_brackets(text: String, result: Dictionary) -> void:
	var choice_regex := RegEx.create_from_string("\\[|\\]")
	for match_result in choice_regex.search_all(text):
		var start := match_result.get_start()
		var end := match_result.get_end()
		_set_color_range(result, start, end, brackets_color)

func _highlight_diverts(text: String, result: Dictionary) -> void:
	# Diverts: -> or <-
	var divert_regex := RegEx.create_from_string("(->|<-|END|DONE)")
	for match_result in divert_regex.search_all(text):
		var start := match_result.get_start()
		var end := match_result.get_end()
		_set_color_range(result, start, end, divert_color)

func _highlight_tags(text: String, result: Dictionary) -> void:
	# Tags: #tag or # tag
	var tag_regex := RegEx.create_from_string("#[^\\s]+")
	for match_result in tag_regex.search_all(text):
		var start := match_result.get_start()
		var end := match_result.get_end()
		_set_color_range(result, start, end, tag_color)

func _highlight_variables(text: String, result: Dictionary) -> void:
	## Variable declarations and usage
	var var_decl_regex := RegEx.create_from_string("(?m)^(VAR|CONST|INCLUDE).*$")
	for match_result in var_decl_regex.search_all(text):
		var start := match_result.get_start()
		var end := match_result.get_end()
		_set_color_range(result, start, end, variable_color)

func _highlight_logic(text: String, result: Dictionary) -> void:
	# Variable usage: {variable} or {expression}
	var var_usage_regex := RegEx.create_from_string("{[\\s\\S]*}|~.*$")
	for match_result in var_usage_regex.search_all(text):
		var start := match_result.get_start(0)  # Group 1 is inside braces
		var end := match_result.get_end(0)
		_set_color_range(result, start, end, logic_color)

func _highlight_strings(text: String, result: Dictionary) -> void:
	# Variable usage: {variable} or {expression}
	var var_usage_regex := RegEx.create_from_string('\\".*\\"')
	for match_result in var_usage_regex.search_all(text):
		var start := match_result.get_start(0)
		var end := match_result.get_end(0)
		_set_color_range(result, start, end, string_color)

func _highlight_comments(text: String, result: Dictionary) -> void:
	# Variable usage: {variable} or {expression}
	var var_usage_regex := RegEx.create_from_string("//.*$")
	for match_result in var_usage_regex.search_all(text):
		var start := match_result.get_start(0)  # Group 1 is inside braces
		var end := match_result.get_end(0)
		_set_color_range(result, start, end, comment_color)

func _highlight_glue(text: String, result: Dictionary) -> void:
	# Variable usage: {variable} or {expression}
	var var_usage_regex := RegEx.create_from_string("<>")
	for match_result in var_usage_regex.search_all(text):
		var start := match_result.get_start(0)  # Group 1 is inside braces
		var end := match_result.get_end(0)
		_set_color_range(result, start, end, glue_color)

func _highlight_bbcode(text: String, result: Dictionary) -> void:
	# Variable usage: {variable} or {expression}
	var var_usage_regex := RegEx.create_from_string("<(?>[^<>]|(?R))*>")
	for match_result in var_usage_regex.search_all(text):
		var start := match_result.get_start(0)  # Group 1 is inside braces
		var end := match_result.get_end(0)
		_set_color_range(result, start, end, bbcode_color)

func _set_color_range(result: Dictionary, start: int, end: int, color: Color) -> void:
	# Color the main range
	for i in range(start, end):
		result[i] = {"color": color}
	
	# Set default color after if not already colored
	if not result.has(end):
		result[end] = {"color": default_color}
