package asys.io;

import haxe.io.*;
import neko.Uv;
import neko.uv.Loop;

@:access(haxe.io.FilePath)
@:access(asys.FileOpenFlags)
@:access(asys.FilePermissions)
abstract File(Dynamic) {
	static var w_fs_close_sync:(Loop, Dynamic)->Void = neko.Lib.load("uv", "w_fs_close_sync", 2);
	static var w_fs_read_sync:(neko.NativeArray<Dynamic>)->Int = neko.Lib.load("uv", "w_fs_read_sync_dyn", 1);
	static var w_fs_write_sync:(neko.NativeArray<Dynamic>)->Int = neko.Lib.load("uv", "w_fs_write_sync_dyn", 1);
	static var w_fs_fstat_sync:(Loop, Dynamic)->asys.uv.UVStat = neko.Lib.load("uv", "w_fs_fstat_sync", 2);
	static var w_fs_fsync_sync:(Loop, Dynamic)->Void = neko.Lib.load("uv", "w_fs_fsync_sync", 2);
	static var w_fs_fdatasync_sync:(Loop, Dynamic)->Void = neko.Lib.load("uv", "w_fs_fdatasync_sync", 2);
	static var w_fs_ftruncate_sync:(Loop, Dynamic, Int)->Void = neko.Lib.load("uv", "w_fs_ftruncate_sync", 3);
	static var w_fs_sendfile_sync:(Loop, Dynamic, Dynamic, Int, Int)->Void = neko.Lib.load("uv", "w_fs_sendfile_sync", 5);
	static var w_fs_fchmod_sync:(Loop, Dynamic, Int)->Void = neko.Lib.load("uv", "w_fs_fchmod_sync", 3);
	static var w_fs_futime_sync:(Loop, Dynamic, Float, Float)->Void = neko.Lib.load("uv", "w_fs_futime_sync", 4);
	static var w_fs_fchown_sync:(Loop, Dynamic, Int, Int)->Void = neko.Lib.load("uv", "w_fs_fchown_sync", 4);

	private inline function get_async():AsyncFile {
		return this;
	}

	public var async(get, never):AsyncFile;

	public inline function chmod(mode:FilePermissions):Void {
		w_fs_fchmod_sync(Uv.loop, this, mode.get_raw());
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
		return {bytesRead: w_fs_read_sync(neko.NativeArray.ofArrayRef(([
			Uv.loop, this, buffer.getData(), offset, length, position
		]:Array<Dynamic>))), buffer: buffer};
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
		return {bytesWritten: w_fs_write_sync(neko.NativeArray.ofArrayRef(([
			Uv.loop, this, buffer.getData(), offset, length, position
		]:Array<Dynamic>))), buffer: buffer};
	}

	public function writeString(str:String, ?position:Int, ?encoding:Encoding):{bytesWritten:Int, buffer:Bytes} {
		var buffer = Bytes.ofString(str, encoding);
		return writeBuffer(buffer, 0, buffer.length, position);
	}
}
