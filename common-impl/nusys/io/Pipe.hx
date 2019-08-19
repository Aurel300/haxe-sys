package nusys.io;

import haxe.NoData;
import haxe.async.*;
import haxe.io.*;

/**
	A `Pipe` is a communication channel between two processes. It may be
	uni-directional or bi-directional, depending on how it is created. Pipes can
	be automatically created for spawned subprocesses with `Process.spawn`.
**/
extern class Pipe extends Duplex {
	/**
		Create a bi-directional pipe.
	**/
	static function create():Pipe;

	/**
		Close the local end of the pipe.
	**/
	function close(?cb:Callback<NoData>):Void;
}
