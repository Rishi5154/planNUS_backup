import 'schedule_time.dart';

class DaySchedule {
  static final List<ScheduleTiming> allTimings = ScheduleTiming.allSlots;

  Map<String, Map<String, Object>> scheduler;

  DaySchedule(Map<String, Map<String, Object>> customScheduler) {
    this.scheduler = customScheduler;
  }

  static Map<String, Map<String, Object>> emptySchedule = {
    '0800-0900' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
    '0900-1000' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
    '1000-1100' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
    '1100-1200' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
    '1200-1300' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
    '1300-1400' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
    '1400-1500' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
    '1500-1600' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
    '1600-1700' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
    '1700-1800' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
    '1800-1900' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
    '1900-2000' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
  };

  static DaySchedule noSchedule() {
    return new DaySchedule({
      '0800-0900' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
      '0900-1000' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
      '1000-1100' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
      '1100-1200' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
      '1200-1300' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
      '1300-1400' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
      '1400-1500' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
      '1500-1600' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
      '1600-1700' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
      '1700-1800' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
      '1800-1900' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
      '1900-2000' : {'name' : 'No Activity', 'isImportant' : false, 'isFinish' : false},
    });
  }

//  Widget dsWidget() {
//    return DayScheduleWidget(ds: this);
//  }
}

//class DayScheduleWidget extends StatefulWidget {
//  final DaySchedule ds;
//  DayScheduleWidget({this.ds});
//
//  @override
//  DayScheduleWidgetState createState() {
//    return DayScheduleWidgetState();
//  }
//}
//
//class DayScheduleWidgetState extends State<DayScheduleWidget> {
//  DaySchedule ds;
//
//  int hex(int startTime) {
//      switch (startTime) {
//        case 800: return 0; break;
//        case 900: return 1; break;
//        case 1000: return 2; break;
//        case 1100: return 3; break;
//        case 1200: return 4; break;
//        case 1300: return 5; break;
//        case 1400: return 6; break;
//        case 1500: return 7; break;
//        case 1600: return 8; break;
//        case 1700: return 9; break;
//        case 1800: return 10; break;
//        case 1900: return 11; break;
//        default: return 0;
//      }
//  }
//
//  void alter(String bName, int bStart, int bEnd, bool isImportant) {
//    int s = bStart;
//    int e = bEnd;
//    while (s < e) {
//      ScheduleTiming t = ScheduleTiming(s);
//      ds.scheduler[t.toString()]['name'] = (bName);
//      if (isImportant) { ds.scheduler[t.toString()]['isImportant'] = true; }
//      else { ds.scheduler[t.toString()]['isImportant'] = false; }
//      s += 100;
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    ds = widget.ds;
//    return Scaffold(
//      body: ListView(
//        children: ds.scheduler.values.map((s) => Activity(s).dailyActivityTemplate()).toList(),
//      )
//    );
//  }
//}