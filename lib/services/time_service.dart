class TimeService {
  static String displayHour(int hour, int _min) {
    var minute = _min.toString();
    if (int.parse(minute) < 10) {
      minute = "0${minute.toString()}";
    }
    if (hour > 12 && hour != 0) {
      return "${(hour - 12)}:${minute}pm";
    } else if (hour == 0) {
      return "12:${minute}am";
    } else {
      return "${(hour)}:${minute}pm";
    }
  }
}