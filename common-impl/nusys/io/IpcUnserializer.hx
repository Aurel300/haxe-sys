package nusys.io;

import haxe.Error;
import haxe.NoData;
import haxe.async.*;
import haxe.io.*;
import nusys.async.net.Socket;

class IpcUnserializer {
	static var activeUnserializer:IpcUnserializer = null;

	public final messageSignal:Signal<Dynamic> = new ArraySignal();
	public final errorSignal:Signal<Dynamic> = new ArraySignal();

	final pipe:Socket;
	var chunkSockets:Array<Socket> = [];
	var chunkLenbuf:String = "";
	var chunkBuf:StringBuf;
	var chunkSize:Null<Int> = 0;

	function new(pipe:Socket) {
		this.pipe = pipe;
		pipe.dataSignal.on(handleData);
	}

	function handleData(data:Bytes):Void {
		if (data.length == 0)
			return;
		try {
			var data = data.toString();
			while (data != null) {
				if (chunkSize == 0) {
					chunkLenbuf += data;
					var colonPos = chunkLenbuf.indexOf(":");
					if (colonPos != -1) {
						chunkSize = Std.parseInt(chunkLenbuf.substr(0, colonPos));
						if (chunkSize == null || chunkSize <= 0) {
							chunkSize = 0;
							throw "invalid chunk size received";
						}
						chunkBuf = new StringBuf();
						chunkBuf.add(chunkLenbuf.substr(colonPos + 1));
						chunkLenbuf = "";
						chunkSockets.resize(0);
					}
				} else {
					chunkBuf.add(data);
				}
				data = null;
				if (chunkSize != 0) {
					if (chunkBuf.length >= chunkSize) {
						var serial = chunkBuf.toString();
						if (serial.length > chunkSize) {
							data = serial.substr(chunkSize);
							serial = serial.substr(0, chunkSize);
						}
						chunkBuf = null;
						for (i in 0...pipe.handlesPending)
							chunkSockets.push(pipe.readHandle());
						activeUnserializer = this;
						messageSignal.emit(haxe.Unserializer.run(serial));
						chunkSize = 0;
						chunkSockets.resize(0);
						activeUnserializer = null;
					}
				}
			}
		} catch (e:Dynamic) {
			errorSignal.emit(e);
		}
	}
}
