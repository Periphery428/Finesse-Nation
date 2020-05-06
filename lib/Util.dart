/// Utility functions used by multiple files.
class Util {
  /// Returns a string containing a more readable/practical
  /// representation of [timePosted] based on the current time.
  ///
  /// ```dart
  /// DateTime today = DateTime.now();
  /// DateTime fiftyDaysAgo = today.subtract(Duration(days: 50));
  /// timeSince(fiftyDaysAgo) == '50 days ago'
  /// ```
  static String timeSince(DateTime timePosted) {
    DateTime currTime = DateTime.now();
    Duration difference = currTime.difference(timePosted);
    int seconds = difference.inSeconds;
    int minutes = difference.inMinutes;
    int hours = difference.inHours;
    int days = difference.inDays;

    if (days < 1) {
      if (hours < 1) {
        if (minutes < 1) {
          if (seconds < 0) {
            return "now";
          } else {
            return "now";
          }
        } else {
          if (minutes == 1) {
            return minutes.toString() + " minute ago";
          } else {
            return minutes.toString() + " minutes ago";
          }
        }
      } else {
        if (hours == 1) {
          return hours.toString() + " hour ago";
        } else {
          return hours.toString() + " hours ago";
        }
      }
    } else {
      if (days == 1) {
        return days.toString() + " day ago";
      } else {
        return days.toString() + " days ago";
      }
    }
  }
}
