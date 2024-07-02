import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({
    required bool isDarkMode,
    required int themeColor,
  }) : super(ThemeState(
          isDarkMode: isDarkMode,
          themeColor: themeColor,
        ));

  void toggleDarkMode() {
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }

  void changeColorTheme(int colorIndex) {
    emit(state.copyWith(themeColor: colorIndex));
  }
}
