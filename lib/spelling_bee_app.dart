import 'package:polymer/polymer.dart';

import 'model.dart';

@CustomTag('spelling-bee-app')
class SpellingBeeApp extends PolymerElement with ChangeNotifier {
  final GlobalState state = globalState;

  @ComputedProperty('pageFor(state.currentDictionary, state.currentGame,'
        'state.showPerformance, state.showLeaderboard)')
  int get currentPage => readValue(#currentPage);

  @ComputedProperty('currentPage > 0')
  bool get showBack => readValue(#showBack);

  @ComputedProperty('subtitleFor(state.currentDictionary, state.currentGame, '
        'state.showPerformance, state.showLeaderboard)')
  String get subtitle => readValue(#subtitle);

  int pageFor(Dictionary dictionary, GameModel game, bool perf, bool lead) {
    if (dictionary == null) return 0;
    if (game == null) return 1;
    if (!perf && !lead) return 2;
    if (perf) return 3;
    if (lead) return 4;
    return 0;
  }

  String subtitleFor(Dictionary dictionary, GameModel game, bool perf, bool lead) {
    if (dictionary == null) return 'choose a word list';
    if (game == null) return dictionary.name;
    if (perf) return "Performance";
    if (lead) return "Leaderboard";
    return dictionary.name;
  }

  restart() {
    globalState.currentDictionary = null;
    globalState.currentGame = null;
    globalState.showPerformance = false;
    globalState.showLeaderboard = false;
  }

  SpellingBeeApp.created() : super.created();
}
