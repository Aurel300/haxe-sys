package haxe;

import haxe.PosInfos;

/**
	Common class for errors.
**/
class Error {
	/**
		A human-readable representation of the error.
	**/
	public final message:String;

	/**
		Position where the error was thrown. By default, this is the place where the error is constructed.
	**/
	public final posInfos:PosInfos;

	/**
		Error type, usable for discerning error types with `switch` statements.
	**/
	public final type:ErrorType;

	public function new(message:String, type:ErrorType, ?posInfos:PosInfos) {
		this.message = message;
		this.type = type;
		this.posInfos = posInfos;
	}

	public function toString():String {
		return '$message at $posInfos';
	}
}
