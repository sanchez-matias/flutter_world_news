import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_world_news/core/services/injection_container.dart';
import 'package:flutter_world_news/core/services/theme_preferences.dart';
import 'package:flutter_world_news/core/theme/app_theme.dart';
import 'package:flutter_world_news/src/news/presentation/bloc/blocs.dart';
import 'package:flutter_world_news/src/news/presentation/screens/screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await ThemePreferences.initPrefs();
  await init();
  runApp(const BlocProviders());
}

class BlocProviders extends StatelessWidget {
  const BlocProviders({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = ThemePreferences();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<RemoteBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<StorageBloc>(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(
            isDarkMode: prefs.lastBrightnessMode,
            themeColor: prefs.lastThemeColor,
          ),
        ),
        BlocProvider(
          create: (context) => sl<RemoteSearchCubit>(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeCubit>().state;

    return MaterialApp(
      title: 'World News',
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      theme: AppTheme(
        isDarkmode: theme.isDarkMode,
        colorThemeIndex: theme.themeColor,
      ).getTheme(),
      routes: {
        'home': (context) => const HomeScreen(),
        'settings': (context) => const SettingsScreen(),
      },
    );
  }
}
