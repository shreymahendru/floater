import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:pedantic/pedantic.dart';
// import 'defensive.dart';
import 'service_locator.dart';

/// Event Aggregator
/// Used to propagate app specific events through out the App. Widgets, State and/or Services can consume the events published.
///
/// Specific type of event can be subscribed with: `eventAggregator.subscribe<IntEventA>()`
/// If no type is provided, the subscriber gets all the events.
///
/// Example:
/// ```dart
/// class IntEvent {
///   final int value;
///   IntEvent(this.value);
/// }
///
/// final ea = EventAggregator();
///
/// ea.subscribe<IntEventA>().listen((event) {
///   print(event.value);
/// })
///
/// ea.publish(IntEvent(1));
/// ea.publish(ArbitraryEvent());
/// ```
///
/// The above code prints `1` cause of the first event, and the listener doesn't receive `ArbitraryEvent()`

abstract class EventAggregator implements Disposable {
  Stream<T> subscribe<T>();
  void publish<T>(T event);
}

class FloaterEventAggregator implements EventAggregator {
  final PublishSubject _eventPublishSubject = PublishSubject();
  final Map<Type, Stream> _streamCache = {};

  bool _isDisposed = false;

  /// Subscribe to an event of a specific type.
  /// If no type is provided, the subscriber receives all the event published
  @override
  Stream<T> subscribe<T>() {
    if (this._isDisposed) throw new Exception("Object disposed");

    this._streamCache[T] ??= this._eventPublishSubject.stream.whereType<T>();
    return this._streamCache[T] as Stream<T>;
  }

  /// Publish an new event.
  @override
  void publish<T>(T event) {
    // given(event, "event").ensureHasValue();

    if (this._isDisposed) throw new Exception("Object disposed");

    this._eventPublishSubject.add(event);
  }

  @override
  void dispose() {
    if (this._isDisposed) return;

    this._isDisposed = true;
    unawaited(this._eventPublishSubject.close());
    this._streamCache.clear();
  }
}
