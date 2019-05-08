package haxe.io;

import haxe.Error;
import haxe.NoData;
import haxe.async.Event;
import haxe.async.EventEmitter;

extern class Readable extends EventEmitter implements IReadable {
  final eventClose:Event<NoData>; // = new Event(this, "close");
  final eventData:Event<Bytes>; // = new Event(this, "data");
  final eventEnd:Event<NoData>; // = new Event(this, "end");
  final eventError:Event<Error>; // = new Event(this, "error");
  final eventPause:Event<NoData>; // = new Event(this, "pause");
  final eventReadable:Event<NoData>; // = new Event(this, "readable");
  final eventResume:Event<NoData>; // = new Event(this, "resume");
  
  var readable(default, null):Bool;
  var readableHighWaterMark(default, null):Int;
  var readableLength(default, null):Int;
  
  function new();
  function destroy(?error:Error):Void;
  function isPaused():Bool;
  function pause():Void;
  function pipe(destination:IWritable, ?end:Bool = true):IWritable;
  function read(?size:Int):Bytes;
  function resume():Void;
  function unpipe(?destination:IWritable):Void;
  function unshift(chunk:Bytes):Void;
}

