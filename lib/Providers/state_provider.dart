import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lcn/State_Services/tableau_state_service.dart';

final customTableauListProvider = StateProvider<List>((ref) {
  return TableauStateService().updateTableauList();
});