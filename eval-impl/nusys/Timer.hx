package nusys;

class Timer {
	var native:eval.uv.Timer;

	public static function delay(f:() -> Void, timeMs:Int):Timer {
		var t = new Timer(timeMs);
		t.run = function() {
			t.stop();
			f();
		};
		return t;
	}

	public static function measure<T>(f:()->T, ?pos:haxe.PosInfos):T {
		var t0 = stamp();
		var r = f();
		haxe.Log.trace((stamp() - t0) + "s", pos);
		return r;
	}

	public static function stamp():Float {
		return Sys.time();
	}

	public function new(timeMs:Int) {
		native = new eval.uv.Timer(timeMs, () -> run());
	}

	public dynamic function run():Void {}

	public function stop():Void {
		native.close((err) -> {});
	}

	public function ref():Void {
		native.ref();
	}

	public function unref():Void {
		native.unref();
	}
}
