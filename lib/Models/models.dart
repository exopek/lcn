class Event {
  Event({required this.name, required this.id, required this.enabled, required this.times, required this.rules, required this.rule});

  final String name;
  final String id;
  final String enabled;
  final List times;
  final List<Map<String,Map<String,dynamic>>> rules;
  final Map rule;

  factory Event.fromMap(Map<String, dynamic> data) {

    final String name = data['name'];
    final String id = data['id'];
    final String enabled = data['enabled'].toString();
    final List times = data['times'];
    final List<Map<String,Map<String,dynamic>>> rules = data['rules'];
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


class Macro {
  Macro({required this.eventId, required this.authUsage, required this.hasChanged, required this.name, required this.description, required this.auth, required this.actions});

  final String eventId;
  final bool authUsage;
  final bool hasChanged;
  final String name;
  final String description;
  final List auth;
  final List actions;

  factory Macro.fromMap(Map<String, dynamic> data) {

    final String eventId = data['EventId'];
    final bool authUsage = data['AuthorizationUsage'];
    final bool hasChanged = data['HasChanged'];
    final String name = data['Name'];
    final String description = data['Description'];
    final List auth = data['AuthorizationList'];
    final List actions = data['ActionList'];

    return Macro(
      eventId: eventId,
      authUsage: authUsage,
      hasChanged: hasChanged,
      name: name,
      description: description,
      auth: auth,
      actions: actions
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventId': eventId,
      'authUsage': authUsage,
      'hasChanged': hasChanged,
      'name': name,
      'description': description,
      'auth': auth,
      'actions': actions
    };
  }

}

/*
class Macros {
  Macros(this.macro, this.authUsage, this.hasChanged, this.name, this.description);


  factory Macros.fromMap(Map<String, dynamic> data) {

    final List<Event> macros = data['macros'];

    return Macros(
      macros: macros,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'macros': macros,
    };
  }

}
*/