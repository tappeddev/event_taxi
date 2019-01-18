import 'package:event_taxi/event_taxi.dart';
import 'package:event_taxi/src/event.dart';

class TextEvent implements Event {
  /// The [Event] class is immutable, that means that all properties must be final
  final int textCounter;

  TextEvent(this.textCounter);
}

main() {
  // This is a ui page
  iAmAPage();

  // This is another ui page
  iAmAnotherPage();
}

void iAmAPage() {
  EventTaxi eventBus = EventTaxiImpl();

  eventBus.registerTo<TextEvent>(true).listen((textEvent) {
    // Now you have event
  });
}

void iAmAnotherPage() {
  EventTaxi eventTaxi = EventTaxiImpl();

  // We send the event through the eventBus
  eventTaxi.fire(TextEvent(22));
}
