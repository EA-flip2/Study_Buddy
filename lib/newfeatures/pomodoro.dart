import 'dart:html';
import 'dart:async';

void main() {
  const int pomodoroDuration = 25; // 25 minutes for work
  const int shortBreakDuration = 5; // 5 minutes for a short break
  const int longBreakDuration = 15; // 15 minutes for a long break
  const int pomodoroCycle = 4; // Number of pomodoros in one cycle

  Timer? timer;
  int cycleCounter = 0;

  final workButton = ButtonElement()..text = 'Start Work';
  final breakButton = ButtonElement()..text = 'Start Break';

  final timerDisplay = DivElement()
    ..style.fontSize = '48px'
    ..style.textAlign = 'center'
    ..style.marginTop = '20px';

  final container = DivElement()
    ..style.display = 'flex'
    ..style.flexDirection = 'column'
    ..style.alignItems = 'center'
    ..style.justifyContent = 'center'
    ..style.height = '100vh';

  void startTimer(int minutes) {
    int seconds = minutes * 60;
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      seconds--;
      if (seconds <= 0) {
        t.cancel();
        cycleCounter++;
        if (cycleCounter < pomodoroCycle) {
          timerDisplay.text = 'Take a short break!';
          breakButton.disabled = false;
        } else {
          timerDisplay.text = 'Take a long break!';
          cycleCounter = 0;
          breakButton.disabled = false;
        }
      } else {
        int minutesRemaining = seconds ~/ 60;
        int secondsRemaining = seconds % 60;
        timerDisplay.text = '$minutesRemaining:${secondsRemaining.toString().padLeft(2, '0')}';
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  void startWork() {
    workButton.disabled = true;
    breakButton.disabled = true;
    startTimer(pomodoroDuration);
  }

  void startBreak() {
    workButton.disabled = true;
    breakButton.disabled = true;
    startTimer(cycleCounter < pomodoroCycle - 1 ? shortBreakDuration : longBreakDuration);
  }

  workButton.onClick.listen((_) => startWork());
  breakButton.onClick.listen((_) => startBreak());

  container
    ..children.add(timerDisplay)
    ..children.add(workButton)
    ..children.add(breakButton);

  document.body?.children.add(container);
}
