import 'dart:async';
import 'package:floater/floater.dart';
import 'package:rxdart/rxdart.dart';

/// Event Aggregator
/// Used to propagate app specific events through out the App. Widgets, State and/or Services can consume the events published.
///
/// Specific type of event can be subscribed with: `eventAggregator.subscribe<IntEventA>()`
/// If no type is provided, the subscriber gets all the events.
///
/// Example:
/// ```dart
/// class IntEvent extends Event {
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
  Stream<T> subscribe<T extends Event>();
  void publish(Event event);
}

class FloaterEventAggregator implements EventAggregator {
  final PublishSubject<Event> _eventPublishSubject = PublishSubject();
  final Map<Type, Stream<Event>> _streamCache = {};

  /// Subscribe to an event of a specific type.
  /// If no type is provided, the subscriber receives all the event published
  @override
  Stream<T> subscribe<T extends Event>() {
    if (T == Event) return this._eventPublishSubject.stream;

    this._streamCache[T] ??= this._eventPublishSubject.stream.whereType<T>();

    return this._streamCache[T];
  }

  /// Publish an new event.
  @override
  void publish(Event event) {
    given(event, "event").ensureHasValue();
    this._eventPublishSubject.add(event);
  }

  @override
  Future<void> dispose() async {
    await this._eventPublishSubject.close();
    this._streamCache.clear();
  }
}

/// Extends this Event for newly created App event
///  Example:
/// ```dart
/// class IntEvent extends Event {
///   final int value;
///   IntEvent(this.value);
/// }
/// ```
abstract class Event {}
