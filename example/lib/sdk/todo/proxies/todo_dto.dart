class TodoDto {
  final String id;
  final String title;
  final String? description;
  final bool isComplete;

  TodoDto(this.id, this.title, this.description, this.isComplete);
}
