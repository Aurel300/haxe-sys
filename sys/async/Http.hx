package sys.async;

import haxe.Error;
import haxe.NoData;
import haxe.async.*;
import haxe.io.Bytes;
import sys.net.Net.IPFamily;
import sys.async.net.Socket.SocketCreationOptions;

extern class Http {
  static final METHODS:Array<String>;
  static final STATUS_CODES:Map<Int, String>;
  
  static var globalAgent:Agent;
  static var maxHeaderSize:Int;
  
  static function createServer(?incomingMessages:(socket:sys.async.net.Socket)->IncomingMessage, ?serverResponses:(request:ClientRequest)->ServerResponse, ?requestListener:Listener<{request:IncomingMessage, response:ServerResponse}>):Server;
  static function get(url:String, ?options:RequestOptions, listener:Listener<IncomingMessage>):ClientRequest;
  static function request(url:String, ?options:RequestOptions, listener:Listener<IncomingMessage>):ClientRequest;
}

enum HttpHeaderValue {
  Single(s:String);
  SingleInt(i:Int);
  Multiple(as:Array<String>);
}

enum RequestOptionsAgent {
  Global;
  Create;
  Use(agent:Agent);
}

typedef RequestOptions = {
    ?agent:RequestOptionsAgent,
    ?auth:String,
    ?createConnection:(options:SocketCreationOptions, ?callback:Callback<haxe.io.Duplex>)->haxe.io.Duplex,
    ?defaultPort:Int,
    ?family:IPFamily,
    ?headers:Map<String, HttpHeaderValue>,
    ?host:String,
    ?hostname:String, // alias for host
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
  var freeSockets:Map<String, Array<sys.async.net.Socket>>;
  var maxFreeSockets:Int;
  var maxSockets:Int;
  var requests:Map<String, Array<ClientRequest>>;
  var sockets:Map<String, Array<sys.async.net.Socket>>;
  
  function new(?options:{?keepAlive:Bool, ?keepAliveMsecs:Float, ?maxSockets:Int, ?maxFreeSockets:Int, ?timeout:Float});
  function createConnection(options:SocketCreationOptions, ?callback:Callback<haxe.io.Duplex>):haxe.io.Duplex;
  function destroy():Void;
  function getName(host:String, port:Int, localAddress:String, family:IPFamily):String;
}

extern class ClientRequest extends haxe.io.Writable {
  final eventAbort:Event<NoData>;
  final eventConnect:Event<{response:IncomingMessage, socket:sys.async.net.Socket, head:Bytes}>;
  final eventContinue:Event<NoData>;
  final eventInformation:Event<{statusCode:Int}>;
  final eventResponse:Event<IncomingMessage>;
  final eventSocket:Event<sys.async.net.Socket>;
  final eventTimeout:Event<NoData>;
  final eventUpgrade:Event<{response:IncomingMessage, socket:sys.async.net.Socket, head:Bytes}>;
  
  var aborted:Bool;
  var connection:sys.async.net.Socket; // alias to socket
  var finished:Bool;
  var maxHeadersCount:Int;
  var path:String;
  var socket:sys.async.net.Socket;
  
  function abort():Void;
  // function end (from Writable)
  function flushHeaders():Void;
  function getHeader(name:String):HttpHeaderValue;
  function removeHeader(name:String):Void;
  function setHeader(name:String, value:HttpHeaderValue):Void;
  function setNoDelay(?noDelay:Bool):Void;
  function setSocketKeepAlive(?enable:Bool, ?initialDelay:Float):Void;
  function setTimeout(timeout:Float, ?callback:Listener<NoData>):Void;
  // function write (from Writable)
}

extern class ServerClientError extends Error {
  final bytesParsed:Int;
  final rawPacket:Bytes;
}

extern class Server extends sys.net.Server {
  final eventCheckContinue:Event<{request:IncomingMessage, response:ServerResponse}>;
  final eventCheckExpectation:Event<{request:IncomingMessage, response:ServerResponse}>;
  final eventClientError:Event<{exception:ServerClientError, socket:sys.async.net.Socket}>;
  // final eventClose (from Server)
  final eventConnect:Event<{request:IncomingMessage, socket:sys.async.net.Socket, head:Bytes}>;
  // final eventConnection (from Server)
  final eventRequest:Event<{request:IncomingMessage, response:ServerResponse}>;
  final eventUpgrade:Event<{request:IncomingMessage, socket:sys.async.net.Socket, head:Bytes}>;
  
  var headersTimeout:Float;
  // var listening (from Server)
  var maxHeadersCount:Int;
  var timeout:Float;
  var keepAliveTimeout:Float;
  
  function close(?callback:Callback<NoData>):Void;
  // function listen (from Server)
  function setTimeout(?msecs:Float, ?callback:Listener<NoData>):Void;
}

extern class IncomingMessage extends haxe.io.Readable {
  final eventAborted:Event<NoData>;
  // final eventClose (from Readable)
  
  var aborted:Bool;
  var complete:Bool;
  var headers:Map<String, HttpHeaderValue>;
  var httpVersion:String;
  var method:String;
  var rawHeaders:Array<String>;
  var rawTrailers:Array<String>;
  var socket:sys.async.net.Socket;
  var statusCode:Int;
  var statusMessage:String;
  var trailers:Map<String, HttpHeaderValue>;
  var url:String;
  
  function destroy(?error:Error):Void;
  function setTimeout(msecs:Float, ?callback:Listener<NoData>):Void;
}

extern class ServerResponse extends haxe.io.Writable {
  // final eventClose (from Writable)
  // final eventFinish (from Writable)
  
  var connection:sys.async.net.Socket; // alias to socket
  var finished:Bool;
  var headersSent:Bool;
  var sendDate:Bool;
  var socket:sys.async.net.Socket;
  var statusCode:Int;
  var statusMessage:String;
  
  function addTrailers(headers:Map<String, HttpHeaderValue>):Void;
  function getHeader(name:String):HttpHeaderValue;
  function getHeaderNames():Array<String>;
  function getHeaders():Map<String, HttpHeaderValue>;
  function hasHeader(name:String):Bool;
  function removeHeader(name:String):Void;
  function setHeader(name:String, value:HttpHeaderValue):Void;
  function setTimeout(msecs:Float, ?callback:Listener<NoData>):Void;
  function writeContinue():Void;
  function writeHead(statusCode:Int, ?statusMessage:String, ?headers:Map<String, HttpHeaderValue>):Void;
  function writeProcessing():Void;
}
