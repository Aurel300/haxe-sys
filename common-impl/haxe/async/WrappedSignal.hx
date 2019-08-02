package haxe.async;

import haxe.NoData;

class WrappedSignal<T> implements Signal<T> {
	final listeners:Array<Listener<T>> = [];
	public final changeSignal:Signal<NoData> = new ArraySignal<NoData>();

	function get_listenerCount():Int {
		return listeners.length;
	}

	public var listenerCount(get, never):Int;

	public function new() {}

	public function on(listener:Listener<T>):Void {
		listeners.push(listener);
		changeSignal.emit(new NoData());
	}

	public function once(listener:Listener<T>):Void {
		listeners.push(function wrapped(data:T):Void {
			listeners.remove(wrapped);
			changeSignal.emit(new NoData());
			listener(data);
		});
		changeSignal.emit(new NoData());
	}

	public function off(?listener:Listener<T>):Void {
		if (listener != null) {
			listeners.remove(listener);
		} else {
			listeners.resize(0);
		}
		changeSignal.emit(new NoData());
	}

	public function emit(data:T):Void {
		for (listener in listeners) {
			listener(data);
		}
	}
}
