package nusys.io;

import haxe.Error;
import haxe.NoData;
import haxe.async.*;
import haxe.io.*;
import nusys.async.net.Socket;

/**
	Class used internally to send messages and handles over an IPC channel. See
	`Process.spawn` for how to create an IPC channel and `Process.send` for
	sending messages over the channel.
**/
class IpcSerializer {
	static var activeSerializer:IpcSerializer = null;

	final pipe:Socket;
	final chunkSockets:Array<Socket> = [];

	function new(pipe:Socket) {
		this.pipe = pipe;
	}

	/**
		Sends `data` over the pipe. `data` will be serialized with a call to
		`haxe.Serializer.run`. However, objects of type `nusys.async.net.Socket`
		will also be correctly serialized and can be received by the other end.
	**/
	public function write(data:Dynamic):Void {
		activeSerializer = this;
		var serial = haxe.Serializer.run(data);
		for (socket in chunkSockets)
			pipe.writeHandle(Bytes.alloc(0), socket);
		pipe.write(Bytes.ofString('${serial.length}:$serial'));
		chunkSockets.resize(0);
		activeSerializer = null;
	}
}
