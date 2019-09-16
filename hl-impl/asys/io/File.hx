package asys.io;

import haxe.io.*;
import hl.Uv;
import hl.uv.Loop;

import hl.uv.File as Native;

@:access(haxe.io.FilePath)
@:access(asys.FileOpenFlags)
@:access(asys.FilePermissions)
abstract File(Native) {
	@:hlNative("uv", "w_fs_close_sync") static function w_fs_close_sync(loop:Loop, file:Native):Void {}
	@:hlNative("uv", "w_fs_read_sync") static function w_fs_read_sync(loop:Loop, file:Native, _:hl.Bytes, _:Int, _:Int, _:Int):Int return 0;
	@:hlNative("uv", "w_fs_write_sync") static function w_fs_write_sync(loop:Loop, file:Native, _:hl.Bytes, _:Int, _:Int, _:Int):Int return 0;
	@:hlNative("uv", "w_fs_fstat_sync") static function w_fs_fstat_sync(loop:Loop, file:Native):asys.uv.UVStat return null;
	@:hlNative("uv", "w_fs_fsync_sync") static function w_fs_fsync_sync(loop:Loop, file:Native):Void {}
	@:hlNative("uv", "w_fs_fdatasync_sync") static function w_fs_fdatasync_sync(loop:Loop, file:Native):Void {}
	@:hlNative("uv", "w_fs_ftruncate_sync") static function w_fs_ftruncate_sync(loop:Loop, file:Native, _:Int):Void {}
	@:hlNative("uv", "w_fs_sendfile_sync") static function w_fs_sendfile_sync(loop:Loop, file:Native, file:Native, _:Int, _:Int):Void {}
	@:hlNative("uv", "w_fs_fchmod_sync") static function w_fs_fchmod_sync(loop:Loop, file:Native, _:Int):Void {}
	@:hlNative("uv", "w_fs_futime_sync") static function w_fs_futime_sync(loop:Loop, file:Native, _:Float, _:Float):Void {}
	@:hlNative("uv", "w_fs_fchown_sync") static function w_fs_fchown_sync(loop:Loop, file:Native, _:Int, _:Int):Void {}

	private inline function get_async():AsyncFile {
		return this;
	}

	public var async(get, never):AsyncFile;

	public inline function chmod(mode:FilePermissions):Void {
		w_fs_fchmod_sync(Uv.loop, this, @:privateAccess mode.get_raw());
	}

	public inline function chown(uid:Int, gid:Int):Void {
		w_fs_fchown_sync(Uv.loop, this, uid, gid);
	}

	public inline function close():Void {
		w_fs_close_sync(Uv.loop, this);
	}

	public inline function datasync():Void {
		w_fs_fdatasync_sync(Uv.loop, this);
	}

	public function readBuffer(buffer:Bytes, offset:Int, length:Int, position:Int):{bytesRead:Int, buffer:Bytes} {
		if (length <= 0 || offset < 0 || length + offset > buffer.length)
			throw "invalid call";
		return {bytesRead: w_fs_read_sync(Uv.loop, this, hl.Bytes.fromBytes(buffer), offset, length, position), buffer: buffer};
	}

	public function readFile():Bytes {
		var buffer = Bytes.alloc(stat().size);
		readBuffer(buffer, 0, buffer.length, 0);
		return buffer;
	}
	
	public inline function stat():asys.uv.UVStat {
		return w_fs_fstat_sync(Uv.loop, this);
	}

	public inline function sync():Void {
		w_fs_fsync_sync(Uv.loop, this);
	}

	public inline function truncate(?len:Int = 0):Void {
		w_fs_ftruncate_sync(Uv.loop, this, len);
	}

	public inline function utimes(atime:Date, mtime:Date):Void {
		w_fs_futime_sync(Uv.loop, this, atime.getTime() / 1000, mtime.getTime() / 1000);
	}

	public function writeBuffer(buffer:Bytes, offset:Int, length:Int, position:Int):{bytesWritten:Int, buffer:Bytes} {
		if (length <= 0 || offset < 0 || length + offset > buffer.length)
			throw "invalid call";
		return {bytesWritten: w_fs_write_sync(Uv.loop, this, hl.Bytes.fromBytes(buffer), offset, length, position), buffer: buffer};
	}

	public function writeString(str:String, ?position:Int, ?encoding:Encoding):{bytesWritten:Int, buffer:Bytes} {
		var buffer = Bytes.ofString(str, encoding);
		return writeBuffer(buffer, 0, buffer.length, position);
	}
}
