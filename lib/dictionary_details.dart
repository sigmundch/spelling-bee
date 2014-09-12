import 'package:polymer/polymer.dart';

import 'model.dart';

@CustomTag('dictionary-details')
class DictionaryDetails extends PolymerElement {
  @published Dictionary dictionary;
  @observable bool loaded = false;

  DictionaryDetails.created() : super.created();

  dictionaryChanged(oldValue) {
    if (dictionary == null) return;
    dictionary.load().then((_) { loaded = true; });
  }

  startQuickGame() { 
    globalState.currentGame = new GameModel(dictionary.words);
  }

  startGame() {
    globalState.currentGame = new GameModel(dictionary.words);
  }
}
