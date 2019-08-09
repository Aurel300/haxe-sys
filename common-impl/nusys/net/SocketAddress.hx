package nusys.net;

enum SocketAddress {
	Network(address:Address, port:Int);
	Unix(name:String);
}
