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
  bool get isComplete => this._dto.isComplete;

  @override
  Future<void> update(String title, String description) async {
    await Future.delayed(Duration(seconds: 2));

    final newDto = TodoDto(this.id, title, description, this.isComplete);
    this._dto = newDto;
  }

  @override
  Future<void> toggleComplete() async {
    await Future.delayed(Duration(seconds: 1));

    final newDto = TodoDto(this.id, this.title, this.description, !this.isComplete);
    this._dto = newDto;
  }

  factory MockTodoProxy.create(TodoDto dto) {
    return MockTodoProxy(dto);
  }
}
