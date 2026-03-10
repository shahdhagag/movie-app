import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';

/// Custom text field widget for auth forms
class AuthTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool isPassword;
  final Function(String)? onChanged;
  final int? maxLines;

  const AuthTextField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.prefixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.onChanged,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppStyles.h5.copyWith(fontSize: 14.sp),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          maxLines: _obscureText ? 1 : widget.maxLines,
          onChanged: widget.onChanged,
          style: AppStyles.h5.copyWith(fontSize: 16.sp),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppStyles.h5.copyWith(
              fontSize: 14.sp,
              color: AppColors.textTertiary,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: AppColors.textTertiary,
                    size: 20.sp,
                  )
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      color: AppColors.textTertiary,
                      size: 20.sp,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            filled: true,
            fillColor: AppColors.grey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            errorStyle: AppStyles.h5.copyWith(
              fontSize: 12.sp,
              color: AppColors.red,
            ),
          ),
        ),
      ],
    );
  }
}

