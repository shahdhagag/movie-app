import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:movie/config/routes/app_routes.dart';
import 'package:movie/core/utils/app_assets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/app_validators.dart';
import '../../presentation/bloc/auth_bloc.dart';
import '../../presentation/bloc/auth_event.dart';
import '../../presentation/bloc/auth_state.dart';
import '../widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        LoginEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async{
          if (state is AuthSuccess) {
            final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('is_logged_in', true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Login successful!',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.green[600],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: EdgeInsets.all(16),
                duration: Duration(seconds: 3),
                elevation: 8,
              ),
            );

            context.go('/main');
          }
          else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        state.message,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.red[600],
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 8,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 100.h),

                    Center(
                      child: Center(
                        child: Image.asset(
                          AppAssets.appLogo,
                          height: 118.h,
                          width: 120.w,
                        ),
                      ),
                    ),
                    SizedBox(height: 80.h),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AuthTextField(
                            hintText: ' Email',
                            controller: _emailController,
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(4),
                              child: Image.asset(
                                AppAssets.emailIcon,
                                width: 3.w,
                                height: 25.h,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: AppValidators.validateEmail,
                          ),
                          SizedBox(height: 20.h),

                          AuthTextField(
                            hintText: ' Password',
                            controller: _passwordController,
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(4),
                              child: Image.asset(
                                AppAssets.passwordIcon,
                                width: 3.w,
                                height: 25.h,
                              ),
                            ),
                            isPassword: true,
                            validator: AppValidators.validatePassword,
                          ),
                          SizedBox(height: 12.h),

                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => context.push(AppRoutes.forgotPassword),
                              child: Text(
                                'Forgot Password ?',
                                style: AppStyles.h5.copyWith(
                                  fontSize: 14.sp,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30.h),
                          SizedBox(
                            width: double.infinity,
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed: state is LoginLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                disabledBackgroundColor: AppColors.textTertiary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: state is LoginLoading
                                  ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 24.w,
                                    height: 24.h,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'Logging in...',
                                    style: AppStyles.h5.copyWith(
                                      fontSize: 16.sp,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              )
                                  : Text(
                                'Login',
                                style: AppStyles.h5.copyWith(
                                  fontSize: 16.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),

                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: "Don't Have Account ? ",
                                style: AppStyles.h5.copyWith(
                                  fontSize: 14.sp,
                                  color: AppColors.textTertiary,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Create One',
                                    style: AppStyles.h5.copyWith(
                                      fontSize: 14.sp,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        context.push(AppRoutes.register);
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 30.h),

                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: AppColors.primary.withOpacity(0.3),
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                child: Text(
                                  'OR',
                                  style: AppStyles.h5.copyWith(
                                    fontSize: 14.sp,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: AppColors.textTertiary.withOpacity(
                                    0.3,
                                  ),
                                  thickness: 2,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.h),

                          SizedBox(
                            width: double.infinity,
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed: state is GoogleLoading
                                  ? null
                                  : () {
                                      context.read<AuthBloc>().add(
                                        const GoogleSignInEvent(),
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                disabledBackgroundColor: AppColors.textTertiary,
                              ),
                              child: state is GoogleLoading
                                  ? SizedBox(
                                      height: 24.h,
                                      width: 24.h,
                                      child: const CircularProgressIndicator(
                                        color: AppColors.primary,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'G',
                                          style: AppStyles.h5.copyWith(
                                            color: AppColors.textSecondary,
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Text(
                                          'Login With Google',
                                          style: AppStyles.h5.copyWith(
                                            fontSize: 16.sp,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
