abstract class Serializer<T> {
  Map<String, dynamic> toMap(T value);
  T fromMap(Map<String, dynamic> map);
}
