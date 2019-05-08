package sys.io;

import haxe.Error;
import haxe.NoData;
import haxe.async.Callback;
import haxe.io.Bytes;
import haxe.io.Encoding;

extern class AsyncFile {
  // node compatibility (file descriptors)
  function appendFile(data:Bytes, ?flags:FileOpenFlags, ?mode:FileMode, callback:Callback<NoData>):Void;
  function chmod(mode:FileMode, callback:Callback<NoData>):Void;
  function chown(uid:Int, gid:Int, callback:Callback<NoData>):Void;
  function close(callback:Callback<NoData>):Void;
  function datasync(callback:Callback<NoData>):Void;
  function read(buffer:Bytes, offset:Int, length:Int, position:Int, callback:Callback<{bytesRead:Int, buffer:Bytes}>):Void;
  function readFile(?flags:FileOpenFlags, callback:Callback<Bytes>):Void;
  function stat(callback:Callback<FileStat>):Void;
  function sync(callback:Callback<NoData>):Void;
  function truncate(?len:Int = 0, callback:Callback<NoData>):Void;
  function utimes(atime:Date, mtime:Date, callback:Callback<NoData>):Void;
  function write(buffer:Bytes, offset:Int, length:Int, position:Int, callback:Callback<{bytesWritten:Int, buffer:Bytes}>):Void;
  function writeString(str:String, ?position:Int, ?encoding:Encoding, callback:Callback<{bytesWritten:Int, buffer:Bytes}>):Void;
  function writeFile(data:Bytes, ?flags:FileOpenFlags, ?mode:FileMode, callback:Callback<NoData>):Void;
}
