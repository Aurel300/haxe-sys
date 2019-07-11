package haxe.io;

import haxe.NoData;
import haxe.async.Callback;

extern class Stream {
  static function finished(stream:IStream, ?options:{?error:Bool = true, ?readable:Bool = true, ?writable:Bool = true}, callback:Callback<NoData>):Void;
  static function pipeline(streams:Array<IStream>, callback:Callback<NoData>):Void;
}
