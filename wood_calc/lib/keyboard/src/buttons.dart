import 'package:flutter/material.dart';

typedef VoidFN = void Function();

abstract class _ColorProvider extends StatelessWidget {
  const _ColorProvider({super.key});

  Color getBgColor(ColorScheme cs);
  Color getFgColor(ColorScheme cs);
  Color getDisabledBgColor(ColorScheme cs);
  Color getDisabledFgColor(ColorScheme cs);

  ButtonStyle getDefaultButtonStyle(final ThemeData theme) {
    final ColorScheme colorScheme = theme.colorScheme;
    return TextButton.styleFrom(
      backgroundColor: getBgColor(colorScheme),
      disabledBackgroundColor: getDisabledBgColor(colorScheme),
      foregroundColor: getFgColor(colorScheme),
      disabledForegroundColor: getDisabledFgColor(colorScheme),
      textStyle: theme.textTheme.headlineLarge,
    );
  }
}

abstract class BaseIconInputButton extends _ColorProvider {
  const BaseIconInputButton({super.key});

  @override
  Color getBgColor(ColorScheme cs) => cs.secondary;
  @override
  Color getFgColor(ColorScheme cs) => cs.onSecondary;
  @override
  Color getDisabledBgColor(ColorScheme cs) => cs.secondaryContainer;
  @override
  Color getDisabledFgColor(ColorScheme cs) => cs.onSecondaryContainer;

  Widget makeButton(
      {required BuildContext context, required Icon icon, required Function() isEnabled, VoidFN? onPressed}) {
    final ThemeData theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(
        minHeight: 100,
      ),
      child: Center(
        child: SizedBox(
            height: 40,
            width: 56,
            child: IconButton(
              style: getDefaultButtonStyle(theme),
              onPressed: (isEnabled() && (onPressed != null)) ? () => onPressed() : null,
              icon: icon,
            )),
      ),
    );
  }
}

abstract class IconInputButton extends BaseIconInputButton {
  const IconInputButton({super.key, required this.icon});

  final Icon icon;

  Widget makeIconButton({required BuildContext context, required Function() isEnabled, VoidFN? onPressed}) {
    return makeButton(context: context, icon: icon, isEnabled: isEnabled, onPressed: onPressed);
  }
}

abstract class TextInputButton extends _ColorProvider {
  const TextInputButton({super.key, required this.text});

  final String text;

  @override
  Color getBgColor(ColorScheme cs) => cs.tertiary;
  @override
  Color getFgColor(ColorScheme cs) => cs.onTertiary;
  @override
  Color getDisabledBgColor(ColorScheme cs) => cs.tertiaryContainer;
  @override
  Color getDisabledFgColor(ColorScheme cs) => cs.onTertiaryContainer;

  Widget makeButton({required BuildContext context, required Function() isEnabled, VoidFN? onPressed}) {
    final ThemeData theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(
        minHeight: 100,
      ),
      padding: EdgeInsets.all(10),
      child: Center(
        child: TextButton(
          style: getDefaultButtonStyle(theme),
          onPressed: (isEnabled() && (onPressed != null)) ? () => onPressed() : null,
          child: Text(
            text,
            // style: textTheme,
          ),
        ),
      ),
    );
  }
}
