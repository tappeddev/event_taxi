import 'package:event_taxi/event_taxi.dart';
import 'package:event_taxi/src/event.dart';
import 'package:test/test.dart';

class FirstTestEvent implements Event {}

class SecondTestEvent implements Event {}

void main() {
  EventTaxi eventTaxi;

  setUp(() {
    eventTaxi = EventTaxiImpl();
  });

  ///
  /// First subscribe - Second fire
  ///

  test(
      "registerAll - add multiple events to eventBus - emit all events in order",
      () {
    var firstEvent = FirstTestEvent();
    var secondEvent = SecondTestEvent();

    expect(eventTaxi.registerAll(),
        emitsInOrder(<Event>[firstEvent, secondEvent]));

    eventTaxi.fire(firstEvent);
    eventTaxi.fire(secondEvent);
  });

  test(
      "registerTo - add multiple events with different types - emit the event with the right type",
      () {
    var firstEvent = FirstTestEvent();
    var secondEvent = SecondTestEvent();

    expect(eventTaxi.registerTo<SecondTestEvent>(), emits(secondEvent));

    eventTaxi.fire(firstEvent);
    eventTaxi.fire(firstEvent);
    eventTaxi.fire(firstEvent);
    eventTaxi.fire(secondEvent);
    eventTaxi.fire(firstEvent);
  });

  ///
  /// First fire - Second subscribe
  ///

  test(
      "registerTo - add mutiple events with different types - emit the event with the right type",
      () {
    var firstEvent = FirstTestEvent();
    var secondEvent = SecondTestEvent();

    eventTaxi.fire(firstEvent);
    eventTaxi.fire(secondEvent);
    eventTaxi.fire(firstEvent);
    eventTaxi.fire(firstEvent);
    eventTaxi.fire(firstEvent);

    expect(eventTaxi.registerTo<SecondTestEvent>(true), emits(secondEvent));
  });

  test("registerAll - add mutiple events with different types - emit the last fired event", () {

    // Explanation:
    //   The Behavior functionality cashes only the last event.
    //   Check the BehaviorSubject from RX to understand it.

    var firstEvent = FirstTestEvent();
    var secondEvent = SecondTestEvent();

    eventTaxi.fire(firstEvent);
    eventTaxi.fire(secondEvent);

    expect(eventTaxi.registerAll(true), emits(secondEvent));
  });
}
