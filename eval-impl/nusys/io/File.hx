package nusys.io;

import haxe.io.Bytes;
import haxe.io.Encoding;
import sys.*;

class File {
	// function appendFile(data:Bytes, ?flags:FileOpenFlags, ?mode:FilePermissions):Void;
	extern public function chmod(mode:FilePermissions):Void;
	extern public function chown(uid:Int, gid:Int):Void;
	extern public function close():Void;
	extern public function datasync():Void;
	extern public function read(buffer:Bytes, offset:Int, length:Int, position:Int):{bytesRead:Int, buffer:Bytes};
	public function readFile():Bytes {
		var buffer = Bytes.alloc(stat().size);
		read(buffer, 0, buffer.length, 0);
		return buffer;
	}
	extern public function stat():eval.uv.Stat;
	extern public function sync():Void;
	extern public function truncate(?len:Int = 0):Void;
	extern public function utimes_native(atime:Float, mtime:Float):Void;
	public function utimes(atime:Date, mtime:Date):Void {
		utimes_native(atime.getTime() / 1000, mtime.getTime() / 1000);
	}
	extern public function write(buffer:Bytes, offset:Int, length:Int, position:Int):{bytesWritten:Int, buffer:Bytes};
	public function writeString(str:String, ?position:Int, ?encoding:Encoding):{bytesWritten:Int, buffer:Bytes} {
		var buffer = Bytes.ofString(str, encoding);
		return write(buffer, 0, buffer.length, position);
	}
	// function writeFile(data:Bytes, ?flags:FileOpenFlags, ?mode:FilePermissions):Void;
}
