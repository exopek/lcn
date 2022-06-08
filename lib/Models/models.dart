class Event {
  Event({required this.name, required this.id, required this.enabled, required this.times, required this.rules, required this.rule});

  final String name;
  final String id;
  final String enabled;
  final List times;
  final List rules;
  final Map rule;

  factory Event.fromMap(Map<String, dynamic> data) {

    final String name = data['name'];
    final String id = data['id'];
    final String enabled = data['enabled'].toString();
    final List times = data['times'];
    final List rules = data['rules'];
    final Map rule = data['rule'];

    return Event(
        name: name,
        id: id,
        enabled: enabled,
        times: times,
        rules: rules,
        rule: rule
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'enabled': enabled,
      'times': times,
      'rules': rules,
      'rule': rule
    };
  }

}

class Rule {
  Rule({required this.rule});

  final Map<String, dynamic> rule;

  factory Rule.fromMap(Map<String, dynamic> data) {

    final Map<String, dynamic> rule = data['rule'];

    return Rule(
      rule: rule,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rule': rule,
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