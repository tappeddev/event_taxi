import 'dart:async';

/// The [Interface] for the [EventController] implementations
/// There are two different implementations.
///
/// First one:
///   [PublishEventController]
///
/// Second one:
///   [BehaviourEventController]
///
abstract class EventController<T> {
  Stream<T> get stream;

  set onCancel(void Function() onCancelHandler);

  void add(T data);

  void close();
}

class PublishEventController<T> implements EventController<T> {
  final StreamController<T> _controller = StreamController();

  @override
  void set onCancel(void Function() onCancelHandler) {
    _controller.onCancel = onCancelHandler;
  }

  @override
  Stream<T> get stream => _controller.stream.asBroadcastStream();

  @override
  void add(T data) {
    _controller.add(data);
  }

  @override
  void close() {
    _controller.close();
  }
}

class BehaviourEventController<T> implements EventController<T> {
  late final StreamController<T> _controller;
  T? _lastEvent;

  BehaviourEventController({T? lastEvent}) {
    _controller = StreamController(onListen: _onListen);
    _lastEvent = lastEvent;
  }

  @override
  Stream<T> get stream => _controller.stream.asBroadcastStream();

  @override
  set onCancel(void Function() onCancelHandler) {
    _controller.onCancel = onCancelHandler;
  }

  @override
  void add(T data) {
    _lastEvent = data;
    _controller.add(data);
  }

  @override
  void close() {
    _controller.close();
  }

  void _onListen() {
    if (_lastEvent != null) {
      _controller.add(_lastEvent!);
    }
  }
}
