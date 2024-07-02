import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_world_news/core/services/theme_preferences.dart';
import 'package:flutter_world_news/src/news/presentation/bloc/blocs.dart';
import 'package:flutter_world_news/core/theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeCubit>().state;
    final themePrefs = ThemePreferences();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dark Mode
            SwitchListTile.adaptive(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: const Row(
                children: [
                  Icon(Icons.dark_mode),
                  SizedBox(width: 20),
                  Text('Dark Mode'),
                ],
              ),
              value: theme.isDarkMode,
              onChanged: (value) {
                context.read<ThemeCubit>().toggleDarkMode();
                themePrefs.lastBrightnessMode = value;
              },
            ),

            // Theme Color
            const _CustomTitle('Theme Color'),
            Wrap(
              spacing: 5,
              children: List<Widget>.generate(
                  colors.length,
                  (int index) => ChoiceChip(
                      label: Text(colors[index].colorName),
                      selected: theme.themeColor == index,
                      onSelected: (bool isSelected) {
                        context.read<ThemeCubit>().changeColorTheme(index);
                        themePrefs.lastThemeColor = index;
                      })).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomTitle extends StatelessWidget {
  final String msg;

  const _CustomTitle(this.msg);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        msg,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}
