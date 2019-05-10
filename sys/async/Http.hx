package sys.async;

import haxe.Error;
import haxe.NoData;
import haxe.async.Callback;
import haxe.async.Event;
import haxe.io.Bytes;
import sys.net.Socket;
import sys.net.Net.IPFamily;

extern class Http {
  static final METHODS:Array<String>;
  static final STATUS_CODES:Map<Int, String>;
  
  static var globalAgent:Agent;
  static var maxHeaderSize:Int;
  
  static function createServer(?requestListener:Callback<{request:IncomingMessage, response:ServerResponse}>):Server;
  static function get(url:String, ?opt:RequestOptions, callback:Callback<IncomingMessage>):ClientRequest;
  static function request(url:String, ?opt:RequestOptions, callback:Callback<IncomingMessage>):ClientRequest;
}

typedef RequestOptions = {
    ?agent:Agent, // differentiate: passed-in agent, no agent (create), no agent (global)
    ?auth:String,
    ?createConnection:()->haxe.io.Duplex,
    ?defaultPort:Int,
    ?family:IPFamily,
    ?headers:Map<String, String>,
    ?host:String,
    // ?hostname:String, // alias for host
    ?localAddress:String,
    ?method:String,
    ?path:String,
    ?port:Int,
    ?protocol:String,
    ?setHost:Bool,
    ?socketPath:String,
    ?timeout:Float
  };

extern class Agent {
  // var freeSockets:Map<String, Array<Socket>>; //?
  var maxFreeSockets:Int;
  var maxSockets:Int;
  // var requests:?
  // var sockets:?
  
  function new(?keepAlive:Bool, ?keepAliveMsecs:Float, ?maxSockets:Int, ?maxFreeSockets:Int, ?timeout:Float);
  function destroy():Void;
  function getName(host:String, port:Int, localAddress:String, family:IPFamily):String;
}

extern class ClientRequest { // extends Writable
  final eventAbort:Event<NoData>;
  final eventConnect:Event<{response:IncomingMessage, socket:Socket, head:Bytes}>;
  final eventContinue:Event<NoData>;
  final eventInformation:Event<{statusCode:Int}>;
  final eventResponse:Event<IncomingMessage>;
  final eventSocket:Event<Socket>;
  final eventTimeout:Event<NoData>;
  final eventUpgrade:Event<{response:IncomingMessage, socket:Socket, head:Bytes}>;
  
  var aborted:Bool;
  // var connection:Socket; // alias to socket
  var finished:Bool;
  var maxHeadersCount:Int;
  var path:String;
  var socket:Socket;
  
  function abort():Void;
  // function end(?data:Bytes, ?callback:Callback<NoData>):Void;
  function flushHeaders():Void;
  function getHeader(name:String):String; // Node.js has Dynamic return here
  function removeHeader(name:String):Void;
  function setHeader(name:String, value:Dynamic):Void; // ...
  function setNoDelay(?noDelay:Bool):Void;
  function setSocketKeepAlive(?enable:Bool, ?initialDelay:Float):Void;
  function setTimeout(timeout:Float, ?callback:Callback<NoData>):Void;
  // write
}

extern class Server extends sys.net.Server {
  final eventCheckContinue:Event<{request:IncomingMessage, response:ServerResponse}>;
  final eventCheckExpectation:Event<{request:IncomingMessage, response:ServerResponse}>;
  
  // exception here has has .bytesParsed and .rawPacket
  final eventClientError:Event<{exception:Error, socket:Socket}>;
  
  // final eventClose:Event<NoData>;
  final eventConnect:Event<{request:IncomingMessage, socket:Socket, head:Bytes}>;
  // final eventConnection:Event<Socket>;
  final eventRequest:Event<{request:IncomingMessage, response:ServerResponse}>;
  final eventUpgrade:Event<{request:IncomingMessage, socket:Socket, head:Bytes}>;
  
  var headersTimeout:Float;
  // var listening:Bool;
  var maxHeadersCount:Int;
  var timeout:Float;
  var keepAliveTimeout:Float;
  
  function close(?callback:Callback<NoData>):Void;
  // function listen():Void;
  function setTimeout(?msecs:Float, ?callback:Callback<NoData>):Void;
}

extern class IncomingMessage extends haxe.io.Readable {
  final eventAborted:Event<NoData>;
  // final eventClose:Event<NoData>;
  
  var aborted:Bool;
  var complete:Bool;
  var headers:Map<String, String>; // may be an array...
  var httpVersion:String;
  var method:String;
  var rawHeaders:Array<String>;
  var rawTrailers:Array<String>;
  var socket:Socket;
  var statusCode:Int;
  var statusMessage:String;
  var trailers:Map<String, String>;
  var url:String;
  
  function destroy(?error:Error):Void;
  function setTimeout(msecs:Float, ?callback:Callback<NoData>):Void;
}

extern class ServerResponse extends haxe.io.Writable {
  // event: close, finish

  // var connection:Socket; // alias to socket
  var finished:Bool;
  var headersSent:Bool;
  var sendDate:Bool;
  var socket:Socket;
  var statusCode:Int;
  var statusMessage:String;
  
  function addTrailers(headers:Map<String, String>):Void;
  function getHeader(name:String):String; // Node.js has Dynamic return
  function getHeaderNames():Array<String>;
  function getHeaders():Map<String, String>; // dynamic?
  function hasHeader(name:String):Bool;
  function removeHeader(name:String):Void;
  function setHeader(name:String, value:Dynamic):Void; // ...
  function setTimeout(msecs:Float, ?callback:Callback<NoData>):Void;
  function writeContinue():Void;
  function writeHead(statusCode:Int, ?statusMessage:String, ?headers:Map<String, Dynamic>):Void;
  function writeProcessing():Void;
}
