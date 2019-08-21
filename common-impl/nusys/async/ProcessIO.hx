package nusys.async;

enum ProcessIO {
	Ignore;
	Inherit;
	Pipe(readable:Bool, writable:Bool, ?pipe:nusys.async.net.Socket);
	Ipc;
	// Stream(_);
	// Fd(_);
}
