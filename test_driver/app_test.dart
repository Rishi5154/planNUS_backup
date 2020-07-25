import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
//  MockFireBaseAuth _auth = MockFireBaseAuth();
//  BehaviorSubject<MockFireBaseUser> _user = BehaviorSubject<MockFireBaseUser>();
//  AuthService authService =  AuthService.
    group('login test', (){
      SerializableFinder emailField = find.byValueKey('Email-form key');
      final passwordField = find.byValueKey('Password-form key');
      final signInButton = find.text('Login');
      final homePage = find.byValueKey('Home');
//      final flushBar = find.byValueKey('flushbar');

      FlutterDriver driver;

      setUpAll(() async {
        driver = await FlutterDriver.connect();
      });

      test('check flutter driver health', () async {
        Health health = await driver.checkHealth();
        print(health.status);
      });

      tearDownAll(() async {
        if (driver != null) {
          driver.close();
        }
      });

//      test("login failures", () async {
//        await driver.runUnsynchronized(() async {
//          await driver.waitFor(find.byValueKey('sign in page'));
//          await driver.tap(emailField);
//          await driver.enterText("test@gmail.com");
//          await driver.tap(passwordField);
//          await driver.enterText('1111111');
//          await driver.tap(signInButton);
//          await Future.delayed(Duration(seconds: 3));
////          await driver.runUnsynchronized(() async {
////            await driver.waitFor(flushBar);
////          });
//          //await driver.waitFor(find.("FAILED TO SIGN IN!"));
//          await driver.waitUntilNoTransientCallbacks();
////          assert (flushBar != null);
//          assert (homePage == null);
//        });
//      });
//
      test("login successes", () async {
        await driver.runUnsynchronized(() async {
          await driver.waitFor(find.byValueKey('sign in page'));
          await driver.tap(emailField);
          await driver.enterText("test@gmail.com");
          await driver.tap(passwordField);
          await driver.enterText('123456');
          await driver.tap(signInButton);
          await driver.waitFor(homePage);
          assert(homePage != null);
        });
      });

    test("todo add", () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(find.byValueKey('Add task'));
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(find.byValueKey('Task name'));
        await driver.enterText("Testing task");
        await Future.delayed(Duration(seconds: 1));
        await driver.tap(find.text("Save"));
        await Future.delayed(Duration(seconds: 1));
        await driver.tap(find.text("Testing task"));
        await Future.delayed(Duration(seconds: 1));
        await driver.tap(find.text("Complete"));
      });
    });

    test("todo delete and cancel", () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(find.byValueKey('Add task'));
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(find.text("Close"));
        await Future.delayed(Duration(seconds: 1));
        await driver.scroll(find.text('Testing task'),0,0, Duration(seconds: 2));
        await Future.delayed(Duration(seconds: 2));
        await driver.tap(find.text("Delete"));
      });
    });

    test("timetable successes", () async {
      await driver.runUnsynchronized(() async {
//        await driver.waitFor(find.byValueKey('sign in page'));
//        await driver.tap(emailField);
//        await driver.enterText("test@gmail.com");
//        await driver.tap(passwordField);
//        await driver.enterText('123456');
//        await driver.tap(signInButton);
//        await driver.waitFor(homePage);
//        assert(homePage != null);
//        await Future.delayed(Duration(seconds: 5));
        await driver.tap(find.byValueKey('Timetable-form'));
        await Future.delayed(Duration(seconds: 3));
        await driver.tap(find.byValueKey("Add timetable"));
        await Future.delayed(Duration(seconds: 1));
        await driver.tap(find.text("Cancel"));
        await Future.delayed(Duration(seconds: 1));
      });
    });



      test("timetable assign", () async {
        await driver.runUnsynchronized(() async {
          await driver.tap(find.byValueKey('Timetable-form'));
          await Future.delayed(Duration(seconds: 2));
          await driver.tap(find.byValueKey("Add timetable"));
          await Future.delayed(Duration(seconds: 2));
          await driver.tap(find.byValueKey("Activity"));
          await driver.enterText("Tests");
          await driver.tap(find.byValueKey("Start"));
          await driver.tap(find.text('08:00'));
          await driver.tap(find.byValueKey("End"));
          await driver.tap(find.text('09:00'));
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
//          await driver.tap(find.text("logout"));
        });
      });

      test("timetable delete", () async {
        await driver.runUnsynchronized(() async {
          await driver.scroll(find.text('Tests'),0,0, Duration(seconds: 2));
          await Future.delayed(Duration(seconds: 2));
          await driver.tap(find.text("Delete"));
          await Future.delayed(Duration(seconds: 1));
        });
      });

      test("profile name change", () async {
        await driver.runUnsynchronized(() async {
          await driver.tap(find.byValueKey('Profile-form'));
          await Future.delayed(Duration(seconds: 2));
          await driver.tap(find.byValueKey("Name-field"));
          await driver.enterText("@testy");
          await driver.tap(find.text('Update'));
          await Future.delayed(Duration(seconds: 5));
          await driver.tap(find.byValueKey("Name-field"));
          await driver.enterText("@test");
          await Future.delayed(Duration(seconds: 2));
        });
      });
});
}