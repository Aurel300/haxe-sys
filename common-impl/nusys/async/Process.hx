package nusys.async;

import haxe.Error;
import haxe.NoData;
import haxe.async.*;
import haxe.io.*;

typedef ProcessSpawnOptions = {
	?cwd:String,
	?env:Map<String, String>,
	?argv0:String,
	//?stdio:?,
	?detached:Bool,
	?uid:Int,
	?gid:Int,
	//?shell:?,
	?windowsVertbatimArguments:Bool,
	?windowsHide:Bool
};

extern class Process {
	static function spawn(command:String, ?args:Array<String>, ?options:ProcessSpawnOptions):Process;

	final closeSignal:Signal<NoData>;
	final disconnectSignal:Signal<NoData>;
	final errorSignal:Signal<Error>;
	final exitSignal:Signal<Int>;
	// final messageSignal:Signal<String>; // IPC

	// var channel:IDuplex; // IPC
	// var connected:Bool; // IPC
	var killed:Bool;
	var pid:Int;
	var stderr:IReadable;
	var stdin:IWritable;
	var stdout:IReadable;
	//stdio

	// function disconnect():Void; // IPC
	function kill(?signal:Int):Void;
	function ref():Void;
	// function send(); // IPC
	function unref():Void;
}
