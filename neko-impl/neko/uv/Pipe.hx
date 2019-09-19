package neko.uv;

import haxe.NoData;
import haxe.async.*;
import asys.net.SocketAddress;
import haxe.io.Bytes;

@:access(haxe.async.Callback)
@:access(String)
abstract Pipe(Dynamic) from Dynamic {
	static var w_pipe_init:(Loop, Bool)->Dynamic = neko.Lib.load("uv", "w_pipe_init", 2);
	static var w_pipe_open:(Dynamic, Int)->Void = neko.Lib.load("uv", "w_pipe_open", 2);
	static var w_pipe_accept:(Loop, Dynamic)->Dynamic = neko.Lib.load("uv", "w_pipe_accept", 2);
	static var w_pipe_bind_ipc:(Dynamic, neko.NativeString)->Void = neko.Lib.load("uv", "w_pipe_bind_ipc", 2);
	static var w_pipe_connect_ipc:(Dynamic, neko.NativeString, Dynamic->Void)->Void = neko.Lib.load("uv", "w_pipe_connect_ipc", 3);
	static var w_pipe_pending_count:(Dynamic)->Int = neko.Lib.load("uv", "w_pipe_pending_count", 1);
	static var w_pipe_accept_pending:(Loop, Dynamic)->Dynamic = neko.Lib.load("uv", "w_pipe_accept_pending", 2);
	static var w_pipe_getsockname:(Dynamic)->neko.NativeString = neko.Lib.load("uv", "w_pipe_getsockname", 1);
	static var w_pipe_getpeername:(Dynamic)->neko.NativeString = neko.Lib.load("uv", "w_pipe_getpeername", 1);
	static var w_pipe_write_handle:(Dynamic, neko.NativeString, Stream, Dynamic->Void)->Void = neko.Lib.load("uv", "w_pipe_write_handle", 4);
	static var w_pipe_stream:(Dynamic)->Stream = neko.Lib.load("uv", "w_pipe_stream", 1);

	public inline function new(ipc:Bool) {
		this = w_pipe_init(Uv.loop, ipc);
	}

	public inline function open(fd:Int):Void {
		w_pipe_open(this, fd);
	}

	public inline function connectIpc(path:String, cb:Callback<NoData>):Void {
		w_pipe_connect_ipc(this, neko.NativeString.ofString(path), cb.toUVNoData());
	}

	public inline function bindIpc(path:String):Void {
		w_pipe_bind_ipc(this, neko.NativeString.ofString(path));
	}

	public inline function accept():Pipe {
		return w_pipe_accept(Uv.loop, this);
	}

	public inline function writeHandle(data:Bytes, handle:Stream, cb:Callback<NoData>):Void {
		w_pipe_write_handle(this, data.getData(), handle, cb.toUVNoData());
	}

	public inline function pendingCount():Int {
		return w_pipe_pending_count(this);
	}

	public inline function acceptPending():PipeAccept {
		return w_pipe_accept_pending(Uv.loop, this);
	}

	public inline function getSockName():SocketAddress {
		return Unix(neko.NativeString.toString(w_pipe_getsockname(this)));
	}

	public inline function getPeerName():SocketAddress {
		return Unix(neko.NativeString.toString(w_pipe_getpeername(this)));
	}

	public inline function asStream():Stream {
		return w_pipe_stream(this);
	}
}

enum PipeAccept {
	Socket(_:Socket);
	Pipe(_:Pipe);
}
