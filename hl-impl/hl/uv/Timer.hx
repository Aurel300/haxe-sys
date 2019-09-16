package hl.uv;

import haxe.NoData;
import haxe.async.*;

private typedef Native = hl.Abstract<"uv_timer_t">;

@:access(haxe.async.Callback)
abstract Timer(Native) {
	@:hlNative("uv", "w_timer_start") static function w_timer_start(_:Loop, _:Int, _:Void->Void):Native return null;
	@:hlNative("uv", "w_timer_stop") static function w_timer_stop(_:Native, _:Dynamic->Void):Void {}
	@:hlNative("uv", "w_timer_handle") static function w_timer_handle(_:Native):Handle return null;

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
