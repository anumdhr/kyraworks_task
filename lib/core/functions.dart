import 'package:timeago/timeago.dart' as timeago;

String formatTime(DateTime time) {
  final now = DateTime.now();
  final diff = now.difference(time);
  if (diff.inDays > 7) {
    return '${time.day}/${time.month}';
  }
  return timeago.format(time, allowFromNow: true);
}
