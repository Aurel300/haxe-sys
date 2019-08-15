package nusys.async;

enum ProcessIO {
	Pipe(readable:Bool, writable:Bool);
	// Ipc;
	Ignore;
	Inherit;
	// Stream(_);
	// Fd(_);
}
