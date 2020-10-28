import 'package:floater/src/event_aggregator.dart';
import 'package:flutter_test/flutter_test.dart';

class EventA {}

class EventB {}

class EventC {}

class IntEvent {
  final int value;
  IntEvent(this.value);
}

void main() {
  group("FloaterEventAggregator Tests", () {
    test('''Given Event Aggregator and a subscriber that is subscribed with no type, 
          when a some events are publish, 
          then the subscriber should receive all events.''', () async {
      final ea = FloaterEventAggregator();
      final eventStream = ea.subscribe();
      final events = [EventA(), EventB(), EventA(), EventC()];

      final streamEvents = eventStream.toList();

      for (final event in events) {
        ea.publish(event);
      }

      ea.dispose();

      expect(await streamEvents, events);
    });

    test('''Given Event Aggregator and a subscriber that is subscribed to EventA Type, 
          when events of different types are published, 
          then the subscriber should only receive events of Type EventA.''', () async {
      final ea = FloaterEventAggregator();
      final eventsA = [EventA(), EventA()];
      final events = [eventsA[0], EventB(), eventsA[1], EventC()];
      final eventStream = ea.subscribe<EventA>();

      final streamEvents = eventStream.toList();

      for (final event in events) {
        ea.publish(event);
      }

      ea.dispose();

      expect(await streamEvents, eventsA);
    });

    test('''Given Event Aggregator and a subscriber that is subscribed to type EventA, 
          when events of different types are published with no EventA, 
          then the subscriber should not receive any events.''', () async {
      final ea = FloaterEventAggregator();
      final events = [EventB(), EventC()];
      final eventStream = ea.subscribe<EventA>();

      final streamEvents = eventStream.toList();

      for (final event in events) {
        ea.publish(event);
      }

      ea.dispose();

      expect(await streamEvents, []);
    });

    test('''Given Event Aggregator and 2 subscribers that are subscribed to type EventA, 
          when events of different types are published, 
          then both subscribers should receive events of Type EventA.''', () async {
      final ea = FloaterEventAggregator();
      final eventsA = [EventA(), EventA()];
      final events = [eventsA[0], EventB(), eventsA[1], EventC()];
      final eventStream1 = ea.subscribe<EventA>();
      final eventStream2 = ea.subscribe<EventA>();

      final stream1Events = eventStream1.toList();
      final stream2Events = eventStream2.toList();

      for (final event in events) {
        ea.publish(event);
      }

      ea.dispose();

      expect(await stream1Events, eventsA);
      expect(await stream2Events, eventsA);
    });

    test('''Given Event Aggregator and 2 subscribers that are subscribed to IntEvent, 
          when 4 IntEvent are published, 2 after first is subscribed and 2 when second is subscribed and first is unsubscribed, 
          then subscriber 1 is should receive first 2 events and second should receive the next 2.''',
        () async {
      final ea = FloaterEventAggregator();

      int i = 1;
      final sub1 = ea.subscribe<IntEvent>().listen(expectAsync1((event) {
            expect(event.value, i);
            i++;
          }, count: 2, max: 0));

      ea.publish(IntEvent(1));
      ea.publish(IntEvent(2));

      // wait for the events to propagate
      await Future.delayed(Duration(milliseconds: 0));
      await sub1.cancel();

      final sub2 = ea.subscribe<IntEvent>().listen(expectAsync1((event) {
            expect(event.value, i);
            i++;
          }, count: 2, max: 0));

      ea.publish(IntEvent(3));
      ea.publish(IntEvent(4));

      // wait for the events to propagate
      await Future.delayed(Duration(milliseconds: 0));
      await sub2.cancel();
      ea.dispose();
    });

    test('''Given Event Aggregator that is disposed, 
          when a trying to subscribe and publish
          should throw object disposed exception.''', () async {
      final ea = FloaterEventAggregator();
      ea.dispose();

      expect(() => ea.publish(EventA()), throwsException);
      expect(() => ea.subscribe(), throwsException);
    });
  });
}
