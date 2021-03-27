import 'package:floater/src/mutex.dart';
import 'package:flutter_test/flutter_test.dart';

class _Synchronized {
  final _mutex = new Mutex();

  final _values = <int>[];
  List<int> get values => this._values;

  Future<void> execute(int milliseconds) async {
    await this._mutex.lock();
    try {
      await Future.delayed(Duration(milliseconds: milliseconds));
      this._values.add(milliseconds);
    } finally {
      this._mutex.release();
    }
  }
}

void main() {
  group("Mutex Tests", () {
    test(
        "Given a mutex, when a bunch of async calls that are resolved in order, then the calls must be synchronize (sanity check)",
        () async {
      final synchronized = new _Synchronized();

      final delays = List.generate(5, (index) => index * 1000);
      final futures = delays.map((t) => synchronized.execute(t));

      await Future.wait(futures);

      expect(synchronized.values, delays.toList());
    });

    test(
        "Given a mutex, when a bunch of async calls that are resolved in reverse order, then the calls must be synchronize",
        () async {
      final synchronized = new _Synchronized();

      final delays = List.generate(5, (index) => index * 1000).reversed;
      final futures = delays.map((t) => synchronized.execute(t));

      await Future.wait(futures);

      expect(synchronized.values, delays.toList());
    });
  });
}
