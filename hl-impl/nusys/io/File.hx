package nusys.io;

import haxe.Error;
import haxe.io.Bytes;
import haxe.io.Encoding;
import sys.FileStat;

import haxe.io.FilePath;
import sys.FileOpenFlags;
import sys.FilePermissions;

typedef FileHandle = hl.Abstract<"uv_file">;

typedef FileOutput = String;
typedef FileInput = String;

@:access(haxe.io.FilePath)
@:access(sys.FileOpenFlags)
@:access(sys.FilePermissions)
class File {
  // sys.io.File compatibility
  //static inline function append(path:String, ?binary:Bool = true):FileOutput return sys.FileSystem.open(path, AppendCreate, binary).output;
  //static inline function copy(srcPath:String, dstPath:String):Void sys.FileSystem.copyFile(srcPath, dstPath);
  public static inline function getBytes(path:String):Bytes return nusys.FileSystem.readFile(path);
  public static inline function getContent(path:String):String return nusys.FileSystem.readFile(path).toString();
  //static inline function read(path:String, ?binary:Bool = true):FileInput return sys.FileSystem.open(path, Read, binary).input;
  public static inline function saveBytes(path:String, bytes:Bytes):Void return nusys.FileSystem.writeFile(path, bytes);
  public static inline function saveContent(path:String, content:String):Void return nusys.FileSystem.writeFile(path, Bytes.ofString(content));
  //static inline function update(path:String, ?binary:Bool = true):FileOutput return sys.FileSystem.open(path, ReadWrite, binary).output;
  //static inline function write(path:String, ?binary:Bool = true):FileOutput return sys.FileSystem.open(path, WriteTruncate, binary).output;
  
  final output:Null<FileOutput>;
  final input:Null<FileInput>;
  public final async:AsyncFile;
  
  var handle:FileHandle;
  
  private function new(handle:FileHandle) {
    output = null;
    input = null;
    async = @:privateAccess new AsyncFile(handle);
    this.handle = handle;
  }
  
  // node compatibility (file descriptors)
  //function appendFile(data:Bytes, ?flags:FileOpenFlags, ?mode:FilePermissions):Void;
  public function chmod(mode:FilePermissions):Void UV.fs_fchmod_sync(UV.loop, handle, @:privateAccess mode.get_raw());
  public function chown(uid:Int, gid:Int):Void UV.fs_fchown_sync(UV.loop, handle, uid, gid);
  public function close():Void UV.fs_close_sync(UV.loop, handle);
  public function datasync():Void UV.fs_fdatasync_sync(UV.loop, handle);
  public function read(buffer:Bytes, offset:Int, length:Int, position:Int):{bytesRead:Int, buffer:Bytes} {
    if (length <= 0 || offset < 0 || length + offset > buffer.length)
      throw "invalid call";
    var buf:UV.UVBuf = UV.buf_init(hl.Bytes.fromBytes(buffer).offset(offset), length);
    return {bytesRead: UV.fs_read_sync(UV.loop, handle, buf, position), buffer: buffer};
  }
  //function readFile(?flags:FileOpenFlags):Bytes;
  public function stat():sys.uv.UVStat return UV.fs_fstat_sync(UV.loop, handle);
  public function sync():Void UV.fs_fsync_sync(UV.loop, handle);
  public function truncate(?len:Int = 0):Void UV.fs_ftruncate_sync(UV.loop, handle, len);
  public function utimes(atime:Date, mtime:Date):Void UV.fs_futime_sync(UV.loop, handle, atime.getTime() / 1000, mtime.getTime() / 1000);
  public function write(buffer:Bytes, offset:Int, length:Int, position:Int):{bytesWritten:Int, buffer:Bytes} {
    if (length <= 0 || offset < 0 || length + offset > buffer.length)
      throw "invalid call";
    var buf:UV.UVBuf = UV.buf_init(hl.Bytes.fromBytes(buffer).offset(offset), length);
    return {bytesWritten: UV.fs_write_sync(UV.loop, handle, buf, position), buffer: buffer};
  }
  //public function writeString(str:String, ?position:Int, ?encoding:Encoding):{bytesWritten:Int, buffer:Bytes};
  //function writeFile(data:Bytes, ?flags:FileOpenFlags, ?mode:FilePermissions):Void;
}
