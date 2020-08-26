import 'package:flutter/cupertino.dart';

abstract class AppBarUseCaseState {
  AppBarUseCaseState();
}

class AppBarUseCaseInitial implements AppBarUseCaseState {
  const AppBarUseCaseInitial();
}

class AppBarUseCaseSearch implements AppBarUseCaseState {
  const AppBarUseCaseSearch();
}

class AppBarUseCaseDefault implements AppBarUseCaseState {
  const AppBarUseCaseDefault();
}

class AppBarUseCase extends ChangeNotifier {
  AppBarUseCaseState _state;

  AppBarUseCaseState get state {
    return _state ??= const AppBarUseCaseInitial();
  }

  void _updateState(AppBarUseCaseState state) {
    if (state == _state) {
      return;
    }
    _state = state;
    notifyListeners();
  }

  void resetSearching() {
    _updateState(AppBarUseCaseDefault());
  }

  void startSearching() {
    _updateState(AppBarUseCaseSearch());
  }
}
