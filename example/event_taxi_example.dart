import 'package:event_taxi/event_taxi.dart';
import 'package:event_taxi/src/event.dart';

class TodoCreated implements Event {
  final String name;
  final String description;

  TodoCreated({required this.name, required this.description});
}

class UserLoggedIn implements Event {
  final String username;

  UserLoggedIn({required this.username});
}

main() {
  EventTaxi eventBus = EventTaxiImpl();

  eventBus.registerTo<TodoCreated>().listen((event) {
    // handle event
    print("to created: name=${event.name}, description=${event.description}");
  });

  eventBus.fire(TodoCreated(
      name: "create example",
      description: "add example for this cool libary called EventTaxi 🚕."));

  // additionally you can also register and immediately receive the previous event
  eventBus.fire((UserLoggedIn(username: "Stefan")));

  eventBus.registerTo<UserLoggedIn>(true).listen((event) {
    // prints "Stefan" and then "Tobi"
    print(event.username);
  });

  eventBus.fire(UserLoggedIn(username: "Tobi"));
}
