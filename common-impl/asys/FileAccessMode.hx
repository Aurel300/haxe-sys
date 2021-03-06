package asys;

/**
	Wrapper for file access modes. See `asys.FileSystem.access`.
**/
enum abstract FileAccessMode(Int) {
	var Ok = 0;
	var Execute = 1 << 0;
	var Write = 1 << 1;
	var Read = 1 << 2;

	inline function get_raw():Int return this;

	@:op(A | B)
	inline function join(other:FileAccessMode) return this | other.get_raw();
}
