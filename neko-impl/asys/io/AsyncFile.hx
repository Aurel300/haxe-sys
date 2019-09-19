package asys.io;

import haxe.Error;
import haxe.NoData;
import haxe.async.Callback;
import haxe.io.*;
import neko.Uv;
import neko.uv.Loop;

@:access(haxe.io.FilePath)
@:access(asys.FileOpenFlags)
@:access(asys.FilePermissions)
@:access(haxe.async.Callback)
abstract AsyncFile(Dynamic) from Dynamic {
	static var w_fs_close:(Loop, Dynamic, (Dynamic)->Void)->Void = neko.Lib.load("uv", "w_fs_close", 3);
	static var w_fs_read:(neko.NativeArray<Dynamic>)->Void = neko.Lib.load("uv", "w_fs_read_dyn", 1);
	static var w_fs_write:(neko.NativeArray<Dynamic>)->Void = neko.Lib.load("uv", "w_fs_write_dyn", 1);
	static var w_fs_fstat:(Loop, Dynamic, (Dynamic, asys.uv.UVStat)->Void)->Void = neko.Lib.load("uv", "w_fs_fstat", 3);
	static var w_fs_fsync:(Loop, Dynamic, (Dynamic)->Void)->Void = neko.Lib.load("uv", "w_fs_fsync", 3);
	static var w_fs_fdatasync:(Loop, Dynamic, (Dynamic)->Void)->Void = neko.Lib.load("uv", "w_fs_fdatasync", 3);
	static var w_fs_ftruncate:(Loop, Dynamic, Int, (Dynamic)->Void)->Void = neko.Lib.load("uv", "w_fs_ftruncate", 4);
	static var w_fs_sendfile:(neko.NativeArray<Dynamic>)->Void = neko.Lib.load("uv", "w_fs_sendfile_dyn", 1);
	static var w_fs_fchmod:(Loop, Dynamic, Int, (Dynamic)->Void)->Void = neko.Lib.load("uv", "w_fs_fchmod", 4);
	static var w_fs_futime:(Loop, Dynamic, Float, Float, (Dynamic)->Void)->Void = neko.Lib.load("uv", "w_fs_futime", 5);
	static var w_fs_fchown:(Loop, Dynamic, Int, Int, (Dynamic)->Void)->Void = neko.Lib.load("uv", "w_fs_fchown", 5);

	public function chmod(mode:FilePermissions, callback:Callback<NoData>):Void {
		w_fs_fchmod(Uv.loop, this, mode.get_raw(), callback.toUVNoData());
	}

	public function chown(uid:Int, gid:Int, callback:Callback<NoData>):Void {
		w_fs_fchown(Uv.loop, this, uid, gid, callback.toUVNoData());
	}

	public function close(callback:Callback<NoData>):Void {
		w_fs_close(Uv.loop, this, callback.toUVNoData());
	}

	public function datasync(callback:Callback<NoData>):Void {
		w_fs_fdatasync(Uv.loop, this, callback.toUVNoData());
	}

	// TODO: this might be segfaulting due to buffer being freed before request is done, same for writeBuffer
	public function readBuffer(buffer:Bytes, offset:Int, length:Int, position:Int, callback:Callback<{bytesRead:Int, buffer:Bytes}>):Void {
		if (length <= 0 || offset < 0 || length + offset > buffer.length)
			throw "invalid call";
		w_fs_read(neko.NativeArray.ofArrayRef(([Uv.loop, this, buffer.getData(), offset, length, position, (error, bytesRead) -> {
			if (error != null)
				callback(error, null);
			else
				callback(null, {bytesRead: bytesRead, buffer: buffer});
		}]:Array<Dynamic>)));
	}

	public function readFile(callback:Callback<Bytes>):Void {
		stat((err, stat) -> {
			if (err != null)
				return callback(err, null);
			var buffer = Bytes.alloc(stat.size);
			readBuffer(buffer, 0, buffer.length, 0, (err, res) -> {
				if (err != null)
					return callback(err, null);
				callback(null, buffer);
			});
		});
	}

	public function stat(callback:Callback<asys.uv.UVStat>):Void {
		w_fs_fstat(Uv.loop, this, (error, stat) -> callback(error, stat));
	}

	public function sync(callback:Callback<NoData>):Void {
		w_fs_fsync(Uv.loop, this, callback.toUVNoData());
	}

	public function truncate(?len:Int = 0, callback:Callback<NoData>):Void {
		w_fs_ftruncate(Uv.loop, this, len, callback.toUVNoData());
	}

	public function utimes(atime:Date, mtime:Date, callback:Callback<NoData>):Void {
		w_fs_futime(Uv.loop, this, atime.getTime() / 1000, mtime.getTime() / 1000, callback.toUVNoData());
	}

	public function writeBuffer(buffer:Bytes, offset:Int, length:Int, position:Int, callback:Callback<{bytesWritten:Int, buffer:Bytes}>):Void {
		if (length <= 0 || offset < 0 || length + offset > buffer.length)
			throw "invalid call";
		w_fs_write(neko.NativeArray.ofArrayRef(([Uv.loop, this, buffer.getData(), offset, length, position, (error, bytesWritten) -> {
			if (error != null)
				callback(error, null);
			else
				callback(null, {bytesWritten: bytesWritten, buffer: buffer});
		}]:Array<Dynamic>)));
	}

	public function writeString(str:String, ?position:Int, ?encoding:Encoding, callback:Callback<{bytesWritten:Int, buffer:Bytes}>):Void {
		var buffer = Bytes.ofString(str, encoding);
		writeBuffer(buffer, 0, buffer.length, position, callback);
	}
}
