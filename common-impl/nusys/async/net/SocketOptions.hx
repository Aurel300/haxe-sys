package nusys.async.net;

import sys.net.*;
import nusys.net.*;

typedef SocketOptions = {
	// ?file:sys.io.File, // fd in Node
	?allowHalfOpen:Bool,
	?readable:Bool,
	?writable:Bool
};

typedef SocketConnectTcpOptions = {
	port:Int,
	?host:String,
	?address:Address,
	?localAddress:Address,
	?localPort:Int,
	?family:IpFamily
};

typedef SocketConnectIpcOptions = {
	path:String
};
