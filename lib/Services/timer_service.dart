import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/Providers/dio_provider.dart';
import 'package:xml/xml.dart';
import 'package:html/parser.dart' as html;

class TimerService extends StateNotifier<Dio> {

  TimerService(this.ref) : super(Dio());

  final Ref ref;
  final String basicUrl = "http://access.lcn.de/LCNGVSDemo/WebServices/Timer1.asmx/";

  Future<List> getTimerEvents() async {
    List<XmlNode> events = [];
    List eventAttributes = [];
    String serviceMethod = "GetTimerEvents";
    Dio _dio = ref.watch(dioProvider);
    Response res = await _dio.post(
        basicUrl+serviceMethod,
        options: Options(headers: {'Content-Type': 'application/xml', })
    );

    final timerDocument = XmlDocument.parse(res.data);
    var children = timerDocument.rootElement.children;
    children.forEach((element) {
      if (element.attributes.isNotEmpty) {
        events.add(element);
      }
    }
    );

    print(events);

    events.forEach((element) {
      eventAttributes.add(element.attributes);
    });

    print(eventAttributes);
    print(children[1].findAllElements('Time').first.attributes);
    var timeAttributes = children[1].findAllElements('Time').first.attributes;
    print(children[1].findAllElements('Time').first.children[3].children[1].findAllElements('Rule').first.attributes[0].value);
    var ruleName = children[1].findAllElements('Time').first.children[3].children[1].findAllElements('Rule').first.attributes[0].value;
    //Map resMap = res.data;

    //print(resMap['d']['Items']);
    //return resMap['d']['Items'];

    return [];
  }


  Future<Response> setTimerOptions({required Map customData,required String currentUri, required String eventId, required bool enabled, required String eventName, required String time}) async {
    /// liegt nur als SOAP 1.1 und 1.2 ACTION vor AddOrReplaceTimer
    //String serviceMethod = "SetUserCustomData";
    //print('${basicUrl+'/'+serviceMethod}');
    print(customData);
    print(currentUri);
    List quickTableauUri = [];
    List recentTableauUri = [];
    List lastTableauUri = [];
    List customDataStrings = customData['Strings'];
    late List customUserData;
    List hiveList = [];
    List Rules = [];
    //var box = await Hive.openBox('currentUserDataBox');




    final body = '''<?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
    <soap:Body>
    <SetUserCustomData xmlns="http://www.lcn.de/LCNGVS/">
    <customData fetchFromParent="false">
    <Strings>
    </Strings>
    <Integers>
    </Integers>
    <Booleans>
    </Booleans>
    </customData>
    </SetUserCustomData>
    </soap:Body>
    </soap:Envelope>
    ''';

    final bodyTest = '''<?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
    <soap:Body>
    <AddOrReplaceTimer xmlns="http://www.lcn.de/LCNGVS/">
    <Event id=$eventId enabled='$enabled'>
    <Description>$eventName</Description>
    <Times>
    <Time time=$time>
    <Description>
    </Description>
    </Time>
    </Times>
    <Action>
    </Action>
    </Event>
    </AddOrReplaceTimer>
    </soap:Body>
    </soap:Envelope>
    ''';


    XmlNode buildParagraphXML({required String type,required String attribute,required String value}) {
      final builder = new XmlBuilder();
      builder.element(type, nest: () {
        builder.attribute('name', attribute);
        builder.text(value);
      });
      return builder.buildFragment();
    }


    /// Hier mit Schleife über alle Möglichkeiten von Rules
    XmlNode buildRulesXML({required String type,required String attribute,required String value}) {
      final builder = new XmlBuilder();
      builder.element(type, nest: () {
        builder.attribute('name', attribute);
        builder.text(value);
      });
      return builder.buildFragment();
    }


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
    
    print(buildRulesDayOfWeek(type: 'Rule', xsiType: 'DaysOfWeek', attribute_allow: 'true', attribute_mo: 'true', attribute_tu: 'true', attribute_we: 'true', attribute_thu: 'true', attribute_fr: 'true', attribute_sa: 'true', attribute_su: 'true'));


    print(customData['Strings']);
    lastTableauUri.add(buildParagraphXML(type: 'String', attribute: 'LastTableauUri', value: currentUri));
    recentTableauUri.add(buildParagraphXML(type: 'String', attribute: 'RecentTableauUri', value: currentUri));
    hiveList.add({'Name': 'RecentTableauUri', 'Value': currentUri});


    customDataStrings.forEach((element) {
      if (element['Name'] == 'RecentTableauUri' && element['Value'] != currentUri) {
        recentTableauUri.add(buildParagraphXML(type: 'String', attribute: 'RecentTableauUri', value: element['Value']));
        hiveList.add(element);
      }
    });
    hiveList.add({'Name': 'LastTableauUri', 'Value': currentUri});
    print(recentTableauUri);
    //box.put('currentUserData', hiveList);
    customUserData = recentTableauUri + lastTableauUri;




    //var value = RegExp(r"Musterhaus\Schnelltableau");
    //var jhf = buildParagraphXML(type: 'String', attribute: 'LastTableauUri', value: value.pattern);
    //print(jhf);
    //print(jhf.nodeType);
    final document1 = XmlDocument.parse(bodyTest);
    //document1.children.add(jhf);
    var te = document1.findAllElements('Time');
    if (te.first.getAttribute('time') == time) {
      customUserData.forEach((element) {
        te.first.children.add(element);
      });
    }


    //print('Hive-------------------Hive');
    //print(box.get('currentUserData'));

    //print('doc----------------doc');
    //print(document1);
    Dio _dio = ref.watch(dioProvider);

    Response res = await _dio.post(
        basicUrl,
        options: Options(
          headers: {'Content-Type': 'text/xml; charset=utf-8',
            'SOAPAction': "http://www.lcn.de/LCNGVS/SetUserCustomData"
          },
        ),
        data: document1
    );
    //ref.read(customTableauListProvider.state).update((state) => hiveList);

    //print('-----------------------usersdata');
    //var document = html.parse(res.data);
    //print(res);
    //print(document.body!.getElementsByTagName('content'));
    return res;
  }
}