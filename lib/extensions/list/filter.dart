// Filter out T from stream with List of T 
extension Filter<T> on Stream<List<T>>{
  Stream<List<T>> filter(bool Function(T) where) =>
    map((items) => items.where(where).toList());
  
}