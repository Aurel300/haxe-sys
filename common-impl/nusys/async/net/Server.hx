package nusys.async.net;

import haxe.Error;
import haxe.NoData;
import haxe.async.*;
import nusys.net.*;

typedef ServerOptions = {
	?allowHalfOpen:Bool,
	?pauseOnConnect:Bool
};

typedef ServerListenTcpOptions = {
	?port:Int,
	?host:String,
	?address:Address,
	?backlog:Int,
	?exclusive:Bool,
	?ipv6only:Bool
};

extern class Server {
	final closeSignal:Signal<NoData>;
	final connectionSignal:Signal<Socket>;
	final errorSignal:Signal<Error>;
	final listeningSignal:Signal<NoData>;
	var listening(default, null):Bool;
	var maxConnections:Int;

	function new(?options:ServerOptions);

	// function address():SocketAddress;
	function close(?callback:Callback<NoData>):Void;
	// function getConnections(callback:Callback<Int>):Void;
	// function listenSocket(socket:Socket, ?backlog:Int, ?listener:Listener<NoData>):Void;
	// function listenServer(server:Server, ?backlog:Int, ?listener:Listener<NoData>):Void;
	// function listenFile(file:sys.io.File, ?backlog:Int, ?listener:Listener<NoData>):Void;
	// function listenIPC(path:String, ?backlog:Int, ?options:{?exclusive:Bool, ?readableAll:Bool, ?writableAll:Bool}, ?listener:Listener<NoData>):Void;
	function listenTcp(options:ServerListenTcpOptions, ?listener:Listener<Socket>):Void;

	// function ref():Void;
	// function unref():Void;
}
