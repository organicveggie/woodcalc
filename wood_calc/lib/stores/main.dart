import 'package:mobx/mobx.dart';
import 'package:wood_calc/models/models.dart';

part 'main.g.dart';

// ignore: library_private_types_in_public_api
class MainStore = _MainStore with _$MainStore;

abstract class _MainStore with Store {
  // _MainStore(this.displayMode);

  @observable
  DisplayMode displayMode = DisplayMode.totalInches;

  @action
  void toggleDisplayMode() {
    displayMode = switch (displayMode) {
      DisplayMode.feetAndInches => DisplayMode.totalInches,
      _ => DisplayMode.feetAndInches,
    };
  }
}
