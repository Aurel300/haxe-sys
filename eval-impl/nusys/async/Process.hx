package nusys.async;

import haxe.Error;
import haxe.NoData;
import haxe.async.*;
import haxe.io.*;
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
		var native = new eval.uv.Process(
			(err, data) -> proc.exitSignal.emit(data),
			command,
			args,
			options.env != null ? [ for (k => v in options.env) '$k=$v' ] : [],
			options.cwd,
			flags,
			[Inherit, Inherit, Inherit],
			options.uid != null ? options.uid : 0,
			options.gid != null ? options.gid : 0
		);
		proc.native = native;
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
	public var stderr:IReadable;
	public var stdin:IWritable;
	public var stdout:IReadable;
	//stdio

	var native:eval.uv.Process;

	function new() {}

	function get_pid():Int {
		return native.getPid();
	}

	// public function disconnect():Void; // IPC

	public function kill(?signal:Int = 7):Void {
		native.kill(signal);
	}

	public function ref():Void {}
	// public function send(); // IPC
	public function unref():Void {}
}

typedef ProcessExit = {code:Int, signal:Int};
