package hl.uv;

import haxe.NoData;
import haxe.async.Callback;
import haxe.io.Bytes;
import asys.net.*;

private typedef Native = hl.Abstract<"uv_stream_t">;

@:access(haxe.async.Callback)
abstract Stream(Native) {
	@:hlNative("uv", "w_shutdown") static function w_shutdown(_:Native, _:Dynamic->Void):Void {}
	@:hlNative("uv", "w_listen") static function w_listen(_:Native, _:Int, _:Dynamic->Void):Void {}
	@:hlNative("uv", "w_write") static function w_write(_:Native, _:hl.Bytes, _:Int, _:Dynamic->Void):Void {}
	@:hlNative("uv", "w_read_start") static function w_read_start(_:Native, _:Dynamic->hl.Bytes->Int->Void):Void {}
	@:hlNative("uv", "w_read_stop") static function w_read_stop(_:Native):Void {}
	@:hlNative("uv", "w_stream_handle") static function w_stream_handle(_:Native):Handle return null;

	public inline function end(cb:Callback<NoData>):Void {
		w_shutdown(this, cb.toUVNoData());
	}

	public inline function listen(backlog:Int, cb:Callback<NoData>):Void {
		w_listen(this, backlog, cb.toUVNoData());
	}

	public inline function write(data:Bytes, cb:Callback<NoData>):Void {
		w_write(this, hl.Bytes.fromBytes(data), data.length, cb.toUVNoData());
	}

	public inline function startRead(cb:Callback<Bytes>):Void {
		w_read_start(this, (error, ptr, length) -> {
			if (error != null)
				cb(error, null);
			else
				cb(null, ptr.toBytes(length));
		});
	}

	public inline function stopRead():Void {
		w_read_stop(this);
	}

	public function close(cb:Callback<NoData>):Void {
		asHandle().close(cb);
	}

	public function ref():Void {
		asHandle().ref();
	}

	public function unref():Void {
		asHandle().unref();
	}

	public inline function asHandle():Handle {
		return w_stream_handle(this);
	}
}
