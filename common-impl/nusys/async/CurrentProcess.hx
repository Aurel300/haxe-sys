package nusys.async;

import haxe.async.*;
import nusys.async.net.Socket;
import nusys.io.*;

class CurrentProcess {
	public static final messageSignal:Signal<Dynamic> = new ArraySignal();

	static var ipc:Socket;
	static var ipcOut:IpcSerializer;
	static var ipcIn:IpcUnserializer;

	public static function initIpc(fd:Int):Void {
		ipc = Socket.create();
		ipcOut = @:privateAccess new IpcSerializer(ipc);
		ipcIn = @:privateAccess new IpcUnserializer(ipc);
		ipc.connectFd(true, fd);
		ipc.errorSignal.on(err -> trace("ipc error", err));
		ipcIn.messageSignal.on(message -> messageSignal.emit(message));
	}
}
