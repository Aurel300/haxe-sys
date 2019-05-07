package haxe;

import haxe.PosInfos;

class Error {
  public var message(default, null):String;
  public var posInfos(default, null):PosInfos;
  
  public function new(message:String, ?posInfos:PosInfos) {
    this.message = message;
    this.posInfos = posInfos;
  }
  
  public function toString():String {
    return '$message at $posInfos';
  }
}
