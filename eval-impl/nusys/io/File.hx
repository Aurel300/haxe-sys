package nusys.io;

import haxe.io.Bytes;
import haxe.io.Encoding;
import sys.*;

class File {
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

	extern function get_async():AsyncFile;

	public var async(get, never):AsyncFile;

	extern public function chmod(mode:FilePermissions):Void;

	extern public function chown(uid:Int, gid:Int):Void;

	extern public function close():Void;

	extern public function datasync():Void;

	extern public function readBuffer(buffer:Bytes, offset:Int, length:Int, position:Int):{bytesRead:Int, buffer:Bytes};

	public function readFile():Bytes {
		var buffer = Bytes.alloc(stat().size);
		readBuffer(buffer, 0, buffer.length, 0);
		return buffer;
	}

	extern public function stat():eval.uv.Stat;

	extern public function sync():Void;

	extern public function truncate(?len:Int = 0):Void;

	extern public function utimes_native(atime:Float, mtime:Float):Void;

	public function utimes(atime:Date, mtime:Date):Void {
		utimes_native(atime.getTime() / 1000, mtime.getTime() / 1000);
	}

	extern public function writeBuffer(buffer:Bytes, offset:Int, length:Int, position:Int):{bytesWritten:Int, buffer:Bytes};

	public function writeString(str:String, ?position:Int, ?encoding:Encoding):{bytesWritten:Int, buffer:Bytes} {
		var buffer = Bytes.ofString(str, encoding);
		return writeBuffer(buffer, 0, buffer.length, position);
	}
}
