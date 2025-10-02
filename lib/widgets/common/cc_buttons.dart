import 'package:flutter/material.dart';
import '../../core/design/design_system.dart';

/// Reusable button components following the College Confessions design system
/// 
/// These components provide consistent styling and behavior across the app.
/// Use these instead of creating custom buttons to maintain design consistency.

/// Primary action button - use for main CTAs
class CCPrimaryButton extends StatelessWidget {
  const CCPrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.isEnabled = true,
    this.size = CCButtonSize.medium,
    this.icon,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;
  final bool isEnabled;
  final CCButtonSize size;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _getButtonHeight(),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (isEnabled && !isLoading) ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: CCDesignSystem.primaryBlue,
          foregroundColor: CCDesignSystem.textWhite,
          disabledBackgroundColor: CCDesignSystem.textSecondary,
          disabledForegroundColor: CCDesignSystem.textWhite,
          elevation: 0,
          textStyle: _getTextStyle(),
          shape: const RoundedRectangleBorder(
            borderRadius: CCDesignSystem.borderRadiusLarge,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: CCDesignSystem.textWhite,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: _getIconSize()),
                    const SizedBox(width: CCDesignSystem.space8),
                  ],
                  Text(label),
                ],
              ),
      ),
    );
  }

  double _getButtonHeight() {
    switch (size) {
      case CCButtonSize.small:
        return CCDesignSystem.buttonHeightSmall;
      case CCButtonSize.medium:
        return CCDesignSystem.buttonHeightMedium;
      case CCButtonSize.large:
        return CCDesignSystem.buttonHeightLarge;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case CCButtonSize.small:
        return CCDesignSystem.buttonSmall;
      case CCButtonSize.medium:
        return CCDesignSystem.buttonMedium;
      case CCButtonSize.large:
        return CCDesignSystem.buttonLarge;
    }
  }

  double _getIconSize() {
    switch (size) {
      case CCButtonSize.small:
        return CCDesignSystem.iconSizeSmall;
      case CCButtonSize.medium:
        return CCDesignSystem.iconSizeMedium;
      case CCButtonSize.large:
        return CCDesignSystem.iconSizeLarge;
    }
  }
}

/// Secondary action button - use for secondary actions
class CCSecondaryButton extends StatelessWidget {
  const CCSecondaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.isEnabled = true,
    this.size = CCButtonSize.medium,
    this.icon,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;
  final bool isEnabled;
  final CCButtonSize size;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _getButtonHeight(),
      width: double.infinity,
      child: OutlinedButton(
        onPressed: (isEnabled && !isLoading) ? onPressed : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: CCDesignSystem.primaryBlue,
          disabledForegroundColor: CCDesignSystem.textSecondary,
          textStyle: _getTextStyle(),
          side: BorderSide(
            color: isEnabled ? CCDesignSystem.primaryBlue : CCDesignSystem.textSecondary,
            width: 1,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: CCDesignSystem.borderRadiusLarge,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: CCDesignSystem.primaryBlue,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: _getIconSize()),
                    const SizedBox(width: CCDesignSystem.space8),
                  ],
                  Text(label),
                ],
              ),
      ),
    );
  }

  double _getButtonHeight() {
    switch (size) {
      case CCButtonSize.small:
        return CCDesignSystem.buttonHeightSmall;
      case CCButtonSize.medium:
        return CCDesignSystem.buttonHeightMedium;
      case CCButtonSize.large:
        return CCDesignSystem.buttonHeightLarge;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case CCButtonSize.small:
        return CCDesignSystem.buttonSmall;
      case CCButtonSize.medium:
        return CCDesignSystem.buttonMedium;
      case CCButtonSize.large:
        return CCDesignSystem.buttonLarge;
    }
  }

  double _getIconSize() {
    switch (size) {
      case CCButtonSize.small:
        return CCDesignSystem.iconSizeSmall;
      case CCButtonSize.medium:
        return CCDesignSystem.iconSizeMedium;
      case CCButtonSize.large:
        return CCDesignSystem.iconSizeLarge;
    }
  }
}

/// Text button - use for tertiary actions
class CCTextButton extends StatelessWidget {
  const CCTextButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isEnabled = true,
    this.size = CCButtonSize.medium,
    this.icon,
    this.color,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool isEnabled;
  final CCButtonSize size;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isEnabled ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: color ?? CCDesignSystem.primaryBlue,
        disabledForegroundColor: CCDesignSystem.textSecondary,
        textStyle: _getTextStyle(),
        shape: const RoundedRectangleBorder(
          borderRadius: CCDesignSystem.borderRadiusLarge,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: _getIconSize()),
            const SizedBox(width: CCDesignSystem.space8),
          ],
          Text(label),
        ],
      ),
    );
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case CCButtonSize.small:
        return CCDesignSystem.buttonSmall;
      case CCButtonSize.medium:
        return CCDesignSystem.buttonMedium;
      case CCButtonSize.large:
        return CCDesignSystem.buttonLarge;
    }
  }

  double _getIconSize() {
    switch (size) {
      case CCButtonSize.small:
        return CCDesignSystem.iconSizeSmall;
      case CCButtonSize.medium:
        return CCDesignSystem.iconSizeMedium;
      case CCButtonSize.large:
        return CCDesignSystem.iconSizeLarge;
    }
  }
}

/// Icon button - use for actions with only icons
class CCIconButton extends StatelessWidget {
  const CCIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.isEnabled = true,
    this.size = CCIconButtonSize.medium,
    this.color,
    this.backgroundColor,
    this.tooltip,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final bool isEnabled;
  final CCIconButtonSize size;
  final Color? color;
  final Color? backgroundColor;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      onPressed: isEnabled ? onPressed : null,
      icon: Icon(
        icon,
        size: _getIconSize(),
        color: color ?? CCDesignSystem.textPrimary,
      ),
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        disabledForegroundColor: CCDesignSystem.textSecondary,
        minimumSize: Size(_getButtonSize(), _getButtonSize()),
        maximumSize: Size(_getButtonSize(), _getButtonSize()),
      ),
      tooltip: tooltip,
    );

    return button;
  }

  double _getIconSize() {
    switch (size) {
      case CCIconButtonSize.small:
        return CCDesignSystem.iconSizeSmall;
      case CCIconButtonSize.medium:
        return CCDesignSystem.iconSizeMedium;
      case CCIconButtonSize.large:
        return CCDesignSystem.iconSizeLarge;
    }
  }

  double _getButtonSize() {
    switch (size) {
      case CCIconButtonSize.small:
        return 32;
      case CCIconButtonSize.medium:
        return 44;
      case CCIconButtonSize.large:
        return 56;
    }
  }
}

/// Button size options
enum CCButtonSize {
  small,
  medium,
  large,
}

/// Icon button size options
enum CCIconButtonSize {
  small,
  medium,
  large,
}