package nusys.io;

import haxe.Error;
import haxe.NoData;
import haxe.async.Callback;
import haxe.io.Bytes;
import haxe.io.Encoding;

import nusys.io.File.FileHandle;

class AsyncFile {
  var handle:FileHandle;
  
  private function new(handle:FileHandle) {
    this.handle = handle;
  }
  
  // node compatibility (file descriptors)
  //public function appendFile(data:Bytes, ?flags:FileOpenFlags, ?mode:FileMode, callback:Callback<NoData>):Void;
  //public function chmod(mode:FileMode, callback:Callback<NoData>):Void;
  //public function chown(uid:Int, gid:Int, callback:Callback<NoData>):Void;
  public function close(callback:Callback<NoData>):Void UV.fs_close(UV.loop, handle, (error) -> callback(error, null));
  //public function datasync(callback:Callback<NoData>):Void;
  //public function read(buffer:Bytes, offset:Int, length:Int, position:Int, callback:Callback<{bytesRead:Int, buffer:Bytes}>):Void;
  //public function readFile(?flags:FileOpenFlags, callback:Callback<Bytes>):Void;
  //public function stat(callback:Callback<FileStat>):Void;
  //public function sync(callback:Callback<NoData>):Void;
  //public function truncate(?len:Int = 0, callback:Callback<NoData>):Void;
  //public function utimes(atime:Date, mtime:Date, callback:Callback<NoData>):Void;
  //public function write(buffer:Bytes, offset:Int, length:Int, position:Int, callback:Callback<{bytesWritten:Int, buffer:Bytes}>):Void;
  //public function writeString(str:String, ?position:Int, ?encoding:Encoding, callback:Callback<{bytesWritten:Int, buffer:Bytes}>):Void;
  //public function writeFile(data:Bytes, ?flags:FileOpenFlags, ?mode:FileMode, callback:Callback<NoData>):Void;
}
