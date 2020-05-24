class ScheduleTiming {
  int start;
  int end;
  ScheduleTiming(int start) {
    this.start = start;
    this.end = start + 100;
  }

  static List<ScheduleTiming> allSlots = ScheduleTime.startTimeList
        .map((startTime) => ScheduleTiming(startTime.time)).toList();

  @override
  String toString() {
    String s = start < 1000 ? "0${start.toString()}" : start.toString();
    String e = end < 1000 ? "0${end.toString()}" : end.toString();
    return s + '-' + e;
  }
}

class ScheduleTime {
  final int time;
  ScheduleTime({this.time});

  @override
  String toString() {
    return time < 1000
        ? "0" + time.toString()
        : time.toString();
  }

  static List<ScheduleTime> startTimeList = <ScheduleTime> [
    ScheduleTime(time: 0800), ScheduleTime(time: 0900), ScheduleTime(time: 1000), ScheduleTime(time: 1100),
    ScheduleTime(time: 1200), ScheduleTime(time: 1300), ScheduleTime(time: 1400), ScheduleTime(time: 1500),
    ScheduleTime(time: 1600), ScheduleTime(time: 1700), ScheduleTime(time: 1800), ScheduleTime(time: 1900),
  ];

  static List<ScheduleTime> endTimeList = <ScheduleTime> [
    ScheduleTime(time: 0900), ScheduleTime(time: 1000), ScheduleTime(time: 1100), ScheduleTime(time: 1200),
    ScheduleTime(time: 1300), ScheduleTime(time: 1400), ScheduleTime(time: 1500), ScheduleTime(time: 1600),
    ScheduleTime(time: 1700), ScheduleTime(time: 1800), ScheduleTime(time: 1900), ScheduleTime(time: 2000),
  ];
}