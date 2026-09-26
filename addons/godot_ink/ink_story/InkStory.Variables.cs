using Godot;
using System;
using System.Collections.Generic;

using static GodotInkle.MarshalUtils;

namespace GodotInkle;

public partial class InkStory
{
	public Ink.Runtime.VariablesState? VariablesState => RuntimeStory?.variablesState;

	public readonly Dictionary<string, HashSet<Callable>> Observers = [];
	public readonly Dictionary<string, Ink.Runtime.Story.VariableObserver> InternalObservers = [];


	//> Variable

	public Variant FetchVariable(string variableName)
	{
		return ToVariant(VariablesState![variableName]);
	}

	public T FetchVariable<[MustBeVariant] T>(string variableName)
	{
		return FetchVariable(variableName).As<T>();
	}

	public void StoreVariable(string variableName, Variant value)
	{
		RuntimeStory?.variablesState[variableName] = FromVariant(value);
	}

	public void StoreVariable<[MustBeVariant] T>(string variableName, T value)
	{
		StoreVariable(variableName, Variant.From(value));
	}


	//> Observer

	public void ObserveVariable(string variableName, Callable observer)
	{
		if (!InternalObservers.ContainsKey(variableName))
		{
			Ink.Runtime.Story.VariableObserver internalObserver = BuildObserver();
			RuntimeStory?.ObserveVariable(variableName, internalObserver);
			InternalObservers[variableName] = internalObserver;
		}

		if (Observers.ContainsKey(variableName))
			_ = Observers[variableName].Add(observer);
		else
			Observers[variableName] = [observer];
	}

	public void ObserveVariable(string[] variableNames, Callable observer)
	{
		foreach (string variableName in variableNames)
			ObserveVariable(variableName, observer);
	}

	Ink.Runtime.Story.VariableObserver BuildObserver()
	{
		return delegate (string name, object? value)
		{
			if (!Observers.TryGetValue(name, out var callables)) return;

			Variant variant = ToVariant(value);
			foreach (Callable callable in callables)
				_ = callable.Call(name, variant);
		};
	}

	public void RemoveVariableObserver(Callable callable)
	{
		foreach (string variableName in Observers.Keys)
			RemoveVariableObserver(callable, variableName);
	}

	public void RemoveVariableObserver(string specificVariableName)
	{
		RuntimeStory?.RemoveVariableObserver(null, specificVariableName);
		_ = InternalObservers.Remove(specificVariableName);
		_ = Observers.Remove(specificVariableName);
	}

	public void RemoveVariableObserver(Callable callable, string specificVariableName)
	{
		var callables = Observers[specificVariableName];
		if (!callables.Contains(callable)) return;

		_ = callables.Remove(callable);
		if (callables.Count > 0) return;

		RuntimeStory?.RemoveVariableObserver(null, specificVariableName);
		_ = InternalObservers.Remove(specificVariableName);
	}

}
