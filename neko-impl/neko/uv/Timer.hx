package neko.uv;

import haxe.NoData;
import haxe.async.*;

@:access(haxe.async.Callback)
abstract Timer(Dynamic) {
	static var w_timer_start:(Loop, Int, ()->Void)->Dynamic = neko.Lib.load("uv", "w_timer_start", 3);
	static var w_timer_stop:(Dynamic, (Dynamic)->Void)->Void = neko.Lib.load("uv", "w_timer_stop", 2);
	static var w_timer_handle:(Dynamic)->Handle = neko.Lib.load("uv", "w_timer_handle", 1);

	public inline function new(timeMs:Int, cb:Void->Void) {
		this = w_timer_start(Uv.loop, timeMs, cb);
	}

	public inline function close(cb:Callback<NoData>):Void {
		w_timer_stop(this, cb.toUVNoData());
	}

	public inline function ref():Void {
		asHandle().ref();
	}

	public inline function unref():Void {
		asHandle().unref();
	}

	public inline function asHandle():Handle {
		return w_timer_handle(this);
	}
}
