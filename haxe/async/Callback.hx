package haxe.async;

import haxe.Error;
import haxe.NoData;

typedef CallbackData<T> = (?error:Error, ?result:T)->Void;

@:callable
abstract Callback<T>(CallbackData<T>) from CallbackData<T> {
  @:from static inline function fromOptionalErrorOnly(f:(?error:Error)->Void):Callback<NoData> return (?err:Error, ?result:NoData) -> f(err);
  @:from static inline function fromErrorOnly(f:(error:Error)->Void):Callback<NoData> return (?err:Error, ?result:NoData) -> f(err);
  @:from static inline function fromResultOnly<T>(f:(?result:T)->Void):Callback<T> return (?err:Error, ?result:T) -> f(result);
  @:from static inline function fromErrorResult<T>(f:(error:Error, result:T)->Void):Callback<T> return (?err:Error, ?result:T) -> f(err, result);
}
