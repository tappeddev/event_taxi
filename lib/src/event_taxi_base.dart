import 'dart:async';

import 'package:event_taxi/src/event.dart';
import 'package:event_taxi/src/event_controller.dart';


/// Dispatches events to listeners using the Dart [Stream] API. The [EventTaxi]
/// enables decoupled applications. It allows objects to interact without
/// requiring to explicitly define listeners and keeping track of them.
///
/// The [EventTaxi] dispatches [Event] and distributes it to all listeners
/// A [Event] is a normal Dart objects the implements the [Event] interface.
///
abstract class EventTaxi {

  /// Fire = Send a [Event] through the [EventTaxi]
  /// Send subclasses of [Event] through the Dart [Stream] API.
  void fire<T extends Event>(T event);

  /// Listens for events of Type [Event] and its subtypes.
  ///
  /// The method is called like this: eventBus.registerTo<MyEvent>();
  ///
  Stream<T> registerTo<T extends Event>([bool includeLastEvent = false]);

  /// Listens for events of all subtypes of [Event].
  ///
  /// The method is called like this: eventBus.registerAll();
  ///
  /// The returning [Stream] contains every event of this [EventTaxi].
  Stream<Event> registerAll([bool includeLastEvent = false]);

  /// Cancel all [Stream]'s to avoid memory leaks
  void close();
}


class EventTaxiImpl implements EventTaxi {

  /// The single instance of the [EventTaxi].
  /// It needs to be a single instance because we don't want to lose [Event]'s
  static final EventTaxiImpl _instance = EventTaxiImpl._();


  final Map<String, List<EventController<Event>>> _streamEventMap = Map();

  /// This [Map] stores all last events.
  /// It stores only the last event.
  /// It will be overrode if there are a new [Event] from the same type / key
  final Map<String, Event> _lastEvents = Map();

  /// The key is for the function [registerAll].
  /// The [_streamEventMap] and the [_allEventsKey] contains each single [Event]
  final String _allEventsKey = "ALL_EVENTS";

  /// Info if the eventBus is closed
  /// You need to close the [EventTaxi], if you don't need it anymore
  /// If you don't close the [EventTaxi], you may get memory leak issues.
  bool _eventBusIsAlreadyClosed = false;


  /// Private constructor - Use the factory to get the instance of the [EventTaxi].
  EventTaxiImpl._(){
    _streamEventMap[_allEventsKey] = List();
  }


  /// This class has only one instance
  factory EventTaxiImpl() => _instance;

  /// You can only send subclasses of [Event].
  /// You can simply create [Event] like this:
  ///
  /// Example:
  ///   class OnUserCreatedEvent implements Event{
  ///       OnUserCreatedEvent();
  ///   }
  ///
  /// This method notifies all listeners and stores the last event of every specific [Event]
  ///
  @override
  void fire<T extends Event>(T event) {
    assert(!_eventBusIsAlreadyClosed, "EventBus is already closed");

    /// The name / key of the map for the events
    String name = T.toString();

    _lastEvents[name] = event;

    _notifyAll(event);
    _notifySingle(T.toString(), event);
  }

  @override
  Stream<Event> registerAll([bool includeLastEvent = false]) {
    assert(!_eventBusIsAlreadyClosed, "EventBus is already closed");

    /// If this is the first time listening to this event, the list is null
    _streamEventMap[_allEventsKey] ??= List();

    EventController<Event> controller =
    _createAndAddController(includeLastEvent, _allEventsKey);

    /// If the [previousEvent] parameter is set to true, we add the last event to the [EventController]
    if (includeLastEvent) {
      controller.add(_lastEvents.values.last);
    }

    return controller.stream.asBroadcastStream();
  }

  @override
  Stream<T> registerTo<T extends Event>([bool includeLastEvent = false]) {
    assert(!_eventBusIsAlreadyClosed, "EventBus is already closed");

    /// The name / key of the map for the events
    String eventKeyName = T.toString();

    _streamEventMap[eventKeyName] ??= List();

    EventController<Event> controller =
    _createAndAddController(includeLastEvent, eventKeyName);

    /// If the [previousEvent] parameter is set to true, we add the last event to the [EventController]
    if (includeLastEvent) {
      controller.add(_lastEvents[eventKeyName]);
    }

    return controller.stream
        .where((Event event) => event is T)
        .cast<T>()
        .asBroadcastStream();
  }

  @override
  void close() {
    _streamEventMap.values
        .forEach((sinkMaps) => sinkMaps.forEach((sink) => sink?.close()));
    _streamEventMap.clear();
    _eventBusIsAlreadyClosed = true;
  }

  // -----
  // Helper
  // -----

  EventController<Event> _createAndAddController(
      bool previousEvents, String key) {
    EventController<Event> eventController = previousEvents
        ? BehaviourEventController<Event>()
        : PublishEventController<Event>();

    List<EventController<Event>> controllerList =
    _streamEventMap[key] ??= List();

    controllerList.add(eventController);

    eventController.onCancel = () {
      controllerList.remove(eventController);
    };

    return eventController;
  }

  void _notifyAll(Event event) {
    List<EventController<Event>> allEventControllers =
    _streamEventMap[_allEventsKey];

    if (allEventControllers.isEmpty) {
      return;
    }

    assert(allEventControllers.length == 1);

    allEventControllers.first.add(event);
  }

  void _notifySingle(String name, Event event) {
    List<EventController<Event>> eventList = _streamEventMap[name] ?? List();

    eventList.forEach(
            (EventController<Event> eventController) => eventController.add(event));
  }
}