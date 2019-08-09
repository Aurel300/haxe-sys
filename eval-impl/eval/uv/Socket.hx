package eval.uv;

import haxe.NoData;
import haxe.async.Callback;
import haxe.io.Bytes;
import nusys.net.Address;

extern class Socket {
	function new();
	function connectTcp(address:Address, port:Int, cb:Callback<NoData>):Void;
	function write(data:Bytes, cb:Callback<NoData>):Void;
	function end(cb:Callback<NoData>):Void;
	function startRead(cb:Callback<Bytes>):Void;
	function stopRead():Void;
	function bindTcp(host:Address, port:Int, ipv6only:Bool):Void;
	function listen(backlog:Int, cb:Callback<NoData>):Void;
	function accept():Socket;
	function close(cb:Callback<NoData>):Void;
	function setKeepAlive(enable:Bool, initialDelay:Int):Void;
	function setNoDelay(noDelay:Bool):Void;
}
