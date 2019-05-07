package sys;

enum abstract FileOpenFlags(String) {
  var AppendCreate = "a";
  var Append = "ax";
  var ReadAppendCreate = "a+";
  var ReadAppend = "ax+";
  // as (synchronous mode?)
  // as+ (synchronous mode?)
  var Read = "r";
  var ReadWrite = "r+";
  // rs+ ...
  var WriteTruncate = "w";
  var Write = "wx";
  var ReadWriteTruncate = "w+";
  var ReadWrite2 = "wx+"; // ????
  
  // O_NOCTTY, O_DIRECTORY, O_NOATIME, O_NOFOLLOW, O_SYNC, O_DSYNC, O_SYMLINK, O_DIRECT, O_NONBLOCK
}
