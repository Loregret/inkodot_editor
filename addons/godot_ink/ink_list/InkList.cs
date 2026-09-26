#pragma warning disable IDE0022

using Godot;

namespace GodotInkle;

[GlobalClass]
public partial class InkList(Ink.Runtime.InkList inner) : RefCounted
{
	readonly Ink.Runtime.InkList inner = inner;

	/// <summary> Underlying ink runtime list. </summary>
	public Ink.Runtime.InkList RuntimeList => inner;

	public InkList(InkList otherList)
		: this(new Ink.Runtime.InkList(otherList.inner)) { }

	public InkList Inverse => new(inner.inverse);
	public InkList All => new(inner.all);

	public void AddItem(string itemName) => inner.AddItem(itemName);

	public bool Contains(string listItemName) => inner.Contains(listItemName);
	public bool Contains(InkList otherList) => inner.Contains(otherList.inner);
	public bool ContainsItemNamed(string itemName) => inner.ContainsItemNamed(itemName);

	public override bool Equals(object? other) => other switch
	{
		InkList g => inner.Equals(g.inner),
		Ink.Runtime.InkList r => inner.Equals(r),
		_ => inner.Equals(other),
	};
	public override int GetHashCode() => inner.GetHashCode();
	public override string ToString() => inner.ToString();

	public bool GreaterThan(InkList otherList) => inner.GreaterThan(otherList.inner);
	public bool GreaterThanOrEquals(InkList otherList) => inner.GreaterThanOrEquals(otherList.inner);
	public bool LessThan(InkList otherList) => inner.LessThan(otherList.inner);
	public bool LessThanOrEquals(InkList otherList) => inner.LessThanOrEquals(otherList.inner);

	public bool HasIntersection(InkList otherList) => inner.HasIntersection(otherList.inner);
	public InkList Intersect(InkList otherList) => new(inner.Intersect(otherList.inner));
	public InkList Union(InkList otherList) => new(inner.Union(otherList.inner));
	public InkList Without(InkList listToRemove) => new(inner.Without(listToRemove.inner));

	public InkList MaxAsList() => new(inner.MaxAsList());
	public InkList MinAsList() => new(inner.MinAsList());

	public void SetInitialOriginName(string initialOriginName) => inner.SetInitialOriginName(initialOriginName);
	public void SetInitialOriginNames(string[] initialOriginNames) => inner.SetInitialOriginNames([.. initialOriginNames]);
}