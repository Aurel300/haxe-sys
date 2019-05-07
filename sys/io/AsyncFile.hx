package sys.io;

import haxe.Error;
import haxe.io.Bytes;
import haxe.io.Encoding;

extern class AsyncFile {
  // node compatibility (file descriptors)
  function appendFile(data:Bytes, ?flags:FileOpenFlags, ?mode:FileMode, callback:(?error:Error)->Void):Void;
  function chmod(mode:FileMode, callback:(?error:Error)->Void):Void;
  function chown(uid:Int, gid:Int, callback:(?error:Error)->Void):Void;
  function close(callback:(?error:Error)->Void):Void;
  function datasync(callback:(?error:Error)->Void):Void;
  function read(buffer:Bytes, offset:Int, length:Int, position:Int, callback:(?error:Error, ?bytesRead:Int, ?buffer:Bytes)->Void):Void;
  function readFile(?flags:FileOpenFlags, callback:(?error:Error, ?bytes:Bytes)->Void):Void;
  function stat(callback:(?error:Error, ?stats:FileStat)->Void):Void;
  function sync(callback:(?error:Error)->Void):Void;
  function truncate(?len:Int = 0, callback:(?error:Error)->Void):Void;
  function utimes(atime:Date, mtime:Date, callback:(?error:Error)->Void):Void;
  function write(buffer:Bytes, offset:Int, length:Int, position:Int, callback:(?error:Error, ?bytesWritten:Int, ?buffer:Bytes)->Void):Void;
  function writeString(str:String, ?position:Int, ?encoding:Encoding, callback:(?error:Error, ?bytesWritten:Int, ?buffer:Bytes)->Void):Void;
  function writeFile(data:Bytes, ?flags:FileOpenFlags, ?mode:FileMode, callback:(?error:Error)->Void):Void;
}
