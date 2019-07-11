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
typedef UVBuf = hl.Abstract<"uv_buf_t">;

// Non-UV types

typedef UVSockaddr = hl.Abstract<"uv_sockaddr">;

// Filesystem types

typedef UVTimespec = hl.Abstract<"uv_timespec_t">;

// Enums

enum abstract UVRunMode(Int) {
  var RunDefault = 0;
  var RunOnce;
  var RunNoWait;
}

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

enum abstract UVDirentType(Int) {
  var DirentUnknown = 0;
  var DirentFile;
  var DirentDir;
  var DirentLink;
  var DirentFifo;
  var DirentSocket;
  var DirentChar;
  var DirentBlock;
}

// wrapped types

class UVStat {
  public final dev:Int;
  public final mode:Int;
  public final nlink:Int;
  public final uid:Int;
  public final gid:Int;
  public final rdev:Int;
  public final ino:Int;
  public final size:Int;
  public final blksize:Int;
  public final blocks:Int;
  public final flags:Int;
  public final gen:Int;
  public function new(st_dev:Int, st_mode:Int, st_nlink:Int, st_uid:Int, st_gid:Int, st_rdev:Int, st_ino:Int, st_size:Int, st_blksize:Int, st_blocks:Int, st_flags:Int, st_gen:Int) {
    dev = st_dev;
    mode = st_mode;
    nlink = st_nlink;
    uid = st_uid;
    gid = st_gid;
    rdev = st_rdev;
    ino = st_ino;
    size = st_size;
    blksize = st_blksize;
    blocks = st_blocks;
    flags = st_flags;
    gen = st_gen;
  }
  public function toString():String {
    return '{\n'
      + ' dev: ${dev},\n'
      + ' mode: ${mode},\n'
      + ' nlink: ${nlink},\n'
      + ' uid: ${uid},\n'
      + ' gid: ${gid},\n'
      + ' rdev: ${rdev},\n'
      + ' ino: ${ino},\n'
      + ' size: ${size},\n'
      + ' blksize: ${blksize},\n'
      + ' blocks: ${blocks},\n'
      + ' flags: ${flags},\n'
      + ' gen: ${gen},\n'
      + '}';
  }
}

class UVDirent {
  public final name:String;
  public final type:UVDirentType;
  public function new(name:hl.Bytes, type:UVDirentType) {
    this.name = @:privateAccess String.fromUTF8(name);
    this.type = type;
  }
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
  public static inline final O_APPEND = 0x400;
  public static inline final O_CREAT = 0x40;
  public static inline final O_DIRECT = 0x4000;
  public static inline final O_DIRECTORY = 0x10000;
  public static inline final O_DSYNC = 0x1000;
  public static inline final O_EXCL = 0x80;
  public static inline final O_NOATIME = 0x40000;
  public static inline final O_NOCTTY = 0x100;
  public static inline final O_NOFOLLOW = 0x20000;
  public static inline final O_NONBLOCK = 0x800;
  public static inline final O_RDONLY = 0x0;
  public static inline final O_RDWR = 0x2;
  public static inline final O_SYNC = 0x101000;
  public static inline final O_TRUNC = 0x200;
  public static inline final O_WRONLY = 0x1;
  
  public static var loop:UVLoop;
  
  public static function init():Void {
    glue_register(
      (msgBytes) -> {
        var msg = @:privateAccess String.fromUTF8(msgBytes);
        return new Error(msg, UVError);
      },
      UVStat.new,
      UVDirent.new,
      UVAddrinfo.IPv4,
      bytes -> UVAddrinfo.IPv6(bytes.toBytes(16)),
      (address:Dynamic, port:Int) -> ({address: address, port: port}:UVAddrPort)
    );
    loop = UV.loop_init();
  }
  
  // Glue
  public static function glue_register(
    c_error:hl.Bytes->Dynamic,
    c_fs_stat:(Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int)->Dynamic,
    c_fs_dirent:(hl.Bytes, UVDirentType)->Dynamic,
    c_addrinfo_ipv4:Int->Dynamic,
    c_addrinfo_ipv6:hl.Bytes->Dynamic,
    c_addrport:(Dynamic, Int)->Dynamic
  ):Void {}
  
  //@:hlNative("uv", "w_test") public static function test():Void {}
  
  // Loop
  @:hlNative("uv", "w_loop_init") public static function loop_init():UVLoop return null;
  @:hlNative("uv", "w_loop_close") public static function loop_close(loop:UVLoop):Bool return false;
  @:hlNative("uv", "w_run") public static function run(loop:UVLoop, mode:UVRunMode):Bool return false;
  @:hlNative("uv", "w_loop_alive") public static function loop_alive(loop:UVLoop):Bool return false;
  public static function stop(loop:UVLoop):Void {}
  
  // Misc
  @:hlNative("uv", "w_buf_init") public static function buf_init(bytes:hl.Bytes, len:Int):UVBuf return null;
  
  // Filesystem
  @:hlNative("uv", "w_fs_close") public static function fs_close(loop:UVLoop, file:UVFile, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_fs_open") public static function fs_open(loop:UVLoop, _:hl.Bytes, _:Int, _:Int, cb:Dynamic->UVFile->Void):Void {}
  @:hlNative("uv", "w_fs_read") public static function fs_read(loop:UVLoop, file:UVFile, _:UVBuf, _:Int, cb:Dynamic->Int->Void):Void {}
  @:hlNative("uv", "w_fs_unlink") public static function fs_unlink(loop:UVLoop, _:hl.Bytes, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_fs_write") public static function fs_write(loop:UVLoop, file:UVFile, _:UVBuf, _:Int, cb:Dynamic->Int->Void):Void {}
  @:hlNative("uv", "w_fs_mkdir") public static function fs_mkdir(loop:UVLoop, _:hl.Bytes, _:Int, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_fs_mkdtemp") public static function fs_mkdtemp(loop:UVLoop, _:hl.Bytes, cb:Dynamic->hl.Bytes->Void):Void {}
  @:hlNative("uv", "w_fs_rmdir") public static function fs_rmdir(loop:UVLoop, _:hl.Bytes, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_fs_scandir") public static function fs_scandir(loop:UVLoop, _:hl.Bytes, _:Int, cb:Dynamic->hl.NativeArray<UVDirent>->Void):Void {}
  @:hlNative("uv", "w_fs_stat") public static function fs_stat(loop:UVLoop, _:hl.Bytes, cb:Dynamic->UVStat->Void):Void {}
  @:hlNative("uv", "w_fs_fstat") public static function fs_fstat(loop:UVLoop, file:UVFile, cb:Dynamic->UVStat->Void):Void {}
  @:hlNative("uv", "w_fs_lstat") public static function fs_lstat(loop:UVLoop, _:hl.Bytes, cb:Dynamic->UVStat->Void):Void {}
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
  @:hlNative("uv", "w_fs_read_sync") public static function fs_read_sync(loop:UVLoop, file:UVFile, _:UVBuf, _:Int):Int return 0;
  @:hlNative("uv", "w_fs_unlink_sync") public static function fs_unlink_sync(loop:UVLoop, _:hl.Bytes):Void {}
  @:hlNative("uv", "w_fs_write_sync") public static function fs_write_sync(loop:UVLoop, file:UVFile, _:UVBuf, _:Int):Int return 0;
  @:hlNative("uv", "w_fs_mkdir_sync") public static function fs_mkdir_sync(loop:UVLoop, _:hl.Bytes, _:Int):Void {}
  @:hlNative("uv", "w_fs_mkdtemp_sync") public static function fs_mkdtemp_sync(loop:UVLoop, _:hl.Bytes):hl.Bytes return null;
  @:hlNative("uv", "w_fs_rmdir_sync") public static function fs_rmdir_sync(loop:UVLoop, _:hl.Bytes):Void {}
  @:hlNative("uv", "w_fs_scandir_sync") public static function fs_scandir_sync(loop:UVLoop, _:hl.Bytes, _:Int):hl.NativeArray<UVDirent> return null;
  @:hlNative("uv", "w_fs_stat_sync") public static function fs_stat_sync(loop:UVLoop, _:hl.Bytes):UVStat return null;
  @:hlNative("uv", "w_fs_fstat_sync") public static function fs_fstat_sync(loop:UVLoop, file:UVFile):UVStat return null;
  @:hlNative("uv", "w_fs_lstat_sync") public static function fs_lstat_sync(loop:UVLoop, _:hl.Bytes):UVStat return null;
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
  
  // TCP
  @:hlNative("uv", "w_tcp_init") public static function tcp_init(loop:UVLoop):UVTcp return null;
  @:hlNative("uv", "w_tcp_nodelay") public static function tcp_nodelay(handle:UVTcp, enable:Bool):Void {}
  @:hlNative("uv", "w_tcp_keepalive") public static function tcp_keepalive(handle:UVTcp, enable:Bool, delay:Int):Void {}
  @:hlNative("uv", "w_tcp_bind_ipv4") public static function tcp_bind_ipv4(handle:UVTcp, host:Int, port:Int):Void {}
  @:hlNative("uv", "w_tcp_bind_ipv6") public static function tcp_bind_ipv6(handle:UVTcp, host:hl.Bytes, port:Int):Void {}
  @:hlNative("uv", "w_tcp_connect_ipv4") public static function tcp_connect_ipv4(handle:UVTcp, host:Int, port:Int, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_tcp_connect_ipv6") public static function tcp_connect_ipv6(handle:UVTcp, host:hl.Bytes, port:Int, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_tcp_listen") public static function tcp_listen(handle:UVTcp, backlog:Int, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_tcp_write") public static function tcp_write(handle:UVTcp, buf:UVBuf, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_tcp_shutdown") public static function tcp_shutdown(handle:UVTcp, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_tcp_close") public static function tcp_close(handle:UVTcp, cb:Dynamic->Void):Void {}
  @:hlNative("uv", "w_tcp_accept") public static function tcp_accept(loop:UVLoop, handle:UVTcp):UVTcp return null;
  @:hlNative("uv", "w_tcp_read_start") public static function tcp_read_start(handle:UVTcp, cb:(Dynamic, hl.Bytes, Int)->Void):Void {}
  @:hlNative("uv", "w_tcp_read_stop") public static function tcp_read_stop(handle:UVTcp):Void {}
  
  // UDP
  @:hlNative("uv", "w_udp_init") public static function udp_init(loop:UVLoop):UVUdp return null;
  @:hlNative("uv", "w_udp_bind_ipv4") public static function udp_bind_ipv4(handle:UVUdp, host:Int, port:Int):Void {}
  @:hlNative("uv", "w_udp_bind_ipv6") public static function udp_bind_ipv6(handle:UVUdp, host:hl.Bytes, port:Int):Void {}
  @:hlNative("uv", "w_udp_send_ipv4") public static function udp_send_ipv4(handle:UVUdp, buf:UVBuf, host:Int, port:Int, cb:Dynamic->Void):Void {}  
  @:hlNative("uv", "w_udp_send_ipv6") public static function udp_send_ipv6(handle:UVUdp, buf:UVBuf, host:hl.Bytes, port:Int, cb:Dynamic->Void):Void {}  
  @:hlNative("uv", "w_udp_recv_start") public static function udp_recv_start(handle:UVUdp, cb:(Dynamic, hl.Bytes, Int, Dynamic)->Void):Void {}  
  @:hlNative("uv", "w_udp_recv_stop") public static function udp_recv_stop(handle:UVUdp):Void {}  
  
  // DNS
  @:hlNative("uv", "w_getaddrinfo") public static function getaddrinfo(loop:UVLoop, node:hl.Bytes, service:hl.Bytes, hint_flags:Int, hint_family:Int, hint_socktype:Int, hint_protocol:Int, cb:(Dynamic, hl.NativeArray<UVAddrinfo>)->Void):Void {}
  @:hlNative("uv", "w_getnameinfo_ipv4") public static function getnameinfo_ipv4(loop:UVLoop, ip:Int, flags:Int, cb:(Dynamic, hl.Bytes, hl.Bytes)->Void):Void {}
  @:hlNative("uv", "w_getnameinfo_ipv6") public static function getnameinfo_ipv6(loop:UVLoop, ip:hl.Bytes, flags:Int, cb:(Dynamic, hl.Bytes, hl.Bytes)->Void):Void {}
}