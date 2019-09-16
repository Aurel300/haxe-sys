package hl.uv;

private typedef Native = hl.Abstract<"uv_loop_t">;

abstract Loop(Native) {
	@:hlNative("uv", "w_loop_init") static function w_loop_init():Native return null;
	@:hlNative("uv", "w_loop_close") static function w_loop_close(loop:Native):Void {}
	@:hlNative("uv", "w_run") static function w_run(loop:Native, mode:asys.uv.UVRunMode):Bool return false;
	@:hlNative("uv", "w_loop_alive") static function w_loop_alive(loop:Native):Bool return false;
	@:hlNative("uv", "w_stop") static function w_stop(loop:Native):Void {}

	public inline function new() {
		this = w_loop_init();
	}

	public inline function close():Void {
		w_loop_close(this);
	}

	public inline function run(mode:asys.uv.UVRunMode):Bool {
		return w_run(this, mode);
	}

	public inline function loopAlive():Bool {
		return w_loop_alive(this);
	}

	public inline function stop():Void {
		w_stop(this);
	}
}
