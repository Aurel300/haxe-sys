package neko.uv;

import haxe.NoData;
import haxe.async.*;

@:access(String)
abstract Process(Dynamic) {
	static var w_spawn:(neko.NativeArray<Dynamic>)->Dynamic = neko.Lib.load("uv", "w_spawn_dyn", 1);
	static var w_process_kill:(Dynamic, Int)->Void = neko.Lib.load("uv", "w_process_kill", 2);
	static var w_process_get_pid:(Dynamic)->Int = neko.Lib.load("uv", "w_process_get_pid", 1);
	static var w_process_handle:(Dynamic)->Handle = neko.Lib.load("uv", "w_process_handle", 1);

	public inline function new(
		exitCb:Callback<{code:Int, signal:Int}>,
		file:String,
		args:Array<String>,
		env:Array<String>,
		cwd:String,
		flags:asys.uv.UVProcessSpawnFlags,
		stdio:Array<ProcessIO>,
		uid:Int,
		gid:Int
	) {
		var args_u = neko.NativeArray.alloc(args.length);
		for (i in 0...args.length)
			args_u[i] = NativeString.ofString(args[i]);
		var env_u = neko.NativeArray.alloc(env.length);
		for (i in 0...env.length)
			env_u[i] = NativeString.ofString(env[i]);
		var stdio_u = neko.NativeArray.alloc(stdio.length);
		for (i in 0...stdio.length)
			stdio_u[i] = stdio[i];
		this = w_spawn(neko.NativeArray.ofArrayRef(([
			Uv.loop,
			(code, signal) -> exitCb(null, {code: code, signal: signal}),
			NativeString.ofString(file),
			args_u,
			env_u,
			NativeString.ofString(cwd),
			@:privateAccess flags.get_raw(),
			stdio_u,
			uid,
			gid
		]:Array<Dynamic>)));
	}

	public inline function kill(signal:Int):Void {
		w_process_kill(this, signal);
	}

	public inline function getPid():Int {
		return w_process_get_pid(this);
	}

	public inline function close(cb:Callback<haxe.NoData>):Void {
		asHandle().close(cb);
	}

	public inline function ref():Void {
		asHandle().ref();
	}

	public inline function unref():Void {
		asHandle().unref();
	}

	public inline function asHandle():Handle {
		return w_process_handle(this);
	}
}

enum ProcessIO {
	Ignore;
	Inherit;
	Pipe(readable:Bool, writable:Bool, pipe:Stream);
	Ipc(pipe:Stream);
	// Stream(_);
	// Fd(_);
}
