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

  test("name", () {
    var firstEvent = FirstTestEvent();
    var secondEvent = SecondTestEvent();

    expect(eventTaxi.registerAll(),
        emitsInOrder(<Event>[firstEvent, secondEvent]));

    eventTaxi.fire(firstEvent);
    eventTaxi.fire(secondEvent);
  });

  test("name", () {
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

  test("name", () {
    var firstEvent = FirstTestEvent();
    var secondEvent = SecondTestEvent();

    eventTaxi.fire(firstEvent);
    eventTaxi.fire(secondEvent);
    eventTaxi.fire(firstEvent);
    eventTaxi.fire(firstEvent);
    eventTaxi.fire(firstEvent);

    expect(eventTaxi.registerTo<SecondTestEvent>(true), emits(secondEvent));
  });

  test("name", () {

    var firstEvent = FirstTestEvent();
    var secondEvent = SecondTestEvent();

    eventTaxi.fire(firstEvent);
    eventTaxi.fire(secondEvent);

    expect(eventTaxi.registerAll(true), emits(secondEvent));
  });
}
