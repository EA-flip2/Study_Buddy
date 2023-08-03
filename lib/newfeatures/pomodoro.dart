import 'dart:async';

void main() {
  const int pomodoroDuration = 25; // 25 minutes for work
  const int shortBreakDuration = 5; // 5 minutes for a short break
  const int longBreakDuration = 15; // 15 minutes for a long break
  const int pomodoroCycle = 4; // Number of pomodoros in one cycle

  Timer? timer;

  void startTimer(int minutes) {
    int seconds = minutes * 60;
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      seconds--;
      if (seconds <= 0) {
        t.cancel();
        print('Time\'s up!');
      } else {
        int minutesRemaining = seconds ~/ 60;
        int secondsRemaining = seconds % 60;
        print('$minutesRemaining:${secondsRemaining.toString().padLeft(2, '0')}');
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  void pomodoroCycleTimer() {
    for (int i = 0; i < pomodoroCycle; i++) {
      print('Pomodoro ${i + 1}');
      startTimer(pomodoroDuration);
      if (i < pomodoroCycle - 1) {
        print('Take a short break!');
        startTimer(shortBreakDuration);
      } else {
        print('Take a long break!');
        startTimer(longBreakDuration);
      }
    }
  }

  pomodoroCycleTimer();
}
