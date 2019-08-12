package nusys.net;

/**
	Reperesents the address of a connected `Socket` object.
**/
enum SocketAddress {
	Network(address:Address, port:Int);
	Unix(name:String);
}
