package nusys;

import haxe.Error;
import haxe.io.Bytes;

import haxe.io.FilePath;
import sys.FileAccessMode;
import sys.FileOpenFlags;
import sys.FileMode;
import sys.SymlinkType;
//import sys.io.FileReadStream;
//import sys.io.FileWriteStream;

@:access(haxe.io.FilePath)
@:access(sys.FileAccessMode)
@:access(sys.FileOpenFlags)
@:access(sys.FileMode)
@:access(sys.SymlinkType)
@:access(nusys.io.File)
class FileSystem {
  // sys.FileSystem-like functions
  public static function access(path:FilePath, ?mode:FileAccessMode):Void UV.fs_access_sync(UV.loop, path.decodeHl(), (mode == null ? FileAccessMode.Ok : mode).get_raw());
  //public static function chmod(path:FilePath, mode:FileMode, ?followSymLinks:Bool = true):Void;
  //public static function chown(path:FilePath, uid:Int, gid:Int, ?followSymLinks:Bool = true):Void;
  //static function copyFile(src:FilePath, dest:FilePath, ?flags:FileCopyFlags):Void;
  //static function createReadStream(path:FilePath, ?options:{?flags:FileOpenFlags, ?mode:FileMode, ?autoClose:Bool, ?start:Int, ?end:Int, ?highWaterMark:Int}):FileReadStream;
  //static function createWriteStream(path:FilePath, ?options:{?flags:FileOpenFlags, ?mode:FileMode, ?autoClose:Bool, ?start:Int}):FileWriteStream;
  public static function link(existingPath:FilePath, newPath:FilePath):Void UV.fs_link_sync(UV.loop, existingPath.decodeHl(), newPath.decodeHl());
  //static function mkdir(path:FilePath, ?recursive:Bool, ?mode:FileMode):Void;
  public static function mkdtemp(prefix:FilePath):FilePath return FilePath.encodeHl(UV.fs_mkdtemp_sync(UV.loop, prefix.decodeHl()));
  //static function readdir(path:FilePath):Array<FilePath>;
  //static function readdirTypes(path:FilePath):Array<DirectoryEntry>;
  public static function readlink(path:FilePath):FilePath return FilePath.encodeHl(UV.fs_readlink_sync(UV.loop, path.decodeHl()));
  public static function realpath(path:FilePath):FilePath return FilePath.encodeHl(UV.fs_realpath_sync(UV.loop, path.decodeHl()));
  public static function rename(oldPath:FilePath, newPath:FilePath):Void UV.fs_rename_sync(UV.loop, oldPath.decodeHl(), newPath.decodeHl());
  public static function rmdir(path:FilePath):Void UV.fs_rmdir_sync(UV.loop, path.decodeHl());
  public static function stat(path:FilePath, ?followSymLinks:Bool = true):UV.UVStat/*FileStat*/ {
    if (followSymLinks)
      return UV.fs_stat_sync(UV.loop, path.decodeHl());
    return UV.fs_lstat_sync(UV.loop, path.decodeHl());
  }
  public static function symlink(target:FilePath, path:FilePath, ?type:SymlinkType):Void UV.fs_symlink_sync(UV.loop, target.decodeHl(), path.decodeHl(), (type == null ? SymlinkType.SymlinkDir : type).get_raw());
  //public static function truncate(path:FilePath, ?len:Int = 0):Void UV.fs_truncate_sync(UV.loop, path.decodeHl(), len);
  public static function unlink(path:FilePath):Void UV.fs_unlink_sync(UV.loop, path.decodeHl());
  public static function utimes(path:FilePath, atime:Date, mtime:Date):Void UV.fs_utime_sync(UV.loop, path.decodeHl(), atime.getTime() / 1000, mtime.getTime() / 1000);
  //static function watch(filename:FilePath, ?persistent:Bool, ?recursive:Bool):FileWatcher;
  
  // sys.io.File-like functions
  public static function appendFile(path:FilePath, data:Bytes, ?flags:FileOpenFlags, ?mode:FileMode):Void {
    if (flags == null)
      flags = FileOpenFlags.Append;
    if (mode == null)
      mode = 438; // 0666
    writeFile(path, data, flags, mode);
  }
  
  public static function open(path:FilePath, ?flags:FileOpenFlags, ?mode:FileMode, ?binary:Bool = true):nusys.io.File {
    var handle = UV.fs_open_sync(UV.loop, path.decodeHl(), flags == FileOpenFlags.WriteTruncate ? (UV.O_WRONLY | UV.O_CREAT | UV.O_TRUNC) : UV.O_RDWR, mode.get_raw());
    return new nusys.io.File(handle);
  }
  
  public static function readFile(path:FilePath, ?flags:FileOpenFlags):Bytes {
    if (flags == null)
      flags = FileOpenFlags.Read;
    var file = open(path, flags);
    var buffer:haxe.io.Bytes;
    try {
      var size = file.stat().size;
      buffer = haxe.io.Bytes.alloc(size);
      file.read(buffer, 0, size, 0);
    } catch (e:Dynamic) {
      file.close();
      throw e;
    }
    file.close();
    return buffer;
  }
  
  public static function writeFile(path:FilePath, data:Bytes, ?flags:FileOpenFlags, ?mode:FileMode):Void {
    if (flags == null)
      flags = FileOpenFlags.WriteTruncate;
    if (mode == null)
      mode = 438; // 0666
    var file = open(path, flags, mode);
    var offset = 0;
    var length = data.length;
    var position:Null<Int> = null;
    if (flags != Append && flags != AppendCreate)
      position = 0;
    try {
      while (length > 0) {
        var written = file.write(data, offset, length, position).bytesWritten;
        offset += written;
        length -= written;
        if (position != null) {
          position += written;
        }
      }
    } catch (e:Dynamic) {
      file.close();
      throw e;
    }
  }
  
  // compatibility sys.FileSystem functions
  ////static inline function absolutePath(path:String):String; // should be in haxe.io.Path?
  //static inline function createDirectory(path:String):Void return mkdir(path, true);
  //static inline function deleteDirectory(path:String):Void return rmdir(path);
  //static inline function deleteFile(path:String):Void return unlink(path);
  public static inline function exists(path:String):Bool return try { access(path); true; } catch (e:Dynamic) false;
  //static inline function fullPath(path:String):FilePath return realpath(path);
  //static inline function isDirectory(path:String):Bool return stat(path).isDirectory();
  //static inline function readDirectory(path:String):Array<FilePath> return readdir(path);
  ////static function rename(path:String, newPath:String) return rename(path, newPath); // matching interface
  ////static function stat(path:String) return stat(path); // matching interface (more or less)
}
