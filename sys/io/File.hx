package sys.io;

import haxe.Error;
import haxe.io.Bytes;
import haxe.io.Encoding;
import sys.FileStat;

extern class File {
  // sys.io.File compatibility
  static inline function append(path:String, ?binary:Bool = true):FileOutput return sys.FileSystem.open(path, AppendCreate, binary).output;
  static inline function copy(srcPath:String, dstPath:String):Void sys.FileSystem.copyFile(srcPath, dstPath);
  static inline function getBytes(path:String):Bytes return sys.FileSystem.readFile(path);
  static inline function getContent(path:String):String return sys.FileSystem.readFile(path).toString();
  static inline function read(path:String, ?binary:Bool = true):FileInput return sys.FileSystem.open(path, Read, binary).input;
  static inline function saveBytes(path:String, bytes:Bytes):Void return sys.FileSystem.writeFile(path, bytes);
  static inline function saveContent(path:String, content:String):Void return sys.FileSystem.writeFile(path, Bytes.ofString(content));
  static inline function update(path:String, ?binary:Bool = true):FileOutput return sys.FileSystem.open(path, ReadWrite, binary).output;
  static inline function write(path:String, ?binary:Bool = true):FileOutput return sys.FileSystem.open(path, WriteTruncate, binary).output;
  
  final output:Null<FileOutput>;
  final input:Null<FileInput>;
  final async:AsyncFile;
  
  // node compatibility (file descriptors)
  function appendFile(data:Bytes, ?flags:FileOpenFlags, ?mode:FilePermissions):Void;
  function chmod(mode:FilePermissions):Void;
  function chown(uid:Int, gid:Int):Void;
  function close():Void;
  function datasync():Void;
  function read(buffer:Bytes, offset:Int, length:Int, position:Int):{bytesRead:Int, buffer:Bytes};
  function readFile(?flags:FileOpenFlags):Bytes;
  function stat():FileStat;
  function sync():Void;
  function truncate(?len:Int = 0):Void;
  function utimes(atime:Date, mtime:Date):Void;
  function write(buffer:Bytes, offset:Int, length:Int, position:Int):{bytesWritten:Int, buffer:Bytes};
  function writeString(str:String, ?position:Int, ?encoding:Encoding):{bytesWritten:Int, buffer:Bytes};
  function writeFile(data:Bytes, ?flags:FileOpenFlags, ?mode:FilePermissions):Void;
}
