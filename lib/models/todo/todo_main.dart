import 'package:flutter/material.dart';
import 'package:plannusandroidversion/models/user.dart';
import 'package:provider/provider.dart';
import 'package:plannusandroidversion/models/todo/todo_models/todo_data.dart';
import 'package:plannusandroidversion/models/todo/pages/add_event_page.dart';
import 'package:plannusandroidversion/models/todo/pages/add_task_page.dart';
import 'package:plannusandroidversion/models/todo/pages/event_page.dart';
import 'package:plannusandroidversion/models/todo/pages/task_page.dart';
import 'package:plannusandroidversion/models/todo/widgets/custom_button.dart';


class ToDoPage extends StatefulWidget {
  @override
  _ToDoPageState createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  PageController _pageController = PageController();

  double currentPage = 0;

  TodoData todoData;
  User user;


  Widget addPage() {
    return Dialog(
        child: currentPage == 0
            ? MultiProvider(
                providers: [
                  Provider<TodoData>.value(value: todoData),
                  Provider<User>.value(value: user)
                ],
                child: Provider<User>.value(value: user, child: AddTaskPage())
              )
            : Provider<TodoData>.value(value: todoData, child: AddEventPage()),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))));
  }

  @override
  Widget build(BuildContext context) {
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page;
      });
    });
    todoData = Provider.of<TodoData>(context, listen: true);
    user = Provider.of<User>(context, listen: false);
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned(
              top: -30,
              right: 0,
              child: Text(
                DateTime.now().day.toString(),
                style: TextStyle(fontSize: 200, color: Color(0x10000000)),
              ),
            ),
            _mainContent(context),
          ],
        ),
        floatingActionButton: currentPage == 0
            ? FloatingActionButton(
          onPressed: () {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                      child: currentPage == 0
                          ? Provider<TodoData>.value(value: todoData, child: AddTaskPage())
                          : Provider<TodoData>.value(value: todoData, child: AddEventPage()),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))));
                });
          },
          child: Icon(Icons.add, key: Key('Add task'),),
        ) : null,
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
              children: <Widget>[
                TaskPage(),
                EventPage()
              ],
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
