import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('timetable tests', (){
    FlutterDriver driver;
    
    // assuming we are logged in already and at home page

    test("timetable assign", () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(find.byValueKey('Timetable-form'));
        await Future.delayed(Duration(seconds: 3));
        await driver.tap(find.byValueKey("Add timetable"));
        await Future.delayed(Duration(seconds: 1));
        await driver.tap(find.byValueKey("Activity"));
        await driver.enterText("Tests");
        await driver.tap(find.byValueKey("Start"));
        await Future.delayed(Duration(seconds: 1));
        await driver.tap(find.text('08:00'));
        await Future.delayed(Duration(seconds: 1));
        await driver.tap(find.byValueKey("End"));
        await driver.tap(find.text('09:00'));
        await Future.delayed(Duration(seconds: 1));
        await driver.tap(find.text("Add"));
      });
    });
    
    test("timetable cancel", () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(find.byValueKey('Timetable-form'));
        await Future.delayed(Duration(seconds: 3));
        await driver.tap(find.byValueKey("Add timetable"));
        await Future.delayed(Duration(seconds: 1));
        await driver.tap(find.text("Cancel"));
        await Future.delayed(Duration(seconds: 1));
        await driver.tap(find.text("logout"));
        await driver.waitUntilNoTransientCallbacks();
      });
    });
    
    
  });
}