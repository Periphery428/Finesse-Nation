
import 'package:finesse_nation/finesseList.dart';
import 'package:test/test.dart';
import 'package:finesse_nation/finesse.dart';
import 'package:finesse_nation/Notifications.dart';


void main(){
  test('Sending and getting notification', () {
    Finesse fin = Finesse("testTitle", "testBody", null, null, "testDuration");
    FinesseList.addFinesse(fin);
    List<dynamic> log = Notifications.getLog();
    expect(log.removeLast().getFinesse().getBody(), "testBody");
    expect(log.removeLast().getFinesse().getTitle(), "testTitle");
    expect(log.removeLast().getFinesse().getDuration(), "testDuration");
  });
}

