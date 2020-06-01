import 'package:flutter/material.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:provider/provider.dart';
import 'package:plannusandroidversion/models/todo/todo_models/database.dart';
import 'package:plannusandroidversion/models/todo/pages/add_event_page.dart';
import 'package:plannusandroidversion/models/todo/pages/add_task_page.dart';
import 'package:plannusandroidversion/models/todo/pages/event_page.dart';
import 'package:plannusandroidversion/models/todo/pages/task_page.dart';
import 'package:plannusandroidversion/models/todo/widgets/custom_button.dart';

//void main() => runApp(ToDoApp());

class ToDoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider<TodoDatabase>(
          create: (context) => Provider.of<User>(context).toDoDatabase
      )],
      child: MyHomePage()
    );
//    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PageController _pageController = PageController();

  double currentPage = 0;

  User user;

  @override
  Widget build(BuildContext context) {
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page;
      });
    });
    //test
    user = Provider.of<User>(context);
    //testend
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 35,
            color: Theme.of(context).accentColor,
          ),
          Positioned(
            right: 0,
            child: Text(
              DateTime.now().day.toString(),
              style: TextStyle(fontSize: 200, color: Color(0x10000000)),
            ),
          ),
          _mainContent(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                    child: currentPage == 0 ? AddTaskPage() : AddEventPage(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))));
              });
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _mainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 60),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            convertDay(DateTime.now().weekday),
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: _button(context),
        ),
        Expanded(
            child: PageView(
              controller: _pageController,
              children: <Widget>[TaskPage(), EventPage()],
            ))
      ],
    );
  }

  Widget _button(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
            child: CustomButton(
              onPressed: () {
                _pageController.previousPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.bounceInOut);
              },
              buttonText: "Tasks",
              color:
              currentPage < 0.5 ? Theme.of(context).accentColor : Colors.white,
              textColor:
              currentPage < 0.5 ? Colors.white : Theme.of(context).accentColor,
              borderColor: currentPage < 0.5
                  ? Colors.transparent
                  : Theme.of(context).accentColor,
            )),
        SizedBox(
          width: 32,
        ),
        Expanded(
            child: CustomButton(
              onPressed: () {
                _pageController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.bounceInOut);
              },
              buttonText: "Events",
              color:
              currentPage > 0.5 ? Theme.of(context).accentColor : Colors.white,
              textColor:
              currentPage > 0.5 ? Colors.white : Theme.of(context).accentColor,
              borderColor: currentPage > 0.5
                  ? Colors.transparent
                  : Theme.of(context).accentColor,
            ))
      ],
    );
  }

  String convertDay(int weekDay) {
    switch(weekDay) {
      case 1 : return "Monday"; break;
      case 2 : return "Tuesday"; break;
      case 3 : return "Wednesday"; break;
      case 4 : return "Thursday"; break;
      case 5 : return "Friday"; break;
      case 6 : return "Saturday"; break;
      case 7 : return "Sunday"; break;
      default: return ""; break;
    }
  }
}