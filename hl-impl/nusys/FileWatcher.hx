package nusys;

import haxe.Error;
import haxe.NoData;
import haxe.async.Signal;
import sys.FileWatcherEvent;

class FileWatcher {
	public final changeSignal = new Signal<FileWatcherEvent>();
	public final closeSignal = new Signal<NoData>();
	public final errorSignal = new Signal<Error>();

	private var handle:UV.UVFsEvent;

	private function new(handle:UV.UVFsEvent) {
		this.handle = handle;
	}

	public function close():Void {
		UV.fs_event_stop(handle);
		closeSignal.emit(null);
	}
}
