import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_world_news/core/services/theme_preferences.dart';
import 'package:flutter_world_news/src/news/presentation/bloc/blocs.dart';
import 'package:flutter_world_news/core/theme/app_theme.dart';

enum CategoryItem {
  general('General', 'general', Icons.all_inclusive),
  business('Business', 'business', Icons.business_center),
  entertainment('Entertainment', 'entertainment', Icons.tv),
  health('Health', 'health', Icons.health_and_safety),
  science('Science', 'science', Icons.science),
  sports('Sports', 'sports', Icons.sports_tennis),
  technology('Technology', 'technology', Icons.device_hub);

  const CategoryItem(this.label, this.endpointParam, this.icon);
  final String label;
  final String endpointParam;
  final IconData icon;
}

enum CountriesItem {
  usa('United States', 'us'),
  france('France', 'fr'),
  unitedKingom('United Kingdom', 'gb'),
  china('China', 'cn'),
  italy('Italy', 'it'),
  germany('Germany', 'de'),
  argentina('Argentina', 'ar'),
  brazil('Brazil', 'br');

  const CountriesItem(this.label, this.endpointParam);
  final String label;
  final String endpointParam;
}

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

            // Home results customization
            const _CustomTitle('Customize your results'),
            const _CustomDropdownMenus(),
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
          fontSize: 17,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}


class _CustomDropdownMenus extends StatelessWidget {
  const _CustomDropdownMenus();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final remoteBloc = context.watch<RemoteBloc>().state;
    final initialCategory = remoteBloc.category;
    final initialCountry = remoteBloc.country;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DropdownMenu<CategoryItem>(
            width: size.width * 0.4,
            enableSearch: false,
            initialSelection: CategoryItem.values
                .firstWhere((item) => item.endpointParam == initialCategory),
            dropdownMenuEntries: CategoryItem.values
                .map((item) => DropdownMenuEntry(
                      value: item,
                      label: item.label,
                      leadingIcon: Icon(item.icon),
                    ))
                .toList(),
            onSelected: (value) {
              if (value == null) return;
              context.read<RemoteBloc>().add(ChangeCategory(value.endpointParam));
            },
            label: const Text('Category'),
          ),
            
          DropdownMenu<CountriesItem>(
            width: size.width * 0.4,
            enableSearch: false,
            initialSelection: CountriesItem.values
                .firstWhere((item) => item.endpointParam == initialCountry),
            dropdownMenuEntries: CountriesItem.values
                .map((item) => DropdownMenuEntry(
                      value: item,
                      label: item.label,
                    ))
                .toList(),
            onSelected: (value) {
              if (value == null) return;
              context.read<RemoteBloc>().add(ChangeCountry(value.endpointParam));
            },
            label: const Text('Country'),
          ),
        ],
      ),
    );
  }
}
