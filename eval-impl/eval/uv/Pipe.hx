package eval.uv;

import haxe.NoData;
import haxe.async.Callback;
import haxe.io.Bytes;

extern class Pipe {
	function new();
	function connectIpc(path:String, cb:Callback<NoData>):Void;
	function bindIpc(path:String):Void;
	function accept():Pipe;
	function asStream():Stream;
}
