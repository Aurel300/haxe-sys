package nusys.async;

import haxe.Error;
import haxe.NoData;
import haxe.async.Callback;
import haxe.io.Bytes;
import haxe.io.FilePath;
import sys.*;

@:access(haxe.async.Callback)
@:access(haxe.io.FilePath)
@:access(sys.FileAccessMode)
@:access(sys.FileOpenFlags)
@:access(sys.FileMode)
@:access(sys.SymlinkType)
@:access(nusys.io.File)
class FileSystem {
  // sys.FileSystem-like functions
  public static function access(path:FilePath, ?mode:FileAccessMode, callback:Callback<NoData>):Void UV.fs_access(UV.loop, path.decodeHl(), (mode == null ? FileAccessMode.Ok : mode).get_raw(), callback.toUVNoData());
  //static function chmod(path:FilePath, mode:FileMode, ?followSymLinks:Bool = true, callback:Callback<NoData>):Void;
  //static function chown(path:FilePath, uid:Int, gid:Int, ?followSymLinks:Bool = true, callback:Callback<NoData>):Void;
  //static function copyFile(src:FilePath, dest:FilePath, ?flags:FileCopyFlags, callback:Callback<NoData>):Void;
  public static function exists(path:FilePath, callback:Callback<Bool>):Void access(path, (error) -> callback(error == null));
  public static function link(existingPath:FilePath, newPath:FilePath, callback:Callback<NoData>):Void UV.fs_link(UV.loop, existingPath.decodeHl(), newPath.decodeHl(), callback.toUVNoData());
  //static function mkdir(path:FilePath, ?recursive:Bool, ?mode:FileMode, callback:Callback<NoData>):Void;
  public static function mkdtemp(prefix:FilePath, callback:Callback<FilePath>):Void UV.fs_mkdtemp(UV.loop, prefix.decodeHl(), (error, path) -> callback(error, error != null ? FilePath.encodeHl(path) : null));
  //static function readdir(path:FilePath, callback:Callback<Array<FilePath>>):Void;
  //static function readdirTypes(path:FilePath, callback:Callback<Array<DirectoryEntry>>):Void;
  public static function readlink(path:FilePath, callback:Callback<FilePath>):Void UV.fs_readlink(UV.loop, path.decodeHl(), (error, path) -> callback(error, error != null ? FilePath.encodeHl(path) : null));
  public static function realpath(path:FilePath, callback:Callback<FilePath>):Void UV.fs_realpath(UV.loop, path.decodeHl(), (error, path) -> callback(error, error != null ? FilePath.encodeHl(path) : null));
  public static function rename(oldPath:FilePath, newPath:FilePath, callback:Callback<NoData>):Void UV.fs_rename(UV.loop, oldPath.decodeHl(), newPath.decodeHl(), callback.toUVNoData());
  public static function rmdir(path:FilePath, callback:Callback<NoData>):Void UV.fs_rmdir(UV.loop, path.decodeHl(), callback.toUVNoData());
  public static function stat(path:FilePath, ?followSymLinks:Bool = true, callback:Callback<UV.UVStat/*FileStat*/>):Void {
    if (followSymLinks)
      UV.fs_stat(UV.loop, path.decodeHl(), (error, stat) -> callback(error, stat));
    else
      UV.fs_lstat(UV.loop, path.decodeHl(), (error, stat) -> callback(error, stat));
  }
  public static function symlink(target:FilePath, path:FilePath, ?type:SymlinkType, callback:Callback<NoData>):Void UV.fs_symlink(UV.loop, target.decodeHl(), path.decodeHl(), (type == null ? SymlinkType.SymlinkDir : type).get_raw(), callback.toUVNoData());
  //static function truncate(path:FilePath, len:Int, callback:Callback<NoData>):Void;
  public static function unlink(path:FilePath, callback:Callback<NoData>):Void UV.fs_unlink(UV.loop, path.decodeHl(), callback.toUVNoData());
  public static function utimes(path:FilePath, atime:Date, mtime:Date, callback:Callback<NoData>):Void UV.fs_utime(UV.loop, path.decodeHl(), atime.getTime() / 1000, mtime.getTime() / 1000, callback.toUVNoData());
  
  //// sys.io.File-like functions
  //static function appendFile(path:FilePath, data:Bytes, ?flags:FileOpenFlags, ?mode:FileMode, callback:Callback<NoData>):Void;
  //static function open(path:FilePath, ?flags:FileOpenFlags, ?mode:FileMode, ?binary:Bool = true, callback:Callback<sys.io.File>):Void;
  //static function readFile(path:FilePath, ?flags:FileOpenFlags, callback:Callback<Bytes>):Void;
  //static function writeFile(path:FilePath, data:Bytes, ?flags:FileOpenFlags, ?mode:FileMode, callback:Callback<NoData>):Void;
}