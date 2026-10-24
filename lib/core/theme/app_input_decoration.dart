import 'package:flutter/material.dart';
import 'package:postflow/core/constants/app_spacing.dart';

/// Consistent outlined, filled text-field styling.
abstract final class AppInputDecoration {
  static InputDecoration of(
    BuildContext context, {
    required String label,
    IconData? icon,
    Widget? suffix,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final radius = BorderRadius.circular(AppSpacing.radiusMd);

    OutlineInputBorder border(Color color, {double width = 1}) =>
        OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecoration(
      labelText: label,
      prefixIcon: icon == null ? null : Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: theme.scaffoldBackgroundColor,
      border: border(scheme.outline),
      enabledBorder: border(scheme.outline),
      focusedBorder: border(scheme.primary, width: 1.6),
      errorBorder: border(scheme.error),
      focusedErrorBorder: border(scheme.error, width: 1.6),
    );
  }
}
