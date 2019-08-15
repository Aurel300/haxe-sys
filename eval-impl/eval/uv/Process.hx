package eval.uv;

import haxe.async.*;

extern class Process {
	function new(
		exitCb:Callback<{code:Int, signal:Int}>,
		file:String,
		args:Array<String>,
		env:Array<String>,
		cwd:String,
		flags:sys.uv.UVProcessSpawnFlags,
		stdio:Array<nusys.async.ProcessIO>,
		uid:Int,
		gid:Int
	);
	function kill(signal:Int):Void;
	function getPid():Int;
}
