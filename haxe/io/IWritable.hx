package haxe.io;

import haxe.Error;
import haxe.NoData;
import haxe.async.Callback;
import haxe.async.Event;

interface IWritable {
  final eventClose:Event<NoData>;
  final eventDrain:Event<NoData>;
  final eventError:Event<haxe.Error>;
  final eventFinish:Event<NoData>;
  final eventPipe:Event<IReadable>;
  final eventUnpipe:Event<IReadable>;
  
  var writable(default, null):Bool;
  var writableHighWaterMark(default, null):Int;
  var writableLength(default, null):Int;
  
  function cork():Void;
  function destroy(?error:Error):Void;
  function end(?chunk:Bytes, callback:Callback<NoData>):Void;
  function uncork():Void;
  function write(chunk:Bytes, callback:Callback<NoData>):Bool;
}
