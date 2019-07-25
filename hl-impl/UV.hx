import haxe.Error;

// Handle types

typedef UVLoop = hl.Abstract<"uv_loop_t">;
typedef UVHandle = hl.Abstract<"uv_handle_t">;
typedef UVDir = hl.Abstract<"uv_dir_t">;
typedef UVStream = hl.Abstract<"uv_stream_t">;
typedef UVTcp = hl.Abstract<"uv_tcp_t">;
typedef UVUdp = hl.Abstract<"uv_udp_t">;
typedef UVPipe = hl.Abstract<"uv_pipe_t">;
typedef UVTty = hl.Abstract<"uv_tty_t">;
typedef UVPoll = hl.Abstract<"uv_poll_t">;
typedef UVTimer = hl.Abstract<"uv_timer_t">;
typedef UVPrepare = hl.Abstract<"uv_prepare_t">;
typedef UVCheck = hl.Abstract<"uv_check_t">;
typedef UVIdle = hl.Abstract<"uv_idle_t">;
typedef UVAsync = hl.Abstract<"uv_async_t">;
typedef UVProcess = hl.Abstract<"uv_process_t">;
typedef UVFsEvent = hl.Abstract<"uv_fs_event_t">;
typedef UVFsPoll = hl.Abstract<"uv_fs_poll_t">;
typedef UVSignal = hl.Abstract<"uv_signal_t">;

// Request types

typedef UVReq = hl.Abstract<"uv_req_t">;
typedef UVGetaddrinfo = hl.Abstract<"uv_getaddrinfo_t">;
typedef UVGetnameinfo = hl.Abstract<"uv_getnameinfo_t">;
typedef UVShutdown = hl.Abstract<"uv_shutdown_t">;
typedef UVWrite = hl.Abstract<"uv_write_t">;
typedef UVConnect = hl.Abstract<"uv_connect_t">;
typedef UVUdp_send = hl.Abstract<"uv_udp_send_t">;
typedef UVFs = hl.Abstract<"uv_fs_t">;
typedef UVWork = hl.Abstract<"uv_work_t">;

// Other types

typedef UVCpuInfo = hl.Abstract<"uv_cpu_info_t">;
typedef UVInterfaceAddress = hl.Abstract<"uv_interface_address_t">;
typedef UVPasswd = hl.Abstract<"uv_passwd_t">;
typedef UVUtsname = hl.Abstract<"uv_utsname_t">;
typedef UVFile = hl.Abstract<"uv_file">;

// Non-UV types

typedef UVSockaddr = hl.Abstract<"uv_sockaddr">;

// Filesystem types

typedef UVTimespec = hl.Abstract<"uv_timespec_t">;

// Enums

enum abstract UVHandleType(Int) {
  var UnknownHandle = 0;
  var Async;
  var Check;
  var FsEvent;
  var FsPoll;
  var Handle;
  var Idle;
  var NamedPipe;
  var Poll;
  var Prepare;
  var Process;
  var Stream;
  var Tcp;
  var Timer;
  var Tty;
  var Udp;
  var Signal;
  var File;
}

enum abstract UVFSType(Int) {
  var FSUnknown = -1;
  var FSCustom;
  var FSOpen;
  var FSClose;
  var FSRead;
  var FSWrite;
  var FSSendfile;
  var FSStat;
  var FSLstat;
  var FSFstat;
  var FSFtruncate;
  var FSUtime;
  var FSFutime;
  var FSAccess;
  var FSChmod;
  var FSFchmod;
  var FSFsync;
  var FSFdatasync;
  var FSUnlink;
  var FSRmdir;
  var FSMkdir;
  var FSMkdtemp;
  var FSRename;
  var FSScandir;
  var FSLink;
  var FSSymlink;
  var FSReadlink;
  var FSChown;
  var FSFchown;
  var FSRealpath;
  var FSCopyfile;
  var FSLchown;
  var FSOpendir;
  var FSReaddir;
  var FSClosedir;
}

// wrapped types

class UVDirent implements sys.DirectoryEntry {
  var name_:String;
	function get_name():String return name_;
	public var name(get, never):String;
  public final type:sys.uv.UVDirentType;
  public function new(name:hl.Bytes, type:sys.uv.UVDirentType) {
    this.name_ = @:privateAccess String.fromUTF8(name);
    this.type = type;
  }
  public function isBlockDevice():Bool return type == DirentBlock;
  public function isCharacterDevice():Bool return type == DirentChar;
  public function isDirectory():Bool return type == DirentDir;
  public function isFIFO():Bool return type == DirentFifo;
  public function isFile():Bool return type == DirentFile;
  public function isSocket():Bool return type == DirentSocket;
  public function isSymbolicLink():Bool return type == DirentLink;
}

enum UVAddrinfo {
  IPv4(ip:Int);
  IPv6(ip:haxe.io.Bytes);
}

typedef UVAddrPort = {
    final address:UVAddrinfo;
    final port:Int;
  };

@:hlNative("uv")
class UV {
  // Constants
	public static inline final FS_EVENT_RECURSIVE = 4;
  
  public static var loop:UVLoop;
  
  public static function init():Void {
    glue_register(
      (errno) -> {
        return new Error(haxe.ErrorType.UVError(cast errno));
      },
      sys.uv.UVStat.new,
      UVDirent.new,
      UVAddrinfo.IPv4,
      bytes -> UVAddrinfo.IPv6(bytes.toBytes(16)),
      (address:Dynamic, port:Int) -> ({address: address, port: port}:UVAddrPort)
    );
    loop = UV.loop_init();
  }
  
  // Glue
  public static function glue_register(
    c_error:Int->Dynamic,
    c_fs_stat:(Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int)->Dynamic,
    c_fs_dirent:(hl.Bytes, sys.uv.UVDirentType)->Dynamic,
    c_addrinfo_ipv4:Int->Dynamic,
    c_addrinfo_ipv6:hl.Bytes->Dynamic,
    c_addrport:(Dynamic, Int)->Dynamic
  ):Void {}
  
  //@:hlNative("uv", "w_test") public static function test():Void {}
  
  // Loop
  @:hlNative("uv", "w_loop_init") public static function loop_init():UVLoop return null;
  @:hlNative("uv", "w_loop_close") public static function loop_close(loop:UVLoop):Void {}
  @:hlNative("uv", "w_run") public static function run(loop:UVLoop, mode:sys.uv.UVRunMode):Bool return false;
  @:hlNative("uv", "w_loop_alive") public static function loop_alive(loop:UVLoop):Bool return false;
  public static function stop(loop:UVLoop):Void {}
  
  // Filesystem
  @:hlNative("uv", "w_fs_close") public static function fs_close(loop:UVLoop, file:UVFile, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_fs_open") public static function fs_open(loop:UVLoop, _:hl.Bytes, _:Int, _:Int, cb:Dynamic->UVFile->Void):Void {}
  @:hlNative("uv", "w_fs_read") public static function fs_read(loop:UVLoop, file:UVFile, _:hl.Bytes, _:Int, _:Int, _:Int, cb:Dynamic->Int->Void):Void {}
  @:hlNative("uv", "w_fs_unlink") public static function fs_unlink(loop:UVLoop, _:hl.Bytes, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_fs_write") public static function fs_write(loop:UVLoop, file:UVFile, _:hl.Bytes, _:Int, _:Int, _:Int, cb:Dynamic->Int->Void):Void {}
  @:hlNative("uv", "w_fs_mkdir") public static function fs_mkdir(loop:UVLoop, _:hl.Bytes, _:Int, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_fs_mkdtemp") public static function fs_mkdtemp(loop:UVLoop, _:hl.Bytes, cb:Dynamic->hl.Bytes->Void):Void {}
  @:hlNative("uv", "w_fs_rmdir") public static function fs_rmdir(loop:UVLoop, _:hl.Bytes, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_fs_scandir") public static function fs_scandir(loop:UVLoop, _:hl.Bytes, _:Int, cb:Dynamic->hl.NativeArray<UVDirent>->Void):Void {}
  @:hlNative("uv", "w_fs_stat") public static function fs_stat(loop:UVLoop, _:hl.Bytes, cb:Dynamic->sys.uv.UVStat->Void):Void {}
  @:hlNative("uv", "w_fs_fstat") public static function fs_fstat(loop:UVLoop, file:UVFile, cb:Dynamic->sys.uv.UVStat->Void):Void {}
  @:hlNative("uv", "w_fs_lstat") public static function fs_lstat(loop:UVLoop, _:hl.Bytes, cb:Dynamic->sys.uv.UVStat->Void):Void {}
  @:hlNative("uv", "w_fs_rename") public static function fs_rename(loop:UVLoop, _:hl.Bytes, _:hl.Bytes, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_fs_fsync") public static function fs_fsync(loop:UVLoop, file:UVFile, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_fs_fdatasync") public static function fs_fdatasync(loop:UVLoop, file:UVFile, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_fs_ftruncate") public static function fs_ftruncate(loop:UVLoop, file:UVFile, _:Int, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_fs_sendfile") public static function fs_sendfile(loop:UVLoop, file:UVFile, file:UVFile, _:Int, _:Int, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_fs_access") public static function fs_access(loop:UVLoop, _:hl.Bytes, _:Int, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_fs_chmod") public static function fs_chmod(loop:UVLoop, _:hl.Bytes, _:Int, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_fs_fchmod") public static function fs_fchmod(loop:UVLoop, file:UVFile, _:Int, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_fs_utime") public static function fs_utime(loop:UVLoop, _:hl.Bytes, _:Float, _:Float, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_fs_futime") public static function fs_futime(loop:UVLoop, file:UVFile, _:Float, _:Float, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_fs_link") public static function fs_link(loop:UVLoop, _:hl.Bytes, _:hl.Bytes, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_fs_symlink") public static function fs_symlink(loop:UVLoop, _:hl.Bytes, _:hl.Bytes, _:Int, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_fs_readlink") public static function fs_readlink(loop:UVLoop, _:hl.Bytes, cb:Dynamic->hl.Bytes->Void):Void {}
  @:hlNative("uv", "w_fs_realpath") public static function fs_realpath(loop:UVLoop, _:hl.Bytes, cb:Dynamic->hl.Bytes->Void):Void {}
  @:hlNative("uv", "w_fs_chown") public static function fs_chown(loop:UVLoop, _:hl.Bytes, _:Int, _:Int, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_fs_fchown") public static function fs_fchown(loop:UVLoop, file:UVFile, _:Int, _:Int, cb:Dynamic->Void):Void {}
  
  @:hlNative("uv", "w_fs_close_sync") public static function fs_close_sync(loop:UVLoop, file:UVFile):Void {}
  @:hlNative("uv", "w_fs_open_sync") public static function fs_open_sync(loop:UVLoop, _:hl.Bytes, _:Int, _:Int):UVFile return null;
  @:hlNative("uv", "w_fs_read_sync") public static function fs_read_sync(loop:UVLoop, file:UVFile, _:hl.Bytes, _:Int, _:Int, _:Int):Int return 0;
  @:hlNative("uv", "w_fs_unlink_sync") public static function fs_unlink_sync(loop:UVLoop, _:hl.Bytes):Void {}
  @:hlNative("uv", "w_fs_write_sync") public static function fs_write_sync(loop:UVLoop, file:UVFile, _:hl.Bytes, _:Int, _:Int, _:Int):Int return 0;
  @:hlNative("uv", "w_fs_mkdir_sync") public static function fs_mkdir_sync(loop:UVLoop, _:hl.Bytes, _:Int):Void {}
  @:hlNative("uv", "w_fs_mkdtemp_sync") public static function fs_mkdtemp_sync(loop:UVLoop, _:hl.Bytes):hl.Bytes return null;
  @:hlNative("uv", "w_fs_rmdir_sync") public static function fs_rmdir_sync(loop:UVLoop, _:hl.Bytes):Void {}
  @:hlNative("uv", "w_fs_scandir_sync") public static function fs_scandir_sync(loop:UVLoop, _:hl.Bytes, _:Int):hl.NativeArray<UVDirent> return null;
  @:hlNative("uv", "w_fs_stat_sync") public static function fs_stat_sync(loop:UVLoop, _:hl.Bytes):sys.uv.UVStat return null;
  @:hlNative("uv", "w_fs_fstat_sync") public static function fs_fstat_sync(loop:UVLoop, file:UVFile):sys.uv.UVStat return null;
  @:hlNative("uv", "w_fs_lstat_sync") public static function fs_lstat_sync(loop:UVLoop, _:hl.Bytes):sys.uv.UVStat return null;
  @:hlNative("uv", "w_fs_rename_sync") public static function fs_rename_sync(loop:UVLoop, _:hl.Bytes, _:hl.Bytes):Void {}
  @:hlNative("uv", "w_fs_fsync_sync") public static function fs_fsync_sync(loop:UVLoop, file:UVFile):Void {}
  @:hlNative("uv", "w_fs_fdatasync_sync") public static function fs_fdatasync_sync(loop:UVLoop, file:UVFile):Void {}
  @:hlNative("uv", "w_fs_ftruncate_sync") public static function fs_ftruncate_sync(loop:UVLoop, file:UVFile, _:Int):Void {}
  @:hlNative("uv", "w_fs_sendfile_sync") public static function fs_sendfile_sync(loop:UVLoop, file:UVFile, file:UVFile, _:Int, _:Int):Void {}
  @:hlNative("uv", "w_fs_access_sync") public static function fs_access_sync(loop:UVLoop, _:hl.Bytes, _:Int):Void {}
  @:hlNative("uv", "w_fs_chmod_sync") public static function fs_chmod_sync(loop:UVLoop, _:hl.Bytes, _:Int):Void {}
  @:hlNative("uv", "w_fs_fchmod_sync") public static function fs_fchmod_sync(loop:UVLoop, file:UVFile, _:Int):Void {}
  @:hlNative("uv", "w_fs_utime_sync") public static function fs_utime_sync(loop:UVLoop, _:hl.Bytes, _:Float, _:Float):Void {}
  @:hlNative("uv", "w_fs_futime_sync") public static function fs_futime_sync(loop:UVLoop, file:UVFile, _:Float, _:Float):Void {}
  @:hlNative("uv", "w_fs_link_sync") public static function fs_link_sync(loop:UVLoop, _:hl.Bytes, _:hl.Bytes):Void {}
  @:hlNative("uv", "w_fs_symlink_sync") public static function fs_symlink_sync(loop:UVLoop, _:hl.Bytes, _:hl.Bytes, _:Int):Void {}
  @:hlNative("uv", "w_fs_readlink_sync") public static function fs_readlink_sync(loop:UVLoop, _:hl.Bytes):hl.Bytes return null;
  @:hlNative("uv", "w_fs_realpath_sync") public static function fs_realpath_sync(loop:UVLoop, _:hl.Bytes):hl.Bytes return null;
  @:hlNative("uv", "w_fs_chown_sync") public static function fs_chown_sync(loop:UVLoop, _:hl.Bytes, _:Int, _:Int):Void {}
  @:hlNative("uv", "w_fs_fchown_sync") public static function fs_fchown_sync(loop:UVLoop, file:UVFile, _:Int, _:Int):Void {}
  
  // Filesystem events
  @:hlNative("uv", "w_fs_event_start") public static function fs_event_start(loop:UVLoop, _:hl.Bytes, persistent:Bool, recursive:Bool, cb:(Dynamic, hl.Bytes, Int)->Void):UVFsEvent return null;
  @:hlNative("uv", "w_fs_event_stop") public static function fs_event_stop(handle:UVFsEvent, cb:Dynamic->Void):Void {}
  
  // TCP
  @:hlNative("uv", "w_tcp_init") public static function tcp_init(loop:UVLoop):UVTcp return null;
  @:hlNative("uv", "w_tcp_nodelay") public static function tcp_nodelay(handle:UVTcp, enable:Bool):Void {}
  @:hlNative("uv", "w_tcp_keepalive") public static function tcp_keepalive(handle:UVTcp, enable:Bool, delay:Int):Void {}
  @:hlNative("uv", "w_tcp_bind_ipv4") public static function tcp_bind_ipv4(handle:UVTcp, host:Int, port:Int):Void {}
  @:hlNative("uv", "w_tcp_bind_ipv6") public static function tcp_bind_ipv6(handle:UVTcp, host:hl.Bytes, port:Int):Void {}
  @:hlNative("uv", "w_tcp_connect_ipv4") public static function tcp_connect_ipv4(handle:UVTcp, host:Int, port:Int, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_tcp_connect_ipv6") public static function tcp_connect_ipv6(handle:UVTcp, host:hl.Bytes, port:Int, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_tcp_listen") public static function tcp_listen(handle:UVTcp, backlog:Int, cb:Dynamic->Void):Void {}
  //@:hlNative("uv", "w_tcp_write") public static function tcp_write(handle:UVTcp, buf:hl.Bytes, length:Int, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_tcp_shutdown") public static function tcp_shutdown(handle:UVTcp, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_tcp_close") public static function tcp_close(handle:UVTcp, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_tcp_accept") public static function tcp_accept(loop:UVLoop, handle:UVTcp):UVTcp return null;
  @:hlNative("uv", "w_tcp_read_start") public static function tcp_read_start(handle:UVTcp, cb:(Dynamic, hl.Bytes, Int)->Void):Void {}
  @:hlNative("uv", "w_tcp_read_stop") public static function tcp_read_stop(handle:UVTcp):Void {}
  
  // UDP
  @:hlNative("uv", "w_udp_init") public static function udp_init(loop:UVLoop):UVUdp return null;
  @:hlNative("uv", "w_udp_bind_ipv4") public static function udp_bind_ipv4(handle:UVUdp, host:Int, port:Int):Void {}
  @:hlNative("uv", "w_udp_bind_ipv6") public static function udp_bind_ipv6(handle:UVUdp, host:hl.Bytes, port:Int):Void {}
  @:hlNative("uv", "w_udp_send_ipv4") public static function udp_send_ipv4(handle:UVUdp, buf:hl.Bytes, length:Int, host:Int, port:Int, cb:Dynamic->Void):Void {}  
  @:hlNative("uv", "w_udp_send_ipv6") public static function udp_send_ipv6(handle:UVUdp, buf:hl.Bytes, length:Int, host:hl.Bytes, port:Int, cb:Dynamic->Void):Void {}  
  @:hlNative("uv", "w_udp_recv_start") public static function udp_recv_start(handle:UVUdp, cb:(Dynamic, hl.Bytes, Int, Dynamic)->Void):Void {}  
  @:hlNative("uv", "w_udp_recv_stop") public static function udp_recv_stop(handle:UVUdp):Void {}  
  
  // DNS
  @:hlNative("uv", "w_getaddrinfo") public static function getaddrinfo(loop:UVLoop, node:hl.Bytes, service:hl.Bytes, hint_flags:Int, hint_family:Int, hint_socktype:Int, hint_protocol:Int, cb:(Dynamic, hl.NativeArray<UVAddrinfo>)->Void):Void {}
  @:hlNative("uv", "w_getnameinfo_ipv4") public static function getnameinfo_ipv4(loop:UVLoop, ip:Int, flags:Int, cb:(Dynamic, hl.Bytes, hl.Bytes)->Void):Void {}
  @:hlNative("uv", "w_getnameinfo_ipv6") public static function getnameinfo_ipv6(loop:UVLoop, ip:hl.Bytes, flags:Int, cb:(Dynamic, hl.Bytes, hl.Bytes)->Void):Void {}
}
