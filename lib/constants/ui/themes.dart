import 'package:ema_v4/constants/ui/shape.dart';
import 'package:flutter/material.dart';

import '../colors.dart';

getLightTheme(BuildContext context) => ThemeData(
    scaffoldBackgroundColor: bg,
    cardColor: card,
    hintColor: secondary,
    primaryColor: primary,
    fontFamily: 'Jost',
    colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: Colors.white,
        secondary: secondary,
        primaryContainer: primary,
        onPrimaryContainer: Colors.white,
        onSecondary: Colors.black,
        error: Colors.red,
        onError: Colors.white,
        background: bg,
        onBackground: primary,
        surface: bg,
        onSurface: primary,
        errorContainer: themeRed,
        onErrorContainer: onThemeRed),
    cardTheme: Theme.of(context).cardTheme.copyWith(
        color: card,
        clipBehavior: Clip.hardEdge,
        elevation: 1.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(rad2))),
    appBarTheme: Theme.of(context).appBarTheme.copyWith(
          color: bg,
          foregroundColor: primary,
          elevation: 0.0,
        ),
    brightness: Brightness.light,
    textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Jost',
          bodyColor: primary,
          displayColor: primary,
        ),
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: primary,
        selectionHandleColor: primary,
        selectionColor: primary.withAlpha(100)),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: card,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent, width: 0),
        borderRadius: BorderRadius.all(rad2),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent, width: 0),
        borderRadius: BorderRadius.all(rad2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(primary),
        textStyle: MaterialStateProperty.all(Theme.of(context)
            .textTheme
            .apply(fontFamily: 'Jost')
            .titleMedium
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0)),
        minimumSize: MaterialStateProperty.all(const Size(double.maxFinite, 0)),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.all(rad1))),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(card),
        foregroundColor: MaterialStateProperty.all(primary),
        textStyle: MaterialStateProperty.all(
          Theme.of(context)
              .textTheme
              .apply(fontFamily: 'Jost')
              .titleMedium
              ?.copyWith(color: primary, fontWeight: FontWeight.w600),
        ),
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0)),
        minimumSize: MaterialStateProperty.all(const Size(double.maxFinite, 0)),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.all(rad1))),
      ),
    ),
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primary;
        }
        return secondary;
      }),
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return themeGreen;
        }
        return themeRed;
      }),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: bg,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primary,
    ));

getDarkTheme(BuildContext context) => ThemeData(
    scaffoldBackgroundColor: bgDark,
    cardColor: cardDark,
    hintColor: secondaryDark,
    primaryColor: primaryDark,
    fontFamily: 'Jost',
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryDark,
      onPrimary: onPrimaryDark,
      primaryContainer: primaryContainerDark,
      onPrimaryContainer: onPrimaryContainerDark,
      secondary: secondaryDark,
      onSecondary: onSecondaryDark,
      error: themeRedDark,
      onError: onThemeRedDark,
      background: bgDark,
      onBackground: primaryDark,
      surface: bgDark,
      onSurface: primaryDark,
      errorContainer: themeRedDark,
      onErrorContainer: onThemeRedDark,
    ),
    cardTheme: Theme.of(context).cardTheme.copyWith(
        color: cardDark,
        clipBehavior: Clip.hardEdge,
        elevation: 1.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(rad2))),
    appBarTheme: Theme.of(context).appBarTheme.copyWith(
          color: bgDark,
          foregroundColor: primaryDark,
          elevation: 0.0,
        ),
    brightness: Brightness.dark,
    textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Jost',
          bodyColor: primaryDark,
          displayColor: primaryDark,
        ),
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: primaryDark,
        selectionHandleColor: primaryDark,
        selectionColor: primaryDark.withAlpha(100)),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: cardDark,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent, width: 0),
        borderRadius: BorderRadius.all(rad2),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent, width: 0),
        borderRadius: BorderRadius.all(rad2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(primaryDark),
        textStyle: MaterialStateProperty.all(Theme.of(context)
            .textTheme
            .apply(fontFamily: 'Jost')
            .titleMedium
            ?.copyWith(color: onPrimaryDark, fontWeight: FontWeight.w600)),
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0)),
        minimumSize: MaterialStateProperty.all(const Size(double.maxFinite, 0)),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.all(rad1))),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(cardDark),
        foregroundColor: MaterialStateProperty.all(primaryDark),
        textStyle: MaterialStateProperty.all(
          Theme.of(context)
              .textTheme
              .apply(fontFamily: 'Jost')
              .titleMedium
              ?.copyWith(color: primaryDark, fontWeight: FontWeight.w600),
        ),
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0)),
        minimumSize: MaterialStateProperty.all(const Size(double.maxFinite, 0)),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.all(rad1))),
      ),
    ),
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryDark;
        }
        return secondaryDark;
      }),
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return themeGreenDark;
        }
        return themeRedDark;
      }),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: bgDark,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryDark,
    ));
