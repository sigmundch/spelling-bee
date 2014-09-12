import 'package:polymer/polymer.dart';

import 'model.dart';

@CustomTag('dictionary-list')
class DictionaryList extends PolymerElement {
  final List dictionaries = toObservable(_allDictionariesSelectable);
  DictionaryList.created() : super.created();

  // TOOD(sigmund): maybe core-list is overkill for this app?
  clear() => $['list'].clearSelection();

}

final _allDictionariesSelectable = 
    allDictionaries.map((d) => new _DictionaryViewModel(d));

class _DictionaryViewModel {
  final Dictionary dictionary;

  bool _selected = false;
  bool get selected => _selected;
  set selected(bool value) {
    _selected = (value == true);
    if (_selected) {
      globalState.currentDictionary = dictionary;
    }
  }

  _DictionaryViewModel(this.dictionary);
}
