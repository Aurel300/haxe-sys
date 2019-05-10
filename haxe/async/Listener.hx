package haxe.async;

import haxe.NoData;

typedef ListenerData<T> = (data:T)->Void;

@:callable
abstract Listener<T>(ListenerData<T>) from ListenerData<T> {
  @:from static inline function fromNoArguments(f:()->Void):Listener<NoData> return (data:NoData) -> f();
}
