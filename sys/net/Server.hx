package sys.net;

import haxe.Error;
import haxe.NoData;
import haxe.async.Callback;
import haxe.async.Event;
import sys.net.Net.SocketAddress;

extern class Server {
  final eventClose:Event<NoData>;
  final eventConnection:Event<Socket>;
  final eventError:Event<Error>;
  final eventListening:Event<NoData>;
  
  var listening(default, null):Bool;
  var maxConnections:Int;
  
  // net.createServer
  function new(?allowHalfOpen:Bool, ?pauseOnConnect:Bool, ?connectionListener:Callback<Socket>);
  
  function address():SocketAddress;
  function close(?callback:Callback<NoData>):Void;
  function getConnections(callback:Callback<Int>):Void;
  function listenSocket(socket:Socket, ?backlog:Int, ?callback:Callback<NoData>):Void;
  function listenServer(server:Server, ?backlog:Int, ?callback:Callback<NoData>):Void;
  function listenFile(file:sys.io.File, ?backlog:Int, ?callback:Callback<NoData>):Void;
  function listenIPC(path:String, ?backlog:Int, ?exclusive:Bool, ?readableAll:Bool, ?writableAll:Bool, ?callback:Callback<NoData>):Void;
  function listenTCP(?port:Int, ?host:String, ?backlog:Int, ?exclusive:Bool, ?ipv6only:Bool, ?callback:Callback<NoData>):Void;
  function ref():Void;
  function unref():Void;
}
