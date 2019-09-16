package hl.uv;

import haxe.NoData;
import haxe.async.*;

private typedef Native = hl.Abstract<"uv_process_t">;

@:access(String)
abstract Process(Native) {
	@:hlNative("uv", "w_spawn") static function w_spawn(
		loop:Loop,
		exitCb:Int->Int->Void,
		file:hl.Bytes,
		args:hl.NativeArray<hl.Bytes>,
		env:hl.NativeArray<hl.Bytes>,
		cwd:hl.Bytes,
		flags:Int,
		stdio:hl.NativeArray<ProcessIO>,
		uid:Int,
		gid:Int
	):Native return null;
	@:hlNative("uv", "w_process_kill") static function w_process_kill(_:Native, _:Int):Void {}
	@:hlNative("uv", "w_process_get_pid") static function w_process_get_pid(_:Native):Int return 0;
	@:hlNative("uv", "w_process_handle") static function w_process_handle(_:Native):Handle return null;

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
		var args_u = new hl.NativeArray<hl.Bytes>(args.length);
		for (i in 0...args.length)
			args_u[i] = args[i].toUtf8();
		var env_u = new hl.NativeArray<hl.Bytes>(env.length);
		for (i in 0...env.length)
			env_u[i] = env[i].toUtf8();
		var stdio_u = new hl.NativeArray<ProcessIO>(stdio.length);
		for (i in 0...stdio.length)
			stdio_u[i] = stdio[i];
		this = w_spawn(
			Uv.loop,
			(code, signal) -> exitCb(null, {code: code, signal: signal}),
			file.toUtf8(),
			args_u,
			env_u,
			cwd.toUtf8(),
			@:privateAccess flags.get_raw(),
			stdio_u,
			uid,
			gid
		);
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
