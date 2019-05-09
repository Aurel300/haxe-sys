package haxe.async;

abstract Event<T>(Array<T->Void>) {
  public inline function new() this = [];
  
  public inline function on(handler:T->Void):Void {
    this.push(handler);
  }
  
  public inline function off(?handler:T->Void):Void {
    if (handler != null) {
      this.remove(handler);
    } else {
      this.resize(0);
    }
  }
  
  public inline function emit(data:T):Void {
    for (handler in this) {
      handler(data);
    }
  }
}
