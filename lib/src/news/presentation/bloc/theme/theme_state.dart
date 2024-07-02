part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final bool isDarkMode;
  final int themeColor;

  const ThemeState({
    required this.isDarkMode,
    required this.themeColor,
  });

  ThemeState copyWith({
    bool? isDarkMode,
    int? themeColor,
  }) =>
      ThemeState(
        isDarkMode: isDarkMode ?? this.isDarkMode,
        themeColor: themeColor ?? this.themeColor,
      );

  @override
  List<Object> get props => [isDarkMode, themeColor];
}
