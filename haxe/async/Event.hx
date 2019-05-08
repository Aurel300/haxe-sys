package haxe.async;

class Event<T> {
  final name:String;
  final handlers:Array<T->Void> = [];
  
  public function new(emitter:EventEmitter, name:String) {
    this.name = name;
    emitter.registerEvent(this);
  }
  
  public inline function on(handler:T->Void):Void {
    handlers.push(handler);
  }
  
  public inline function off(?handler:T->Void):Void {
    if (handler != null) {
      handlers.remove(handler);
    } else {
      handlers.resize(0);
    }
  }
  
  public function emit(data:T):Void {
    for (handler in handlers) {
      handler(data);
    }
  }
}
