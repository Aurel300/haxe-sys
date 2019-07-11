package sys;

enum abstract SymlinkType(Int) {
  var SymlinkDir = 1;
  var SymlinkJunction = 2; // Windows only
  
  inline function get_raw():Int return this;
}
