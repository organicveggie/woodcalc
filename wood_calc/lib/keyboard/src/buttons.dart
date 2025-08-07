import 'package:flutter/material.dart';

typedef VoidFN = void Function();

abstract class BaseIconInputButton extends StatelessWidget {
  const BaseIconInputButton({super.key});

  Widget makeButton(
      {required BuildContext context, required Icon icon, required Function() isEnabled, VoidFN? onPressed}) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      constraints: BoxConstraints(
        minHeight: 100,
      ),
      child: Center(
        child: IconButton(
          style: IconButton.styleFrom(
            padding: EdgeInsets.all(10),
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: CircleBorder(),
          ),
          onPressed: (isEnabled() && (onPressed != null)) ? () => onPressed() : null,
          icon: icon,
        ),
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

abstract class TextInputButton extends StatelessWidget {
  const TextInputButton({super.key, required this.text});

  final String text;

  Widget makeButton({required BuildContext context, required Function() isEnabled, VoidFN? onPressed}) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      constraints: BoxConstraints(
        minHeight: 100,
      ),
      padding: EdgeInsets.all(10),
      child: Center(
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: colorScheme.secondary,
            foregroundColor: colorScheme.onSecondary,
          ),
          onPressed: (isEnabled() && (onPressed != null)) ? () => onPressed() : null,
          child: Text(
            text,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
      ),
    );
  }
}
