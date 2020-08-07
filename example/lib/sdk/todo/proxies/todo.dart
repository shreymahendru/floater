abstract class Todo {
  String get id;
  String get title;
  String get description;
  String get priority;
  bool get isComplete;

  Future<void> toggleComplete();
  Future<void> update(String title, String description, String priority);
}
