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
      final flushBar = find.byValueKey('flushbar');

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

      test("login failures", () async {
        await driver.runUnsynchronized(() async {
          await driver.waitFor(find.byValueKey('sign in page'));
          await driver.tap(emailField);
          await driver.enterText("test@gmail.com");
          await driver.tap(passwordField);
          await driver.enterText('1111111');
          await driver.tap(signInButton);
         //await Future.delayed(Duration(seconds: 4));
          await driver.waitFor(find.byValueKey('failed login'));
//          await driver.runUnsynchronized(() async {
//            await driver.waitFor(flushBar);
//          });
          //await driver.waitFor(find.("FAILED TO SIGN IN!"));
          await driver.waitUntilNoTransientCallbacks();
//          assert (flushBar != null);
          assert (homePage == null);
        });
      });

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
          await driver.waitUntilNoTransientCallbacks();
        });
      });
    });
}