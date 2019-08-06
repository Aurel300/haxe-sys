package eval.uv;

import haxe.NoData;
import haxe.async.Callback;
import haxe.io.Bytes;
import sys.net.Address;

extern class Socket {
	function new();
	function connectTCP(port:Int, cb:Callback<NoData>):Void;
	function write(data:Bytes, cb:Callback<NoData>):Void;
	function end(cb:Callback<NoData>):Void;
	function startRead(cb:Callback<Bytes>):Void;
	function stopRead():Void;
	function bindTCP(host:Address, port:Int, ipv6only:Bool):Void;
	function listen(backlog:Int, cb:Callback<NoData>):Void;
	function accept():Socket;
	function close(cb:Callback<NoData>):Void;
}
