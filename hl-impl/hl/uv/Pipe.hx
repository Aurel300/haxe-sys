package hl.uv;

import haxe.NoData;
import haxe.async.*;
import asys.net.SocketAddress;
import haxe.io.Bytes;

private typedef Native = hl.Abstract<"uv_pipe_t">;

@:access(haxe.async.Callback)
@:access(String)
abstract Pipe(Native) from Native {
	@:hlNative("uv", "w_pipe_init") static function w_pipe_init(_:Loop, _:Bool):Native return null;
	@:hlNative("uv", "w_pipe_open") static function w_pipe_open(_:Native, _:Int):Void {}
	@:hlNative("uv", "w_pipe_accept") static function w_pipe_accept(_:Loop, _:Native):Native return null;
	@:hlNative("uv", "w_pipe_bind_ipc") static function w_pipe_bind_ipc(_:Native, _:hl.Bytes):Void {}
	@:hlNative("uv", "w_pipe_connect_ipc") static function w_pipe_connect_ipc(_:Native, _:hl.Bytes, _:Dynamic->Void):Void {}
	@:hlNative("uv", "w_pipe_pending_count") static function w_pipe_pending_count(_:Native):Int return 0;
	@:hlNative("uv", "w_pipe_accept_pending") static function w_pipe_accept_pending(_:Loop, _:Native):Dynamic return null;
	@:hlNative("uv", "w_pipe_getsockname") static function w_pipe_getsockname(_:Native):hl.Bytes return null;
	@:hlNative("uv", "w_pipe_getpeername") static function w_pipe_getpeername(_:Native):hl.Bytes return null;
	@:hlNative("uv", "w_pipe_write_handle") static function w_pipe_write_handle(_:Native, _:hl.Bytes, _:Int, _:Stream, _:Dynamic->Void):Void {}
	@:hlNative("uv", "w_pipe_stream") static function w_pipe_stream(_:Native):Stream return null;

	public inline function new(ipc:Bool) {
		this = w_pipe_init(Uv.loop, ipc);
	}

	public inline function open(fd:Int):Void {
		w_pipe_open(this, fd);
	}

	public inline function connectIpc(path:String, cb:Callback<NoData>):Void {
		w_pipe_connect_ipc(this, path.toUtf8(), cb.toUVNoData());
	}

	public inline function bindIpc(path:String):Void {
		w_pipe_bind_ipc(this, path.toUtf8());
	}

	public inline function accept():Pipe {
		return w_pipe_accept(Uv.loop, this);
	}

	public inline function writeHandle(data:Bytes, handle:Stream, cb:Callback<NoData>):Void {
		w_pipe_write_handle(this, hl.Bytes.fromBytes(data), data.length, handle, cb.toUVNoData());
	}

	public inline function pendingCount():Int {
		return w_pipe_pending_count(this);
	}

	public inline function acceptPending():PipeAccept {
		return w_pipe_accept_pending(Uv.loop, this);
	}

	public inline function getSockName():SocketAddress {
		return Unix(String.fromUTF8(w_pipe_getsockname(this)));
	}

	public inline function getPeerName():SocketAddress {
		return Unix(String.fromUTF8(w_pipe_getpeername(this)));
	}

	public inline function asStream():Stream {
		return w_pipe_stream(this);
	}
}

enum PipeAccept {
	Socket(_:Socket);
	Pipe(_:Pipe);
}
