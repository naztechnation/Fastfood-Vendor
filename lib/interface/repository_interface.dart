abstract class RepositoryInterface<T> {
  Future<dynamic> add(T value);
  Future<dynamic> update(Map<String, dynamic> body);
  Future<dynamic> delete(int? id);
  Future<dynamic> getList();
  Future<dynamic> get(int? id);
}