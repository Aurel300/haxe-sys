package eval.uv;

import haxe.NoData;
import haxe.async.Callback;
import haxe.io.Bytes;

extern class Pipe {
	function new();
	function write(data:Bytes, cb:Callback<NoData>):Void;
	function startRead(cb:Callback<Bytes>):Void;
	function stopRead():Void;
	function close(cb:Callback<NoData>):Void;
}
