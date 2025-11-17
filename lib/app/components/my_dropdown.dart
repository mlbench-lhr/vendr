import 'package:vendr/app/styles/app_dimensions.dart';
import 'package:vendr/app/styles/app_radiuses.dart';
import 'package:vendr/app/utils/extensions/context_extensions.dart';
import 'package:vendr/app/utils/extensions/general_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyDropdown<T> extends StatelessWidget {
  const MyDropdown({
    required this.items,
    required this.onChanged,
    super.key,
    this.value,
    this.hint,
    this.label,
    this.validator,
    this.decoration,
    this.autovalidateMode,
    this.displayString,
    this.isEnabled = true,
    this.isExpanded = true,
    this.noBackground = false,
  });

  final List<T> items;
  final T? value;
  final String? hint;
  final String? label;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final AutovalidateMode? autovalidateMode;
  final InputDecoration? decoration;
  final String Function(T)? displayString;
  final bool isEnabled;
  final bool isExpanded;
  final bool
  noBackground; //This will remove the fill color and the border colors

  @override
  Widget build(BuildContext context) {
    final textStyle = context.typography.body.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 14.sp,
    );
    final InputDecoration inputDecoration =
        decoration ??
        InputDecoration(
          hintText: hint,
          labelText: label,
          filled: !noBackground,
          fillColor: noBackground
              ? Colors.transparent
              : context.colors.inputBackground,
          enabledBorder: noBackground
              ? InputBorder.none
              : OutlineInputBorder(
                  borderSide: BorderSide(color: context.colors.inputBorder),
                  borderRadius: BorderRadius.circular(
                    AppRadiuses.hundredRadius,
                  ),
                ),
          focusedBorder: noBackground
              ? InputBorder.none
              : OutlineInputBorder(
                  borderSide: BorderSide(color: context.colors.inputBorder),
                  borderRadius: BorderRadius.circular(
                    AppRadiuses.hundredRadius,
                  ),
                ),
          errorBorder: noBackground
              ? InputBorder.none
              : OutlineInputBorder(
                  borderSide: BorderSide(color: context.colors.error),
                  borderRadius: BorderRadius.circular(
                    AppRadiuses.hundredRadius,
                  ),
                ),
          focusedErrorBorder: noBackground
              ? InputBorder.none
              : OutlineInputBorder(
                  borderSide: BorderSide(color: context.colors.error),
                  borderRadius: BorderRadius.circular(
                    AppRadiuses.hundredRadius,
                  ),
                ),
        );

    return DropdownButtonFormField<T>(
      isExpanded: isExpanded,
      value: value,
      validator: validator,
      autovalidateMode: autovalidateMode,
      onChanged: isEnabled ? onChanged : null,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: context.colors.inputIcon,
      ),
      style: textStyle,
      decoration: inputDecoration,
      dropdownColor: context.colors.inputBackground,
      menuMaxHeight: context.mediaQueryHeight * 0.5,
      elevation: 2,
      borderRadius: BorderRadius.circular(AppDimensions.medium),
      items: items.map((e) {
        final isSelected = e == value;
        return DropdownMenuItem<T>(
          value: e,
          child: Text(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            displayString?.call(e) ?? e.toString(),
            style: textStyle.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? context.colors.inputText : null,
            ),
          ),
        );
      }).toList(),
    );
  }
}
