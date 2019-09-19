package neko.uv;

import haxe.NoData;
import haxe.async.Callback;
import haxe.io.Bytes;
import asys.net.*;

@:access(haxe.async.Callback)
abstract Stream(Dynamic) {
	static var w_shutdown:(Dynamic, (Dynamic)->Void)->Void = neko.Lib.load("uv", "w_shutdown", 2);
	static var w_listen:(Dynamic, Int, (Dynamic)->Void)->Void = neko.Lib.load("uv", "w_listen", 3);
	static var w_write:(Dynamic, neko.NativeString, Int, (Dynamic)->Void)->Void = neko.Lib.load("uv", "w_write", 4);
	static var w_read_start:(Dynamic, (Dynamic, neko.NativeString, Int)->Void)->Void = neko.Lib.load("uv", "w_read_start", 2);
	static var w_read_stop:(Dynamic)->Void = neko.Lib.load("uv", "w_read_stop", 1);
	static var w_stream_handle:(Dynamic)->Handle = neko.Lib.load("uv", "w_stream_handle", 1);

	public inline function end(cb:Callback<NoData>):Void {
		w_shutdown(this, cb.toUVNoData());
	}

	public inline function listen(backlog:Int, cb:Callback<NoData>):Void {
		w_listen(this, backlog, cb.toUVNoData());
	}

	public inline function write(data:Bytes, cb:Callback<NoData>):Void {
		w_write(this, data.getData(), data.length, cb.toUVNoData());
	}

	public inline function startRead(cb:Callback<Bytes>):Void {
		w_read_start(this, (error, ptr, length) -> {
			// TODO: length is unneeded in Neko
			if (error != null)
				cb(error, null);
			else
				cb(null, Bytes.ofData(ptr));
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
