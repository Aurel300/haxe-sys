package hl.uv;

import haxe.NoData;
import haxe.async.*;
import haxe.io.FilePath;

private typedef Native = hl.Abstract<"uv_fs_event_t">;

@:access(haxe.io.FilePath)
abstract FileWatcher(Native) {
	@:hlNative("uv", "w_fs_event_start") static function w_fs_event_start(loop:Loop, _:hl.Bytes, recursive:Bool, cb:(Dynamic, hl.Bytes, asys.uv.UVFsEventType)->Void):Native return null;
	@:hlNative("uv", "w_fs_event_stop") static function w_fs_event_stop(handle:Native, cb:Dynamic->Void):Void {}
	@:hlNative("uv", "w_fs_event_handle") static function w_fs_event_handle(_:Native):Handle return null;

	public inline function new(path:FilePath, recursive:Bool, cb:Callback<asys.FileWatcherEvent>) {
		this = w_fs_event_start(Uv.loop, path.decodeHl(), recursive, (error, path, event) -> {
			if (error != null)
				cb(error, null);
			else
				cb(null, switch (event) {
					case asys.uv.UVFsEventType.Rename:
						asys.FileWatcherEvent.Rename(FilePath.encodeHl(path));
					case asys.uv.UVFsEventType.Change:
						asys.FileWatcherEvent.Change(FilePath.encodeHl(path));
					case _:
						asys.FileWatcherEvent.RenameChange(FilePath.encodeHl(path));
				});
		});
	}

	public inline function close(cb:Callback<haxe.NoData>):Void {
		w_fs_event_stop(this, error -> cb(error, new NoData()));
	}

	public inline function ref():Void {
		asHandle().ref();
	}

	public inline function unref():Void {
		asHandle().unref();
	}

	public inline function asHandle():Handle {
		return w_fs_event_handle(this);
	}
}
