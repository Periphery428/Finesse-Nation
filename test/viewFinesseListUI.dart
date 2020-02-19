import 'package:finesse_nation/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  testWidgets('Viewing a Finesse UI test',
          (WidgetTester tester) async{
        await tester.pumpWidget(MyApp());
        await tester.tap(find.byKey(Key('Add Event')));
        await tester.enterText(find.byKey(Key('Title')), 'testTitle');
        await tester.enterText(find.byKey(Key('Body')), 'testBody');
        await tester.enterText(find.byKey(Key('Duration')), 'duration');
        await tester.tap(find.byKey(Key('submit')));

        expect(find.text('testTitle'), findsOneWidget);
        expect(find.text('testBody'), findsOneWidget);
        expect(find.text('testBody'), findsOneWidget);
      });
}