package haxe.io;

import haxe.Error;
import haxe.NoData;
import haxe.async.Signal;

interface IReadable {
	final dataSignal:Signal<Bytes>;
	final endSignal:Signal<NoData>;
	final errorSignal:Signal<Error>;
	final pauseSignal:Signal<NoData>;
	final resumeSignal:Signal<NoData>;
	function resume():Void;
	function pause():Void;
	function pipe(to:IWritable):Void;
}
