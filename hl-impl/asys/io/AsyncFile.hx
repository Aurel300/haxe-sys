package asys.io;

import haxe.Error;
import haxe.NoData;
import haxe.async.Callback;
import haxe.io.*;
import hl.Uv;
import hl.uv.Loop;

import hl.uv.File as Native;

@:access(haxe.io.FilePath)
@:access(asys.FileOpenFlags)
@:access(asys.FilePermissions)
@:access(haxe.async.Callback)
abstract AsyncFile(Native) from Native {
	@:hlNative("uv", "w_fs_close") static function w_fs_close(loop:Loop, file:Native, cb:Dynamic->Void):Void {}
	@:hlNative("uv", "w_fs_read") static function w_fs_read(loop:Loop, file:Native, _:hl.Bytes, _:Int, _:Int, _:Int, cb:Dynamic->Int->Void):Void {}
	@:hlNative("uv", "w_fs_write") static function w_fs_write(loop:Loop, file:Native, _:hl.Bytes, _:Int, _:Int, _:Int, cb:Dynamic->Int->Void):Void {}
	@:hlNative("uv", "w_fs_fstat") static function w_fs_fstat(loop:Loop, file:Native, cb:Dynamic->asys.uv.UVStat->Void):Void {}
	@:hlNative("uv", "w_fs_fsync") static function w_fs_fsync(loop:Loop, file:Native, cb:Dynamic->Void):Void {}
	@:hlNative("uv", "w_fs_fdatasync") static function w_fs_fdatasync(loop:Loop, file:Native, cb:Dynamic->Void):Void {}
	@:hlNative("uv", "w_fs_ftruncate") static function w_fs_ftruncate(loop:Loop, file:Native, _:Int, cb:Dynamic->Void):Void {}
	@:hlNative("uv", "w_fs_sendfile") static function w_fs_sendfile(loop:Loop, file:Native, file:Native, _:Int, _:Int, cb:Dynamic->Void):Void {}
	@:hlNative("uv", "w_fs_fchmod") static function w_fs_fchmod(loop:Loop, file:Native, _:Int, cb:Dynamic->Void):Void {}
	@:hlNative("uv", "w_fs_futime") static function w_fs_futime(loop:Loop, file:Native, _:Float, _:Float, cb:Dynamic->Void):Void {}
	@:hlNative("uv", "w_fs_fchown") static function w_fs_fchown(loop:Loop, file:Native, _:Int, _:Int, cb:Dynamic->Void):Void {}

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
		w_fs_read(Uv.loop, this, hl.Bytes.fromBytes(buffer), offset, length, position, (error, bytesRead) -> {
			if (error != null)
				callback(error, null);
			else
				callback(null, {bytesRead: bytesRead, buffer: buffer});
		});
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
		w_fs_write(Uv.loop, this, hl.Bytes.fromBytes(buffer), offset, length, position, (error, bytesWritten) -> {
			if (error != null)
				callback(error, null);
			else
				callback(null, {bytesWritten: bytesWritten, buffer: buffer});
		});
	}

	public function writeString(str:String, ?position:Int, ?encoding:Encoding, callback:Callback<{bytesWritten:Int, buffer:Bytes}>):Void {
		var buffer = Bytes.ofString(str, encoding);
		writeBuffer(buffer, 0, buffer.length, position, callback);
	}
}
