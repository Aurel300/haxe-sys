package eval.uv;

import haxe.NoData;
import haxe.async.Callback;
import haxe.io.Bytes;
import nusys.net.*;

extern class Pipe {
	function new();
	function connectIpc(path:String, cb:Callback<NoData>):Void;
	function bindIpc(path:String):Void;
	function accept():Pipe;
	function getSockName():SocketAddress;
	function getPeerName():SocketAddress;
	function asStream():Stream;
}
