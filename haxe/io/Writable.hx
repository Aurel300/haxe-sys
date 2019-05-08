package haxe.io;

import haxe.Error;
import haxe.NoData;
import haxe.async.Callback;
import haxe.async.Event;
import haxe.async.EventEmitter;

extern class Writable extends EventEmitter implements IWritable {
  final eventClose:Event<NoData>; // = new Event(this, "close");
  final eventDrain:Event<NoData>; // = new Event(this, "drain");
  final eventError:Event<Error>; // = new Event(this, "error");
  final eventFinish:Event<NoData>; // = new Event(this, "finish");
  final eventPipe:Event<IReadable>; // = new Event(this, "pipe");
  final eventUnpipe:Event<IReadable>; // = new Event(this, "unpipe");
  
  var writable(default, null):Bool;
  var writableHighWaterMark(default, null):Int;
  var writableLength(default, null):Int;
  
  function new();
  function cork():Void;
  function destroy(?error:Error):Void;
  function end(?chunk:Bytes, callback:Callback<NoData>):Void;
  function uncork():Void;
  function write(chunk:Bytes, callback:Callback<NoData>):Bool;
}
