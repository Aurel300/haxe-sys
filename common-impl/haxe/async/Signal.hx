package haxe.async;

abstract Signal<T>(Array<Listener<T>>) {
  public inline function new() this = [];
  
  public inline function on(listener:Listener<T>):Void {
    this.push(listener);
  }
  
  public inline function once(listener:Listener<T>):Void {
    this.push(function wrapped(data:T):Void {
      this.remove(wrapped);
      listener(data);
    });
  }
  
  public inline function off(?listener:Listener<T>):Void {
    if (listener != null) {
      this.remove(listener);
    } else {
      this.resize(0);
    }
  }
  
  public inline function emit(data:T):Void {
    for (listener in this) {
      listener(data);
    }
  }
}
