import 'dart:async';

/// Mutual Exclusion Lock
/// Used to protect critical section of the code in order to avoid race conditions.
/// It ensures FIFO lock accusation.
/// Every acquirer gets the lock in order of when they asked for it,
/// given it is released by the previous acquirer, if there is no previous acquirer then lock is acquired right away
///
/// Example:
///
/// ```dart
/// class _Synchronized {
///  final _mutex = new Mutex();
///
///  final _values = new List<int>();
///  List<int> get values => this._values;
///
///  Future<void> execute(int milliseconds) async {
///    await this._mutex.lock();
///    try {
///      await Future.delayed(Duration(milliseconds: milliseconds));
///      this._values.add(milliseconds);
///    } finally {
///      this._mutex.release();
///    }
///  }
///}
///  final synchronized = new _Synchronized();
///  final delays = List.generate(5, (index) => index * 1000).reversed;
///  final futures = delays.map((t) => synchronized.execute(t));
///  await Future.wait(futures);
///  print(synchronized.value)
/// ```
/// The above code will print `[4000, 3000, 2000, 1000, 0]`

class Mutex {
  final List<Completer<void>> _waitingAcquirers = [];
  Completer<void> _currentAcquirer;

  Future<void> lock() {
    final completer = new Completer<void>();

    this._waitingAcquirers.add(completer);
    // let the first one pass
    if (this._waitingAcquirers.length == 1) {
      this._currentAcquirer = completer;
      this._currentAcquirer.complete();
    }

    return completer.future;
  }

  void release() {
    if (this._currentAcquirer == null) return;

    this._waitingAcquirers.remove(this._currentAcquirer);

    // when released by the current acquirer, let the next one pass if any.
    if (this._waitingAcquirers.isNotEmpty) {
      this._currentAcquirer = this._waitingAcquirers.first;
      this._currentAcquirer.complete();
    } else {
      this._currentAcquirer = null;
    }
  }
}
