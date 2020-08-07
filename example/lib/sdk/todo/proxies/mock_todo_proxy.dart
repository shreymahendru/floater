import 'package:example/sdk/todo/proxies/todo.dart';
import 'package:example/sdk/todo/proxies/todo_dto.dart';

class MockTodoProxy implements Todo {
  TodoDto _dto;

  MockTodoProxy(this._dto);

  @override
  String get id => this._dto.id;

  @override
  String get title => this._dto.title;

  @override
  String get description => this._dto.description;

  @override
  String get priority => this._dto.priority;

  @override
  bool get isComplete => this._dto.isComplete;

  @override
  Future<void> update(String title, String description, String priority) async {
    await Future.delayed(Duration(seconds: 2));

    final newDto =
        TodoDto(this.id, title, description, priority, this.isComplete);
    this._dto = newDto;
  }

  @override
  Future<void> toggleComplete() async {
    await Future.delayed(Duration(seconds: 1));

    final newDto = TodoDto(
        this.id, this.title, this.description, this.priority, !this.isComplete);
    this._dto = newDto;
  }

  factory MockTodoProxy.create(TodoDto dto) {
    return MockTodoProxy(dto);
  }
}
