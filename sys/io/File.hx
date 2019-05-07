package sys.io;

import haxe.Error;
import haxe.io.Bytes;
import haxe.io.Encoding;
import sys.FileStat;

extern class File {
  // sys.io.File compatibility
  // for methods with binary - we should map this properly
  static inline function append(path:String, ?binary:Bool = true):FileOutput return sys.FileSystem.open(path, AppendCreate).output;
  static inline function copy(srcPath:String, dstPath:String):Void sys.FileSystem.copyFile(srcPath, dstPath);
  static inline function getBytes(path:String):Bytes return sys.FileSystem.readFile(path);
  static inline function getContent(path:String):String return sys.FileSystem.readFile(path).toString();
  static inline function read(path:String, ?binary:Bool = true):FileInput return sys.FileSystem.open(path, Read).input;
  static inline function saveBytes(path:String, bytes:Bytes):Void return sys.FileSystem.writeFile(path, bytes);
  static inline function saveContent(path:String, content:String):Void return sys.FileSystem.writeFile(path, Bytes.ofString(content));
  static inline function update(path:String, ?binary:Bool = true):FileOutput return sys.FileSystem.open(path, ReadWrite).output;
  static inline function write(path:String, ?binary:Bool = true):FileOutput return sys.FileSystem.open(path, WriteTruncate).output;
  
  public var output(default, null):Null<FileOutput>;
  public var input(default, null):Null<FileInput>;
  
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
  function writeString(str:String, ?position:Int, ?encoding:Encoding, callback:(?error:Error, ?bytesRead:Int, ?buffer:Bytes)->Void):Void;
  function writeFile(data:Bytes, ?flags:FileOpenFlags, ?mode:FileMode, callback:(?error:Error)->Void):Void;
}
