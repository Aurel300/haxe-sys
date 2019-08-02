package haxe.async;

interface Signal<T> {
	var listenerCount(get, never):Int;
	function on(listener:Listener<T>):Void;
	function once(listener:Listener<T>):Void;
	function off(?listener:Listener<T>):Void;
	function emit(data:T):Void;
}
