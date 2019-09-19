package neko.uv;

abstract Loop(Dynamic) {
	static var w_loop_init:()->Dynamic = neko.Lib.load("uv", "w_loop_init", 0);
	static var w_loop_close:(Dynamic)->Void = neko.Lib.load("uv", "w_loop_close", 1);
	static var w_run:(Dynamic, asys.uv.UVRunMode)->Bool = neko.Lib.load("uv", "w_run", 2);
	static var w_loop_alive:(Dynamic)->Bool = neko.Lib.load("uv", "w_loop_alive", 1);
	static var w_stop:(Dynamic)->Void = neko.Lib.load("uv", "w_stop", 1);

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
