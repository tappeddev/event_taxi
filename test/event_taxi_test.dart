import 'package:event_taxi/event_taxi.dart';
import 'package:event_taxi/src/event.dart';
import 'package:test/test.dart';

class FirstTestEvent implements Event {}

class SecondTextEvent implements Event {}

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
    var secondEvent = SecondTextEvent();

    expect(eventTaxi.registerAll(),
        emitsInOrder(<Event>[firstEvent, secondEvent]));

    eventTaxi.fire(firstEvent);
    eventTaxi.fire(secondEvent);
  });

  test("name", () {
    var firstEvent = FirstTestEvent();
    var secondEvent = SecondTextEvent();

    expect(eventTaxi.registerTo<SecondTextEvent>(), emits(secondEvent));

    eventTaxi.fire(firstEvent);
    eventTaxi.fire(firstEvent);
    eventTaxi.fire(firstEvent);
    eventTaxi.fire(secondEvent);
    eventTaxi.fire(firstEvent);
  });

  ///
  /// First fire - Second subscribe
  ///

  test("name",
      () {



    /*eventTaxi.fire(createTaskEvent);
    eventTaxi.fire(createProjectEvent);
    eventTaxi.fire(createTaskEvent);
    eventTaxi.fire(createTaskEvent);
    eventTaxi.fire(createTaskEvent);

    expect(eventTaxi.registerTo<OnProjectCreatedEvent>(true),
        emits(createProjectEvent));*/
  });

  test("name", () {
    /*eventTaxi.fire(createProjectEvent);
    eventTaxi.fire(createTaskEvent);

    expect(eventTaxi.registerAll(true), emits(createTaskEvent));*/
  });
}
