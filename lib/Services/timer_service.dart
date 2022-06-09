import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Models/models.dart';
import 'package:lcn/Providers/dio_provider.dart';
import 'package:xml/xml.dart';
import 'package:html/parser.dart' as html;

/// Vorhandene Services
/// setTimerEnabled Zeitschaltuhr Ein- und Ausschalten. Kein selektiertes Schalten einzelner Uhren
/// isTimerEnabled Abfrage on die Zeitschaltuhren ein- oder ausgeschaltet sind
/// deleteTimer Zeitschaltuhr löschen
/// getTimerEvent Abfrage aller Zeitschaltuhren
/// setTimerOptions Verändern von Einstellungen

class TimerService extends StateNotifier<Dio> {

  TimerService(this.ref) : super(Dio());

  final Ref ref;
  final String basicUrl = "http://access.lcn.de/LCNGVSDemo/WebServices/Timer1.asmx/";
  final String basicUrlSoap = "http://access.lcn.de/LCNGVSDemo/WebServices/Timer1.asmx";
  late Event event;
  late Rule rule;

  Future<void> setTimerEnabled({required String timerEnabled}) async {
    String serviceMethod = "SetEnabled";
    Dio _dio = ref.watch(dioProvider);
    await _dio.post(
      basicUrl+serviceMethod,
      data: {'enabled': timerEnabled,},
      options: Options(headers: {'Content-Type': 'application/json', }
    )
    );
  }

  Future<bool> isTimerEnabled() async {
    String serviceMethod = "IsEnabled";
    Dio _dio = ref.watch(dioProvider);
    Response res = await _dio.post(
        basicUrl+serviceMethod,
        options: Options(headers: {'Content-Type': 'application/json', }
        )
    );
    return res.data['d'];
  }

  Future<void> deleteTimer({required String id}) async {
    String serviceMethod = "DeleteTimer";
    Dio _dio = ref.watch(dioProvider);
    Response res = await _dio.post(
        basicUrl+serviceMethod,
        data: {'id': id,},
        options: Options(headers: {'Content-Type': 'application/json', }
        )
    );
    print('--------------Delete Status---------------');
    print(res.data);
  }


  Future<List<Event>> getTimerEvents() async {
    List<Event> events = [];

    /// API GetTimerEvents
    String serviceMethod = "GetTimerEvents";
    Dio _dio = ref.watch(dioProvider);
    Response res = await _dio.post(
        basicUrl+serviceMethod,
        options: Options(headers: {'Content-Type': 'application/xml', })
    );

    print('getTimerEvents');
    print(res.data);
    ///XML Parser sortiert alles als Event Model
    final timerDocument = XmlDocument.parse(res.data);
    var children = timerDocument.rootElement.children;

    children.forEach((element) {
      if (element.attributes.isNotEmpty) {
        List times = [];
        List rules = [];
        late String name;
        late String id;
        late String enabled;
        Map<String, dynamic> rule = new Map();
        ///id and enabled
        id = element.attributes[0].value;
        enabled = element.attributes[1].value;
        ///name
        name = element.findAllElements('Description').first.text;
        print(element.findAllElements('Description').first.text);
        ///times
        element.findAllElements('Time').forEach((timeElement) {
          times.add(timeElement.attributes.first.value);
          List temp_rules = [];
          rule = {};
          ///rules
          timeElement.findAllElements('And').forEach((andElement) {
            rule['${andElement.findAllElements('Rule').first.attributes.first.value}'] = andElement.findAllElements('Rule').first.attributes;
            temp_rules.add(andElement.findAllElements('Rule').first.attributes);
            //temp_rules.addEntries(MapEntry(key, andElement.findAllElements('Rule').first.attributes));
            //temp_rules[andElement.findAllElements('Rule').first.attributes.single.]
          });
          rules.add(temp_rules);
        });
        ///model
        event = Event(
            name: name,
            id: id,
            enabled: enabled,
            times: times,
            rules: rules,
            rule: rule
        );

        events.add(event);

      }
    }
    );
    print(events[1].rules);
    return events;
  }


  Future<void> setTimerOptions({required Event customData, required String timerName}) async {
    /// liegt nur als SOAP 1.1 und 1.2 ACTION vor AddOrReplaceTimer
    print('customData------------------');
    print(customData.toMap());
    late List customUserData;

    /// Init Datastructures



    List time = [];


    final bodyTest = '''<?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
    <soap:Body>
    <AddOrReplaceTimer xmlns="http://www.lcn.de/LCNGVS/">
    <Event id="${customData.id}" enabled="${customData.enabled}">
    <Description>${timerName}</Description>
    </Event>
    </AddOrReplaceTimer>
    </soap:Body>
    </soap:Envelope>
    ''';


    /// DayOfWeek Node
    XmlNode buildRulesDayOfWeek({required String type,required String xsiType ,required String attribute_allow, required String attribute_mo, required String attribute_tu,
      required String attribute_we, required String attribute_thu, required String attribute_fr, required String attribute_sa, required String attribute_su,}) {
      final builder = new XmlBuilder();
      builder.element(type, nest: () {
        builder.attribute('xsi:type', xsiType);
        builder.attribute('allow', attribute_allow);
        builder.attribute('mo', attribute_mo);
        builder.attribute('tu', attribute_tu);
        builder.attribute('we', attribute_we);
        builder.attribute('th', attribute_thu);
        builder.attribute('fr', attribute_fr);
        builder.attribute('sa', attribute_sa);
        builder.attribute('su', attribute_su);
      });
      return builder.buildFragment();
    }

    /// Year Node
    XmlNode buildRulesYear({required String type,required String xsiType,required String attribute_allow, required String attribute_year,required String attribute_op}) {
      final builder = new XmlBuilder();
      builder.element(type, nest: () {

        builder.attribute('xsi:type', xsiType);
        builder.attribute('allow', attribute_allow);
        builder.attribute('yearNo', attribute_year);
        builder.attribute('operator', attribute_op);

      });
      return builder.buildFragment();
    }

    ///------------------------------------------------------------------------------------------///

    /// Loop to build Times Node
    int _timeValueCounter = 0;
    customData.times.forEach((timeValue) {

      List<XmlNode> rules = [];
      //if (customData.)
      /// Add XmlNodes to a List which contains a possible Rule
      rules.add(buildRulesDayOfWeek(
          type: 'Rule',
          xsiType: 'DaysOfWeek',
          attribute_allow: 'true',
          attribute_mo: customData.rules[_timeValueCounter][0][2].value,
          attribute_tu: customData.rules[_timeValueCounter][0][3].value,
          attribute_we: customData.rules[_timeValueCounter][0][4].value,
          attribute_thu: customData.rules[_timeValueCounter][0][5].value,
          attribute_fr: customData.rules[_timeValueCounter][0][6].value,
          attribute_sa: customData.rules[_timeValueCounter][0][7].value,
          attribute_su: customData.rules[_timeValueCounter][0][8].value));
      //rules.add(buildRulesDayOfWeek(type: 'Rule', xsiType: 'DaysOfWeek', attribute_allow: 'true', attribute_mo: 'true', attribute_tu: 'true', attribute_we: 'true', attribute_thu: 'true', attribute_fr: 'true', attribute_sa: 'true', attribute_su: 'true'));
      rules.add(buildRulesYear(
          type: 'Rule',
          xsiType: 'Year',
          attribute_allow: 'true',
          attribute_year: customData.rules[_timeValueCounter][1][2].value,
          attribute_op: customData.rules[_timeValueCounter][1][3].value));

      /// And Node
      XmlNode buildAnd({required String type}) {
        final builder = new XmlBuilder();
        builder.element(type, nest: () {
        });
        return builder.buildFragment();
      }
      XmlNode xmlAnd = buildAnd(type: 'And');

      /// Rule Node
      XmlNode buildRule({required String type, required String xsiType, required String allowState}) {
        final builder = new XmlBuilder();
        builder.element(type, nest: () {
          builder.attribute('xsi:type', xsiType);
          builder.attribute('allow', allowState);
        });
        return builder.buildFragment();
      }
      XmlNode xmlRule = buildRule(type: 'Rule', xsiType: 'AllRule', allowState: 'true');
      int index = 0;
      XmlNode userNode = xmlAnd;
      rules.forEach((element) {
        userNode.findAllElements('And').elementAt(0).children.add(element);
        xmlRule.findAllElements('Rule').elementAt(index).children.add(userNode);
        userNode.findAllElements('And').first.children.removeAt(0);
        index = index + 1;
      });

      /// Description Node
      XmlNode buildDescription({required String type}) {
        final builder = new XmlBuilder();
        builder.element(type, nest: () {
        });
        return builder.buildFragment();
      }
      XmlNode xmlDescription = buildDescription(type: 'Description');


      /// Time Node
      XmlNode buildTime({required String type, required String time}) {
        final builder = new XmlBuilder();
        builder.element(type, nest: () {
          builder.attribute('time', time);
        });
        return builder.buildFragment();
      }
      XmlNode xmlTime = buildTime(type: 'Time', time: timeValue);
      xmlTime.findAllElements('Time').first.children.add(xmlDescription);
      xmlTime.findAllElements('Time').first.children.add(xmlRule);


      /// List of Time Documents
      time.add(xmlTime);
      _timeValueCounter += 1;
    });







    /// Times Node
    XmlNode buildTimes({required String type}) {
      final builder = new XmlBuilder();
      builder.element(type, nest: () {

      });
      return builder.buildFragment();
    }
    XmlNode xmlTimes = buildTimes(type: 'Times');
    time.forEach((element) {
      xmlTimes.findAllElements('Times').first.children.add(element);
    });



    XmlNode buildAction({required String type}) {
      final builder = new XmlBuilder();
      builder.element(type, nest: () {
      });
      return builder.buildFragment();
    }


    /// Action Node
    XmlNode xmlAction = buildAction(type: 'Action');

    /// Event Node
    final document = XmlDocument.parse(bodyTest);
    var soap = document.findAllElements('Event');
    soap.first.children.add(xmlTimes);
    soap.first.children.add(xmlAction);
    print('[SOAP VALUE]');
    print(soap.first.parent!.parent!.parent!.parent);
    /// Request

    Dio _dio = ref.watch(dioProvider);
    late Response res;
    try {
      res = await _dio.post(
          basicUrlSoap,
          options: Options(
            headers: {'Content-Type': 'text/xml',
              'SOAPAction': "http://www.lcn.de/LCNGVS/AddOrReplaceTimer"
            },
          ),
          data: soap.first.parent!.parent!.parent!.parent
      );
      print(res.statusCode);
    } catch(e) {
      print(e);
    }



    ///
    print('-------------------------------res---------------------');
    print(res.data);
    //return res;
  }
}