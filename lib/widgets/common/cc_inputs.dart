import 'package:flutter/material.dart';
import '../../core/design/design_system.dart';
import '../../core/utils/adaptive_icons.dart';

/// Reusable input field components following the College Confessions design system

/// Standard text input field
class CCTextField extends StatelessWidget {
  const CCTextField({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: CCDesignSystem.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: CCDesignSystem.textPrimary,
            ),
          ),
          const SizedBox(height: CCDesignSystem.space8),
        ],
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          enabled: enabled,
          readOnly: readOnly,
          obscureText: obscureText,
          autofocus: autofocus,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            suffixIcon: suffixIcon,
            counterText: maxLength != null ? '${controller.text.length}/$maxLength' : null,
          ),
        ),
      ],
    );
  }
}

/// Search input field with search icon
class CCSearchField extends StatelessWidget {
  const CCSearchField({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String hintText;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      autofocus: autofocus,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(AdaptiveIcons.search),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(AdaptiveIcons.close),
                onPressed: () {
                  controller.clear();
                  onChanged?.call('');
                },
              )
            : null,
        filled: true,
        fillColor: CCDesignSystem.backgroundCard,
        border: const OutlineInputBorder(
          borderRadius: CCDesignSystem.borderRadiusXLarge,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: CCDesignSystem.borderRadiusXLarge,
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: CCDesignSystem.borderRadiusXLarge,
          borderSide: BorderSide(
            color: CCDesignSystem.primaryBlue,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: CCDesignSystem.space16,
          vertical: CCDesignSystem.space12,
        ),
      ),
    );
  }
}

/// Textarea for multi-line input (like confession posts)
class CCTextArea extends StatelessWidget {
  const CCTextArea({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.maxLength = 500,
    this.minLines = 3,
    this.maxLines = 8,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.showCharacterCount = true,
  });

  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final int? maxLength;
  final int minLines;
  final int maxLines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final bool showCharacterCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: CCDesignSystem.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: CCDesignSystem.textPrimary,
            ),
          ),
          const SizedBox(height: CCDesignSystem.space8),
        ],
        TextFormField(
          controller: controller,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          validator: validator,
          onChanged: onChanged,
          enabled: enabled,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          decoration: InputDecoration(
            hintText: hintText,
            counterText: showCharacterCount && maxLength != null 
                ? '${controller.text.length}/$maxLength'
                : '',
            alignLabelWithHint: true,
          ),
        ),
        if (showCharacterCount && maxLength != null)
          const SizedBox(height: CCDesignSystem.space4),
        if (showCharacterCount && maxLength != null)
          _buildCharacterProgress(),
      ],
    );
  }

  Widget _buildCharacterProgress() {
    final progress = controller.text.length / (maxLength ?? 1);
    Color progressColor;
    
    if (progress < 0.7) {
      progressColor = CCDesignSystem.success;
    } else if (progress < 0.9) {
      progressColor = CCDesignSystem.warning;
    } else {
      progressColor = CCDesignSystem.error;
    }

    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: CCDesignSystem.backgroundCard,
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: progressColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

/// Dropdown field component
class CCDropdown<T> extends StatelessWidget {
  const CCDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.validator,
    this.enabled = true,
  });

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final String? label;
  final String? hintText;
  final IconData? prefixIcon;
  final String? Function(T?)? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: CCDesignSystem.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: CCDesignSystem.textPrimary,
            ),
          ),
          const SizedBox(height: CCDesignSystem.space8),
        ],
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: enabled ? onChanged : null,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          ),
          style: CCDesignSystem.bodyMedium,
          dropdownColor: CCDesignSystem.backgroundWhite,
          borderRadius: CCDesignSystem.borderRadiusLarge,
        ),
      ],
    );
  }
}

/// Toggle switch component
class CCToggle extends StatelessWidget {
  const CCToggle({
    super.key,
    required this.value,
    required this.onChanged,
    required this.activeLabel,
    required this.inactiveLabel,
    this.activeIcon,
    this.inactiveIcon,
  });

  final bool value;
  final void Function(bool) onChanged;
  final String activeLabel;
  final String inactiveLabel;
  final IconData? activeIcon;
  final IconData? inactiveIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: CCDesignSystem.backgroundCard,
        borderRadius: CCDesignSystem.borderRadiusLarge,
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(true),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: CCDesignSystem.space12,
                  horizontal: CCDesignSystem.space16,
                ),
                decoration: BoxDecoration(
                  color: value ? CCDesignSystem.anonymous : Colors.transparent,
                  borderRadius: CCDesignSystem.borderRadiusLarge,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (activeIcon != null) ...[
                      Icon(
                        activeIcon,
                        color: value ? CCDesignSystem.textWhite : CCDesignSystem.textSecondary,
                        size: 18,
                      ),
                      const SizedBox(width: CCDesignSystem.space8),
                    ],
                    Text(
                      activeLabel,
                      style: CCDesignSystem.buttonMedium.copyWith(
                        color: value ? CCDesignSystem.textWhite : CCDesignSystem.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(false),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: CCDesignSystem.space12,
                  horizontal: CCDesignSystem.space16,
                ),
                decoration: BoxDecoration(
                  color: !value ? CCDesignSystem.publicPost : Colors.transparent,
                  borderRadius: CCDesignSystem.borderRadiusLarge,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (inactiveIcon != null) ...[
                      Icon(
                        inactiveIcon,
                        color: !value ? CCDesignSystem.textWhite : CCDesignSystem.textSecondary,
                        size: 18,
                      ),
                      const SizedBox(width: CCDesignSystem.space8),
                    ],
                    Text(
                      inactiveLabel,
                      style: CCDesignSystem.buttonMedium.copyWith(
                        color: !value ? CCDesignSystem.textWhite : CCDesignSystem.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}