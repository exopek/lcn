class Event {
  Event({required this.name, required this.id, required this.enabled, required this.times, required this.rules});

  final String name;
  final String id;
  final String enabled;
  final List times;
  final List rules;

  factory Event.fromMap(Map<String, dynamic> data) {

    final String name = data['name'];
    final String id = data['id'];
    final String enabled = data['enabled'];
    final List times = data['times'];
    final List rules = data['rules'];

    return Event(
        name: name,
        id: id,
        enabled: enabled,
        times: times,
        rules: rules
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'enabled': enabled,
      'times': times,
      'rules': rules
    };
  }

}


class Events {
  Events({required this.events});

  final List<Event> events;

  factory Events.fromMap(Map<String, dynamic> data) {

    final List<Event> events = data['events'];

    return Events(
        events: events,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'events': events,
    };
  }

}