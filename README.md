
# EventTaxi

## Pattern

An [EventBus](https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern) follows the publish/subscribe pattern.
It allows listeners to subscribe for events and publishers to fire events.
This enables objects to interact without requiring to explicitly define listeners and keeping track of them.

Read the full Wikipedia article: [EventBus](https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern)

## Event Taxi in Flutter Apps or Angular Web Apps

The Pattern is especially helpful for decoupling different layer from each other.
I have found another nice "EventBus Pattern": [EventBus](https://github.com/marcojakob/dart-event-bus)

This package is a EventBus but with a little bit more functionality and comfort.
This is EventTaxi :D

## Usage


### 1. Create an Event Bus

```
import 'package:event_taxi/event_taxi.dart';

EventTaxi eventBus = EventTaxiImpl();
```

**Note:** The EventTaxi is always a singleton

### 2. Define Events

You can simple create new events like this:

```
import 'package:event_taxi/event_taxi.dart';

class OnUserLoggedInEvent implements Event {
  User user;

  OnUserLoggedInEvent(this.user);
}

class OnLoggedOutEvent implements Event {
  bool success;

  OnLoggedOutEvent(this.success);
}
```



### 3. Register Listeners


### 4. Fire Events


## License

The MIT License (MIT)

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/tikkrapp/event_taxi/issues
