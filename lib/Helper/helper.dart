import 'package:xml/xml.dart';
import 'package:uuid/uuid.dart';

class Helper {

  /// Erzeugen von XmlNodes
  /// DayOfWeek Node
  List buildRulesDayOfWeek({required String type,required String xsiType ,required String attribute_allow, required String attribute_mo, required String attribute_tu,
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
    return builder.buildDocument().lastElementChild!.attributes;
  }


  /// Year Node
  List buildRulesYear({required String type,required String xsiType,required String attribute_allow, required String attribute_year,required String attribute_op}) {
    final builder = new XmlBuilder();
    builder.element(type, nest: () {

      builder.attribute('xsi:type', xsiType);
      builder.attribute('allow', attribute_allow);
      builder.attribute('yearNo', attribute_year);
      builder.attribute('operator', attribute_op);

    });
    return builder.buildDocument().lastElementChild!.attributes;
  }

  String guid() {
    return Uuid().v4();
  }


}