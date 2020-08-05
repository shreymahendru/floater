abstract class Todo {
  String get id;
  String get title;
  String get description;
  bool get isComplete;

  Future<void> toggleComplete();
  Future<void> update(String title, String description);
}
