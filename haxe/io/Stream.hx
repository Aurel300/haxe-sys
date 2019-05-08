package haxe.io;

import haxe.NoData;
import haxe.async.Callback;

extern class Stream {
  // IStream would be a common parent to both IReadable and IWritable
  //static function finished(stream:IStream, ?error:Bool = true, ?readable:Bool = true, ?writable:Bool = true, callback:Callback<NoData>):Void;
  //static function pipeline(streams:Array<IStream>, callback:Callback<NoData>):Void;
}
