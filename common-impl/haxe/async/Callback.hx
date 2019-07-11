package haxe.async;

import haxe.Error;
import haxe.NoData;

typedef CallbackData<T> = (?error:Error, ?result:T) -> Void;

/**
	A signal callback. Callbacks in the standard library accept an optional error (`haxe.Error`) and an optional result, as declared in `CallbackData`.

	This abstract defines multiple `@:from` conversions to improve readability of callback code.
**/
@:callable
abstract Callback<T>(CallbackData<T>) from CallbackData<T> {
	@:from static inline function fromOptionalErrorOnly(f:(?error:Error) -> Void):Callback<NoData> return (?err:Error, ?result:NoData) -> f(err);

	@:from static inline function fromErrorOnly(f:(error:Error) -> Void):Callback<NoData> return (?err:Error, ?result:NoData) -> f(err);

	@:from static inline function fromResultOnly<T>(f:(?result:T) -> Void):Callback<T> return (?err:Error, ?result:T) -> f(result);

	@:from static inline function fromErrorResult<T>(f:(error:Error, result:T) -> Void):Callback<T> return (?err:Error, ?result:T) -> f(err, result);

	#if hl
	private inline function toUVNoData() return (error) -> this(error, null);
	#end
}
