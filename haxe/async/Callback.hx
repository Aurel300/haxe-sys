package haxe.async;

import haxe.Error;

typedef CallbackData<T> = (?error:Error, ?result:T)->Void;

@:callable
abstract Callback<T>(CallbackData<T>) from CallbackData<T> {
  @:from static inline function fromErrorOnly<T>(f:(?error:Error)->Void):Callback<T> return (?err, ?result) -> f(err);
  @:from static inline function fromResultOnly<T>(f:(?result:T)->Void):Callback<T> return (?err, ?result) -> f(result);
}
