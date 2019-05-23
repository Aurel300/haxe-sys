package sys;

import haxe.Error;
import haxe.io.Bytes;
import haxe.io.FilePath;
import sys.io.FileReadStream;
import sys.io.FileWriteStream;

extern class FileSystem {
  // sys.FileSystem-like functions
  static function access(path:FilePath, ?mode:FileAccessMode):Void;
  static function chmod(path:FilePath, mode:FileMode, ?followSymLinks:Bool = true):Void;
  static function chown(path:FilePath, uid:Int, gid:Int, ?followSymLinks:Bool = true):Void;
  static function copyFile(src:FilePath, dest:FilePath, ?flags:FileCopyFlags):Void;
  //static function exists(path:FilePath):Bool; // deprecated in node.js
  static function createReadStream(path:FilePath, ?options:{?flags:FileOpenFlags, ?mode:FileMode, ?autoClose:Bool, ?start:Int, ?end:Int, ?highWaterMark:Int}):FileReadStream;
  static function createWriteStream(path:FilePath, ?options:{?flags:FileOpenFlags, ?mode:FileMode, ?autoClose:Bool, ?start:Int}):FileWriteStream;
  static function link(existingPath:FilePath, newPath:FilePath):Void;
  static function mkdir(path:FilePath, ?recursive:Bool, ?mode:FileMode):Void;
  static function mkdtemp(prefix:FilePath):FilePath;
  static function readdir(path:FilePath):Array<FilePath>;
  static function readdirTypes(path:FilePath):Array<DirectoryEntry>;
  static function readlink(path:FilePath):FilePath;
  static function realpath(path:FilePath):FilePath;
  static function rename(oldPath:FilePath, newPath:FilePath):Void;
  static function rmdir(path:FilePath):Void;
  static function stat(path:FilePath, ?followSymLinks:Bool = true):FileStat;
  static function symlink(target:FilePath, path:FilePath, ?type:String):Void;
  static function truncate(path:FilePath, len:Int):Void;
  static function unlink(path:FilePath):Void;
  static function utimes(path:FilePath, atime:Date, mtime:Date):Void;
  static function watch(filename:FilePath, ?persistent:Bool, ?recursive:Bool):FileWatcher;
  
  // sys.io.File-like functions
  static function appendFile(path:FilePath, data:Bytes, ?flags:FileOpenFlags, ?mode:FileMode):Void;
  static function open(path:FilePath, ?flags:FileOpenFlags, ?mode:FileMode, ?binary:Bool = true):sys.io.File;
  static function readFile(path:FilePath, ?flags:FileOpenFlags):Bytes;
  static function writeFile(path:FilePath, data:Bytes, ?flags:FileOpenFlags, ?mode:FileMode):Void;
  
  // compatibility sys.FileSystem functions
  //static inline function absolutePath(path:String):String; // should be in haxe.io.Path?
  static inline function createDirectory(path:String):Void return mkdir(path, true);
  static inline function deleteDirectory(path:String):Void return rmdir(path);
  static inline function deleteFile(path:String):Void return unlink(path);
  static inline function exists(path:String):Bool return try { access(path); true; } catch (e:Dynamic) false;
  static inline function fullPath(path:String):FilePath return realpath(path);
  static inline function isDirectory(path:String):Bool return stat(path).isDirectory();
  static inline function readDirectory(path:String):Array<FilePath> return readdir(path);
  //static function rename(path:String, newPath:String) return rename(path, newPath); // matching interface
  //static function stat(path:String) return stat(path); // matching interface (more or less)
}
