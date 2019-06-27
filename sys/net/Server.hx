package sys.net;

import haxe.Error;
import haxe.NoData;
import haxe.async.*;
import sys.net.Net.SocketAddress;

extern class Server {
  final closeSignal:Signal<NoData>;
  final connectionSignal:Signal<sys.async.net.Socket>;
  final errorSignal:Signal<Error>;
  final listeningSignal:Signal<NoData>;
  
  var listening(default, null):Bool;
  var maxConnections:Int;
  
  // net.createServer
  function new(?options:{?allowHalfOpen:Bool, ?pauseOnConnect:Bool}, ?connectionListener:Listener<sys.async.net.Socket>);
  
  function address():SocketAddress;
  function close(?callback:Callback<NoData>):Void;
  function getConnections(callback:Callback<Int>):Void;
  function listenSocket(socket:Socket, ?backlog:Int, ?listener:Listener<NoData>):Void;
  function listenServer(server:Server, ?backlog:Int, ?listener:Listener<NoData>):Void;
  function listenFile(file:sys.io.File, ?backlog:Int, ?listener:Listener<NoData>):Void;
  function listenIPC(path:String, ?backlog:Int, ?options:{?exclusive:Bool, ?readableAll:Bool, ?writableAll:Bool}, ?listener:Listener<NoData>):Void;
  function listenTCP(?port:Int, ?host:String, ?backlog:Int, ?options:{?exclusive:Bool, ?ipv6only:Bool}, ?listener:Listener<NoData>):Void;
  function ref():Void;
  function unref():Void;
}
