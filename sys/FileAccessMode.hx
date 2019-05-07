package sys;

enum abstract FileAccessMode(Int) {
  var Ok = 1 << 0;
  var Read = 1 << 1;
  var Write = 1 << 2;
  var Execute = 1 << 3;
  
  inline function get_raw():Int return this;
  
  @:op(A | B)
  inline function join(other:FileAccessMode) return this | other.get_raw();
}
