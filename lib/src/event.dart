import 'package:meta/meta.dart';

/// This is the base class for each event.
/// You can only send subclasses of this [Event] through the [EventTaxi]
///
///
/// Example:
///   class OnUserCreatedEvent implements Event{
///
///     OnUserCreatedEvent();
///   }
///
@immutable
abstract class Event {}
