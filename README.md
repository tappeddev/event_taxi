
# EventTaxi

## Pattern

An [EventBus](https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern) follows the publish/subscribe pattern.
It allows listeners to subscribe for events and publishers to fire events.
This enables objects to interact without requiring to explicitly define listeners and keeping track of them.

## Event Taxi in Flutter Apps or Angular Web Apps

This EventBus is perfect for decoupling different layers from each other. 
Besides the standard functionality provided by 
[EventBus](https://github.com/marcojakob/dart-event-bus), it appends small additional features that we are using in our products.

## Usage


### 1. Create the Event Taxi 🚕
```dart
import 'package:event_taxi/event_taxi.dart';

// new instance
EventTaxi eventTaxi = EventTaxiImpl();

// singleton instance if preferred
EventTaxi eventTaxi = EventTaxiImpl.singleton();
```

**Note:** The EventTaxi is always a singleton

### 2. Define Events 📦
Every event has to be a sub class of `Event`.
Those classes can hold additional information if needed.

```dart
class RefreshDataEvent implements Event {
  // additional information
  final DateTime requestTime;
  final String fetchedJson;
}
```



### 3. Register Listeners 🎧
Simply call `register` to get a stream of events.
`true` will create a stream that immediately emits the last event as well. 
(Similar to a BehaviourSubject in RxDart.) 
```dart

eventBus.registerTo<RefreshDataEvent>(true).listen((event) {
    // handle event
  });

```


### 4. Fire Events 🔥
Create an instance of your Event class and use `fire`.
```dart

var event = RefreshDataEvent();
eventBus.fire(event);

```


## License

The Apache License Version 2.0 (Check the LICENCE file in this repository)

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/tikkrapp/event_taxi/issues
