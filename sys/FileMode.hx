package sys;

enum abstract FilePermissions(Int) {
  var ExecuteOthers = 1 << 0;
  var WriteOthers = 1 << 1;
  var ReadOthers = 1 << 2;
  var ExecuteGroup = 1 << 3;
  var WriteGroup = 1 << 4;
  var ReadGroup = 1 << 5;
  var ExecuteOwner = 1 << 6;
  var WriteOwner = 1 << 7;
  var ReadOwner = 1 << 8;
  
  inline function get_raw():Int return this;
  
  @:op(A | B)
  inline function join(other:FilePermissions) return this | other.get_raw();
}

