package nusys.io;

import haxe.Error;
import haxe.io.Bytes;
import haxe.io.Encoding;
import sys.FilePermissions;
import nusys.*;

/**
	Class representing an open file. Some methods in this class are instance
	variants of the same methods in `nusys.FileSystem`.
**/
extern class File {
	@:deprecated("use sys.FileSystem.appendFile instead")
	static inline function append(path:String, ?binary:Bool = true):FileOutput
		return @:privateAccess new FileOutput(nusys.FileSystem.open(path, "a", binary));

	@:deprecated("use sys.FileSystem.copy instead")
	static inline function copy(srcPath:String, dstPath:String):Void
		nusys.FileSystem.copyFile(srcPath, dstPath);

	@:deprecated("use sys.FileSystem.readFile instead")
	static inline function getBytes(path:String):Bytes return nusys.FileSystem.readFile(path);

	@:deprecated("use sys.FileSystem.readFile instead")
	static inline function getContent(path:String):String return nusys.FileSystem.readFile(path).toString();

	@:deprecated("use sys.FileSystem.open instead")
	static inline function read(path:String, ?binary:Bool = true):FileInput
		return @:privateAccess new FileInput(nusys.FileSystem.open(path, "r", binary));

	@:deprecated("use sys.FileSystem.writeFile instead")
	static inline function saveBytes(path:String, bytes:Bytes):Void return nusys.FileSystem.writeFile(path, bytes);

	@:deprecated("use sys.FileSystem.writeFile instead")
	static inline function saveContent(path:String, content:String):Void return nusys.FileSystem.writeFile(path, Bytes.ofString(content));

	@:deprecated("use sys.FileSystem.open instead")
	static inline function update(path:String, ?binary:Bool = true):FileOutput
		return @:privateAccess new FileOutput(nusys.FileSystem.open(path, ReadWrite, binary));

	@:deprecated("use sys.FileSystem.open instead")
	static inline function write(path:String, ?binary:Bool = true):FileOutput
		return @:privateAccess new FileOutput(nusys.FileSystem.open(path, "w", binary));

	var async(get, never):AsyncFile;

	/**
		See `nusys.FileSystem.chmod`.
	**/
	function chmod(mode:FilePermissions):Void;

	/**
		See `nusys.FileSystem.chown`.
	**/
	function chown(uid:Int, gid:Int):Void;

	/**
		Closes the file. Any operation after this method is called is invalid.
	**/
	function close():Void;

	/**
		Same as `sync`, but metadata is not flushed unless needed for subsequent
		data reads to be correct. E.g. changes to the modification times are not
		flushed, but changes to the filesize do.
	**/
	function datasync():Void;

	/**
		Reads a part of `this` file into the given `buffer`.

		@param buffer Buffer to which data will be written.
		@param offset Position in `buffer` at which to start writing.
		@param length Number of bytes to read from `this` file.
		@param position Position in `this` file at which to start reading.
	**/
	function readBuffer(buffer:Bytes, offset:Int, length:Int, position:Int):{bytesRead:Int, buffer:Bytes};

	/**
		Reads the entire contents of `this` file.
	**/
	function readFile():Bytes;

	/**
		See `nusys.FileSystem.stat`.
	**/
	function stat():FileStat;

	/**
		Flushes all modified data and metadata of `this` file to the disk.
	**/
	function sync():Void;

	/**
		See `nusys.FileSystem.truncate`.
	**/
	function truncate(?len:Int = 0):Void;

	/**
		See `nusys.FileSystem.utimes`.
	**/
	function utimes(atime:Date, mtime:Date):Void;

	/**
		Writes a part of the given `buffer` into `this` file.

		@param buffer Buffer from which data will be read.
		@param offset Position in `buffer` at which to start reading.
		@param length Number of bytes to write to `this` file.
		@param position Position in `this` file at which to start writing.
	**/
	function writeBuffer(buffer:Bytes, offset:Int, length:Int, position:Int):{bytesWritten:Int, buffer:Bytes};

	/**
		Writes a string to `this` file at `position`.
	**/
	function writeString(str:String, ?position:Int, ?encoding:Encoding):{bytesWritten:Int, buffer:Bytes};
}
