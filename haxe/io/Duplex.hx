package haxe.io;

import haxe.Error;
import haxe.NoData;
import haxe.async.Callback;
import haxe.async.Event;
import haxe.async.EventEmitter;

extern class Duplex extends EventEmitter implements IReadable implements IWritable {
  final eventClose:Event<NoData>; // = new Event(this, "close");
  final eventData:Event<Bytes>; // = new Event(this, "data");
  final eventDrain:Event<NoData>; // = new Event(this, "drain");
  final eventEnd:Event<NoData>; // = new Event(this, "end");
  final eventError:Event<Error>; // = new Event(this, "error");
  final eventFinish:Event<NoData>; // = new Event(this, "finish");
  final eventPause:Event<NoData>; // = new Event(this, "pause");
  final eventPipe:Event<IReadable>; // = new Event(this, "pipe");
  final eventReadable:Event<NoData>; // = new Event(this, "readable");
  final eventResume:Event<NoData>; // = new Event(this, "resume");
  final eventUnpipe:Event<IReadable>; // = new Event(this, "unpipe");
  
  var readable(default, null):Bool;
  var readableHighWaterMark(default, null):Int;
  var readableLength(default, null):Int;
  var writable(default, null):Bool;
  var writableHighWaterMark(default, null):Int;
  var writableLength(default, null):Int;

  function new();
  function cork():Void;
  function destroy(?error:Error):Void;
  function end(?chunk:Bytes, callback:Callback<NoData>):Void;
  function isPaused():Bool;
  function pause():Void;
  function pipe(destination:IWritable, ?end:Bool = true):IWritable;
  function read(?size:Int):Bytes;
  function resume():Void;
  function uncork():Void;
  function unpipe(?destination:IWritable):Void;
  function unshift(chunk:Bytes):Void;
  function write(chunk:Bytes, callback:Callback<NoData>):Bool;
}
