package nusys.async;

import haxe.Error;
import haxe.NoData;
import haxe.async.*;
import haxe.io.*;
import nusys.io.*;
import sys.uv.UVProcessSpawnFlags;

typedef ProcessSpawnOptions = {
	?cwd:String,
	?env:Map<String, String>,
	?argv0:String,
	?stdio:Array<ProcessIO>,
	?detached:Bool,
	?uid:Int,
	?gid:Int,
	//?shell:?,
	?windowsVerbatimArguments:Bool,
	?windowsHide:Bool
};

class Process {
	public static function spawn(command:String, ?args:Array<String>, ?options:ProcessSpawnOptions):Process {
		var proc = new Process();
		var flags:UVProcessSpawnFlags = None;
		if (options == null)
			options = {};
		if (options.detached)
			flags |= UVProcessSpawnFlags.Detached;
		if (options.uid != null)
			flags |= UVProcessSpawnFlags.SetUid;
		if (options.gid != null)
			flags |= UVProcessSpawnFlags.SetGid;
		if (options.windowsVerbatimArguments)
			flags |= UVProcessSpawnFlags.WindowsVerbatimArguments;
		if (options.windowsHide)
			flags |= UVProcessSpawnFlags.WindowsHide;
		if (options.stdio == null)
			options.stdio = [Pipe(true, false), Pipe(false, true), Pipe(false, true)];
		var stdin:IWritable = null;
		var stdout:IReadable = null;
		var stderr:IReadable = null;
		var stdioPipes = [];
		var nativeStdio:Array<eval.uv.Process.ProcessIO> = [
			for (i in 0...options.stdio.length)
				switch (options.stdio[i]) {
					case Pipe(r, w, pipe):
						if (pipe == null)
							pipe = Pipe.create();
						switch (i) {
							case 0 if (r && !w):
								stdin = pipe;
							case 1 if (!r && w):
								stdout = pipe;
							case 2 if (!r && w):
								stderr = pipe;
							case _:
						}
						stdioPipes[i] = pipe;
						Pipe(r, w, @:privateAccess pipe.native);
					case Ignore:
						Ignore;
					case Inherit:
						Inherit;
				}
		];
		var args = args != null ? args : [];
		if (options.argv0 != null)
			args.unshift(options.argv0);
		else
			args.unshift(command);
		var native = new eval.uv.Process(
			(err, data) -> proc.exitSignal.emit(data),
			command,
			args,
			options.env != null ? [ for (k => v in options.env) '$k=$v' ] : [],
			options.cwd != null ? options.cwd : Sys.getCwd(),
			flags,
			nativeStdio,
			options.uid != null ? options.uid : 0,
			options.gid != null ? options.gid : 0
		);
		proc.native = native;
		proc.stdin = stdin;
		proc.stdout = stdout;
		proc.stderr = stderr;
		proc.stdio = stdioPipes;
		return proc;
	}

	public final closeSignal:Signal<NoData> = new ArraySignal();
	public final disconnectSignal:Signal<NoData> = new ArraySignal();
	public final errorSignal:Signal<Error> = new ArraySignal();
	public final exitSignal:Signal<ProcessExit> = new ArraySignal();
	// public final messageSignal:Signal<String>; // IPC

	// public var channel:IDuplex; // IPC
	// public var connected:Bool; // IPC
	public var killed:Bool;
	public var pid(get, never):Int;
	public var stdin:IWritable;
	public var stdout:IReadable;
	public var stderr:IReadable;
	public var stdio:Array<Pipe>;

	var native:eval.uv.Process;

	function new() {}

	function get_pid():Int {
		return native.getPid();
	}

	// public function disconnect():Void; // IPC

	public function kill(?signal:Int = 7):Void {
		native.kill(signal);
	}

	public function close(?cb:Callback<NoData>):Void {
		var needed = 1;
		var closed = 0;
		function close(err:Error, _:NoData):Void {
			closed++;
			if (closed == needed && cb != null)
				cb(null, new NoData());
		}
		for (pipe in stdio) {
			if (pipe != null) {
				needed++;
				pipe.close(close);
			}
		}
		native.close(close);
	}

	public function ref():Void {
		native.ref();
	}

	// public function send(); // IPC

	public function unref():Void {
		native.unref();
	}
}
