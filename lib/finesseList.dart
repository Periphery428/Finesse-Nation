import 'package:finesse_nation/finesse.dart';

class FinesseList {
  List finesseList;

  addFinesse(Finesse finesse) {
    finesseList.add(finesse);
  }

  getFinesses() {
    return this.finesseList;
  }
}
