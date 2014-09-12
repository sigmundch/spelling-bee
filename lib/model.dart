library spelling_bee.model;

import 'package:observe/observe.dart';
import 'dart:html';
import 'dart:async';

final globalState = new GlobalState();
final allDictionaries = [
  new Dictionary('Animals',
      'Some common and some not so common animals of our world.',
      'animals.txt'),
  new Dictionary('Two letter words', 'All valid two letter scrabble words.',
      '2.txt'),
  new Dictionary('Three letter words', 'All valid three letter scrabble words.',
      '3.txt'),
  new Dictionary('J words', 'All valid scrabble words with a J.', 'j.txt'),
  new Dictionary('Q words', 'All valid scrabble words with a Q', 'q.txt'),
  new Dictionary('Vowel words', 'Scrabble words with at most one consonant.',
      'vowels.txt'),
  new Dictionary('Consonant words', 'Scrabble words without any vowels.',
      'consonant.txt'),
];

class GlobalState extends Observable {
  @observable Dictionary currentDictionary;
  @observable GameModel currentGame;
  @observable bool showPerformance;
  @observable bool showLeaderboard;
}

class GameModel extends Observable {
  List<Word> words;
  List<Answer> answers;
  @observable int current = 0;
  @observable int skipped = 0;
  @observable int correct = 0;
  @observable int wrong = 0;
  int get total => words.length;
  Word get currentWord => words[current];
  Duration time;

  GameModel(List words)
      : this.words = new List.from(words),
        this.answers = words.map((w) => new Answer(w)).toList();
}

class Word {
  final String word;
  final String definition;

  const Word(this.word, this.definition);
}

class Answer {
  Word word;

  Answer(this.word);
}

class Dictionary {
  static int _id = 0;
  final int id = _id++;
  final String name;
  final String description;
  final String path;
  List<Word> words = [];


  Dictionary(this.name, this.description, this.path);

  bool _isLoaded = false;
  Future _onLoad;

  Future load() {
    if (_isLoaded) return new Future.value();
    if (_onLoad != null) return _onLoad;
    var completer = new Completer();
    _onLoad = completer.future;
    return HttpRequest.getString('dictionaries/$path').then((s) {
      var lines = s.split('\n');
      for (var line in lines) {
        if (line.trim().isEmpty) continue;
        var index = line.indexOf(',');
        if (index == -1 ||
            line.substring(index + 1).replaceAll('\\,', '').contains(',')) {
          print('Invalid entry ($index): $line contains unescaped commas.');
          continue;
        }
        words.add(new Word(line.substring(0, index),
              line.substring(index + 1)));
      }
      completer.complete();
      _isLoaded = true;
      _onLoad = null;
    });
  }
}

