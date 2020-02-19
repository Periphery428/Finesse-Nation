
import 'package:test/test.dart';
import 'package:finesse_nation/finesse.dart';
import 'package:finesse_nation/fetchFinesses.dart';

void main(){
  test('Getting a List of finesses', () {
    Finesse fin = Finesse("testTitle", "testBody", null, null, "testDuration");
    List<Finesse> _finesses = fetchFinesses();
    Finesse gotten = _finesses.removeLast();
    expect(fin.getTitle(), gotten.getTitle());
    expect(fin.getBody(), gotten.getBody());
    expect(fin.getDuration(), gotten.getDuration());
  });
}