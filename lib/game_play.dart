library spelling_bee.game_play;

import 'dart:html';
import 'dart:async';


import 'package:polymer/polymer.dart';

import 'model.dart';

@CustomTag('game-play')
class GamePlay extends PolymerElement {
  @published GameModel game;
  @observable String answer;

  // Keep around an old copy of the word/answer so we can display the error
  // dialog and move on to the new word immediately.
  @observable String lastWord;
  @observable String lastAnswer;

  @ComputedProperty('game.current == game.total')
  bool get gameOver => readValue(#gameOver);

  @observable String minutes = '00';
  @observable String seconds = '00';
  var watch;
  var timer;

  GamePlay.created() : super.created();

  gameChanged(oldValue) {
    _stopTimer();
    if (oldValue == null && game != null) {
      _startTimer();
      readCurrentWord();
    }
  }

  _startTimer() {
    watch = new Stopwatch();
    watch.start();
    timer = new Timer.periodic(new Duration(seconds: 1), (_) {
      var secs = watch.elapsed.inSeconds % 60;
      seconds = secs < 10 ? '0$secs' : '$secs';
      var mins = watch.elapsed.inMinutes;
      minutes = mins < 10 ? '0$mins' : '$mins';
    });
  }

  _stopTimer() {
    if (watch != null) {
      watch.stop();
      watch = null;
      timer.cancel();
      timer = null;
    }
  }

  _next() {
    game.current++;
    if (!gameOver) {
      readCurrentWord();
    } else {
      game.time = watch.elapsed;
      _stopTimer();
      window.speechSynthesis.cancel();
    }
  }

  submit() {
    var word = game.currentWord.word;
    if (word == answer) {
      game.correct++;
      _showCorrectDialog();
    } else {
      game.wrong++;
      lastWord = word;
      lastAnswer = answer;
      _showErrorDialog();
    }
    _next();
  }

  _showCorrectDialog() {
    $['correct'].opened = true;
    new Timer(new Duration(milliseconds: 1000), () {
      $['correct'].opened = false;
    });
  }

  _showErrorDialog() {
    $['incorrect'].opened = true;
    new Timer(new Duration(milliseconds: 2500), () {
      $['incorrect'].opened = false;
    });
  }

  replay() => readCurrentWord();

  readCurrentWord() {
    window.speechSynthesis.cancel();
    var ttsWord = new SpeechSynthesisUtterance(game.currentWord.word)
        ..rate = 1.2;
    var ttsDefinition =
        new SpeechSynthesisUtterance(game.currentWord.definition);
    window.speechSynthesis.speak(ttsWord);
    window.speechSynthesis.speak(ttsDefinition);
    window.speechSynthesis.speak(ttsWord);
  }

  skip() {
    game.skipped++;
    _next();
  }

  toPerformance() {
    globalState.showPerformance = true;
  }

  toLeaderboard() {
    globalState.showLeaderboard = true;
  }
}
