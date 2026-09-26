using Godot;
using System;

using static GodotInkle.MarshalUtils;

namespace GodotInkle;

public partial class InkStory
{

	/// <summary>
	/// An ink file can provide a fallback functions for when when an EXTERNAL has been left
	/// unbound by the client, and the fallback function will be called instead. Useful when
	/// testing a story in play mode, when it's not possible to write a client-side C# external
	/// function, but you don't want it to fail to run.
	/// </summary>
	public bool AllowExternalFunctionFallbacks => RuntimeStory?.allowExternalFunctionFallbacks ?? false;

	/// <summary>
	/// Checks if a function exists.
	/// </summary>
	/// <param name="functionName">The name of the function as declared in ink.</param>
	/// <returns>True if the function exists, else false.</returns>
	public bool HasFunction(string functionName)
	{
		return RuntimeStory?.HasFunction(functionName) ?? false;
	}

	/// <summary>
	/// Evaluates a function defined in ink.
	/// </summary>
	/// <param name="functionName">The name of the function as declared in ink.</param>
	/// <param name="arguments">
	/// The arguments that the ink function takes, if any. Note that we don't (can't) do any
	/// validation on the number of arguments right now, so make sure you get it right!
	/// </param>
	/// <returns>
	/// The return value as returned from the ink function with `~ return myValue`, or a nil
	/// variant if nothing is returned.
	/// </returns>
	public Variant EvaluateFunction(string functionName, params Variant[] arguments)
	{
		object? result = RuntimeStory?.EvaluateFunction(functionName, FromVariants(arguments));
		return ToVariant(result);
	}

	/// <summary>
	/// Evaluates a function defined in ink.
	/// </summary>
	/// <param name="functionName">The name of the function as declared in ink.</param>
	/// <param name="arguments">
	/// The arguments that the ink function takes, if any. Note that we don't (can't) do any
	/// validation on the number of arguments right now, so make sure you get it right!
	/// </param>
	/// <returns>
	/// The return value as returned from the ink function with `~ return myValue`, or a nil
	/// variant if nothing is returned.
	/// </returns>
	public Variant EvaluateFunction(string functionName, Godot.Collections.Array<Variant> arguments)
	{
		object? result = RuntimeStory?.EvaluateFunction(functionName, FromVariants(arguments));
		return ToVariant(result);
	}

	/// <summary>
	/// Evaluates a function defined in ink, and gathers the possibly multi-line text as generated
	/// by the function. This text output is any text written as normal content within the function,
	/// as opposed to the return value, as returned with `~ return`.
	/// </summary>
	/// <param name="functionName">The name of the function as declared in ink.</param>
	/// <param name="textOutput">The text content produced by the function via normal ink, if any.</param>
	/// <param name="arguments">
	/// The arguments that the ink function takes, if any. Note that we don't (can't) do any
	/// validation on the number of arguments right now, so make sure you get it right!
	/// </param>
	/// <returns>
	/// The return value as returned from the ink function with `~ return myValue`, or a nil
	/// variant if nothing is returned.
	/// </returns>
	public Variant EvaluateFunction(string functionName, out string textOutput, params Variant[] arguments)
	{
		object? result = RuntimeStory!.EvaluateFunction(functionName, out textOutput, FromVariants(arguments));
		return ToVariant(result);
	}

	/// <summary>
	/// Bind a C# function to an ink EXTERNAL function declaration.
	/// </summary>
	/// <param name="funcName">EXTERNAL ink function name to bind to.</param>
	/// <param name="callable">The Godot Callable to bind.</param>
	/// <param name="lookaheadSafe">The ink engine often evaluates further
	/// than you might expect beyond the current line just in case it sees
	/// glue that will cause the two lines to become one. In this case it's
	/// possible that a function can appear to be called twice instead of
	/// just once, and earlier than you expect. If it's safe for your
	/// function to be called in this way (since the result and side effect
	/// of the function will not change), then you can pass 'true'.
	/// Usually, you want to pass 'false', especially if you want some action
	/// to be performed in game code when this function is called.</param>
	public void BindExternalFunction(string funcName, Callable callable, bool lookaheadSafe = false)
	{
		RuntimeStory?.BindExternalFunctionGeneral(funcName, trampoline, lookaheadSafe);

		object? trampoline(object?[] arguments) => FromVariant(callable.Call(ToVariants(arguments)));
	}

	/// <summary>
	/// Bind a C# function to an ink EXTERNAL function declaration.
	/// </summary>
	/// <param name="funcName">EXTERNAL ink function name to bind to.</param>
	/// <param name="func">The C# function to bind.</param>
	/// <param name="lookaheadSafe">The ink engine often evaluates further
	/// than you might expect beyond the current line just in case it sees
	/// glue that will cause the two lines to become one. In this case it's
	/// possible that a function can appear to be called twice instead of
	/// just once, and earlier than you expect. If it's safe for your
	/// function to be called in this way (since the result and side effect
	/// of the function will not change), then you can pass 'true'.
	/// Usually, you want to pass 'false', especially if you want some action
	/// to be performed in game code when this function is called.</param>
	public void BindExternalFunction(string funcName, Func<Variant> func, bool lookaheadSafe = false)
	{
		RuntimeStory?.BindExternalFunction(funcName, trampoline, lookaheadSafe);

		object? trampoline() => FromVariant(func.Invoke());
	}

	/// <summary>
	/// Bind a C# function to an ink EXTERNAL function declaration.
	/// </summary>
	/// <param name="funcName">EXTERNAL ink function name to bind to.</param>
	/// <param name="func">The C# function to bind.</param>
	/// <param name="lookaheadSafe">The ink engine often evaluates further
	/// than you might expect beyond the current line just in case it sees
	/// glue that will cause the two lines to become one. In this case it's
	/// possible that a function can appear to be called twice instead of
	/// just once, and earlier than you expect. If it's safe for your
	/// function to be called in this way (since the result and side effect
	/// of the function will not change), then you can pass 'true'.
	/// Usually, you want to pass 'false', especially if you want some action
	/// to be performed in game code when this function is called.</param>
	public void BindExternalFunction<T>(string funcName, Func<T, Variant> func, bool lookaheadSafe = false)
	{
		RuntimeStory?.BindExternalFunction(funcName, (Func<T, object?>)trampoline, lookaheadSafe);

		object? trampoline(T a) => FromVariant(func.Invoke(a));
	}

	/// <summary>
	/// Bind a C# function to an ink EXTERNAL function declaration.
	/// </summary>
	/// <param name="funcName">EXTERNAL ink function name to bind to.</param>
	/// <param name="func">The C# function to bind.</param>
	/// <param name="lookaheadSafe">The ink engine often evaluates further
	/// than you might expect beyond the current line just in case it sees
	/// glue that will cause the two lines to become one. In this case it's
	/// possible that a function can appear to be called twice instead of
	/// just once, and earlier than you expect. If it's safe for your
	/// function to be called in this way (since the result and side effect
	/// of the function will not change), then you can pass 'true'.
	/// Usually, you want to pass 'false', especially if you want some action
	/// to be performed in game code when this function is called.</param>
	public void BindExternalFunction<T1, T2>(string funcName, Func<T1, T2, Variant> func, bool lookaheadSafe = false)
	{
		RuntimeStory?.BindExternalFunction(funcName, (Func<T1, T2, object?>)trampoline, lookaheadSafe);

		object? trampoline(T1 a, T2 b) => FromVariant(func.Invoke(a, b));
	}

	/// <summary>
	/// Bind a C# function to an ink EXTERNAL function declaration.
	/// </summary>
	/// <param name="funcName">EXTERNAL ink function name to bind to.</param>
	/// <param name="func">The C# function to bind.</param>
	/// <param name="lookaheadSafe">The ink engine often evaluates further
	/// than you might expect beyond the current line just in case it sees
	/// glue that will cause the two lines to become one. In this case it's
	/// possible that a function can appear to be called twice instead of
	/// just once, and earlier than you expect. If it's safe for your
	/// function to be called in this way (since the result and side effect
	/// of the function will not change), then you can pass 'true'.
	/// Usually, you want to pass 'false', especially if you want some action
	/// to be performed in game code when this function is called.</param>
	public void BindExternalFunction<T1, T2, T3>(string funcName, Func<T1, T2, T3, Variant> func, bool lookaheadSafe = false)
	{
		RuntimeStory?.BindExternalFunction(funcName, (Func<T1, T2, T3, object?>)trampoline, lookaheadSafe);

		object? trampoline(T1 a, T2 b, T3 c) => FromVariant(func.Invoke(a, b, c));
	}

	/// <summary>
	/// Bind a C# function to an ink EXTERNAL function declaration.
	/// </summary>
	/// <param name="funcName">EXTERNAL ink function name to bind to.</param>
	/// <param name="func">The C# function to bind.</param>
	/// <param name="lookaheadSafe">The ink engine often evaluates further
	/// than you might expect beyond the current line just in case it sees
	/// glue that will cause the two lines to become one. In this case it's
	/// possible that a function can appear to be called twice instead of
	/// just once, and earlier than you expect. If it's safe for your
	/// function to be called in this way (since the result and side effect
	/// of the function will not change), then you can pass 'true'.
	/// Usually, you want to pass 'false', especially if you want some action
	/// to be performed in game code when this function is called.</param>
	public void BindExternalFunction<T1, T2, T3, T4>(string funcName, Func<T1, T2, T3, T4, Variant> func, bool lookaheadSafe = false)
	{
		RuntimeStory?.BindExternalFunction(funcName, (Func<T1, T2, T3, T4, object?>)trampoline, lookaheadSafe);

		object? trampoline(T1 a, T2 b, T3 c, T4 d) => FromVariant(func.Invoke(a, b, c, d));
	}

	/// <summary>
	/// Bind a C# Action to an ink EXTERNAL function declaration.
	/// </summary>
	/// <param name="funcName">EXTERNAL ink function name to bind to.</param>
	/// <param name="action">The C# action to bind.</param>
	/// <param name="lookaheadSafe">The ink engine often evaluates further
	/// than you might expect beyond the current line just in case it sees
	/// glue that will cause the two lines to become one. In this case it's
	/// possible that a function can appear to be called twice instead of
	/// just once, and earlier than you expect. If it's safe for your
	/// function to be called in this way (since the result and side effect
	/// of the function will not change), then you can pass 'true'.
	/// Usually, you want to pass 'false', especially if you want some action
	/// to be performed in game code when this function is called.</param>
	public void BindExternalFunction(string funcName, Action action, bool lookaheadSafe = false)
	{
		RuntimeStory?.BindExternalFunction(funcName, action, lookaheadSafe);
	}

	/// <summary>
	/// Bind a C# Action to an ink EXTERNAL function declaration.
	/// </summary>
	/// <param name="funcName">EXTERNAL ink function name to bind to.</param>
	/// <param name="action">The C# action to bind.</param>
	/// <param name="lookaheadSafe">The ink engine often evaluates further
	/// than you might expect beyond the current line just in case it sees
	/// glue that will cause the two lines to become one. In this case it's
	/// possible that a function can appear to be called twice instead of
	/// just once, and earlier than you expect. If it's safe for your
	/// function to be called in this way (since the result and side effect
	/// of the function will not change), then you can pass 'true'.
	/// Usually, you want to pass 'false', especially if you want some action
	/// to be performed in game code when this function is called.</param>
	public void BindExternalFunction<T>(string funcName, Action<T> action, bool lookaheadSafe = false)
	{
		RuntimeStory?.BindExternalFunction(funcName, action, lookaheadSafe);
	}

	/// <summary>
	/// Bind a C# Action to an ink EXTERNAL function declaration.
	/// </summary>
	/// <param name="funcName">EXTERNAL ink function name to bind to.</param>
	/// <param name="action">The C# action to bind.</param>
	/// <param name="lookaheadSafe">The ink engine often evaluates further
	/// than you might expect beyond the current line just in case it sees
	/// glue that will cause the two lines to become one. In this case it's
	/// possible that a function can appear to be called twice instead of
	/// just once, and earlier than you expect. If it's safe for your
	/// function to be called in this way (since the result and side effect
	/// of the function will not change), then you can pass 'true'.
	/// Usually, you want to pass 'false', especially if you want some action
	/// to be performed in game code when this function is called.</param>
	public void BindExternalFunction<T1, T2>(string funcName, Action<T1, T2> action, bool lookaheadSafe = false)
	{
		RuntimeStory?.BindExternalFunction(funcName, action, lookaheadSafe);
	}

	/// <summary>
	/// Bind a C# Action to an ink EXTERNAL function declaration.
	/// </summary>
	/// <param name="funcName">EXTERNAL ink function name to bind to.</param>
	/// <param name="action">The C# action to bind.</param>
	/// <param name="lookaheadSafe">The ink engine often evaluates further
	/// than you might expect beyond the current line just in case it sees
	/// glue that will cause the two lines to become one. In this case it's
	/// possible that a function can appear to be called twice instead of
	/// just once, and earlier than you expect. If it's safe for your
	/// function to be called in this way (since the result and side effect
	/// of the function will not change), then you can pass 'true'.
	/// Usually, you want to pass 'false', especially if you want some action
	/// to be performed in game code when this function is called.</param>
	public void BindExternalFunction<T1, T2, T3>(string funcName, Action<T1, T2, T3> action, bool lookaheadSafe = false)
	{
		RuntimeStory?.BindExternalFunction(funcName, action, lookaheadSafe);
	}

	/// <summary>
	/// Bind a C# Action to an ink EXTERNAL function declaration.
	/// </summary>
	/// <param name="funcName">EXTERNAL ink function name to bind to.</param>
	/// <param name="action">The C# action to bind.</param>
	/// <param name="lookaheadSafe">The ink engine often evaluates further
	/// than you might expect beyond the current line just in case it sees
	/// glue that will cause the two lines to become one. In this case it's
	/// possible that a function can appear to be called twice instead of
	/// just once, and earlier than you expect. If it's safe for your
	/// function to be called in this way (since the result and side effect
	/// of the function will not change), then you can pass 'true'.
	/// Usually, you want to pass 'false', especially if you want some action
	/// to be performed in game code when this function is called.</param>
	public void BindExternalFunction<T1, T2, T3, T4>(string funcName, Action<T1, T2, T3, T4> action, bool lookaheadSafe = false)
	{
		RuntimeStory?.BindExternalFunction(funcName, action, lookaheadSafe);
	}

	/// <summary>
	/// Remove a binding for a named EXTERNAL ink function.
	/// </summary>
	/// <param name="funcName">The name of the EXTERNAL ink function to unbind.</param>
	public void UnbindExternalFunction(string funcName)
	{
		RuntimeStory?.UnbindExternalFunction(funcName);
	}

}