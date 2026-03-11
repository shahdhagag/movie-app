import 'package:flutter/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:movie/core/utils/app_assets.dart';
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
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            // Navigate to home screen
            context.go('/main');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.red,
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
                    SizedBox(height: 60.h),
                    // Back button
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: AppColors.primary,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(height: 40.h),

                    // Play icon
                    Center(
                      child: Center(
                        child: Image.asset(
                          AppAssets.appLogo,
                          height: 118.h,
                          width: 120.w,
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),

                    Center(child: Text('Login', style: AppStyles.h2)),
                    SizedBox(height: 40.h),

                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email field
                          AuthTextField(
                            hintText: ' Email',
                            controller: _emailController,
                            prefixIcon: Image.asset(AppAssets.emailIcon,width: 3.w,height: 25.h,),
                            keyboardType: TextInputType.emailAddress,
                            validator: AppValidators.validateEmail,
                          ),
                          SizedBox(height: 20.h),

                          // Password field
                          AuthTextField(

                            hintText: ' Password',
                            controller: _passwordController,
                            prefixIcon:Image.asset(AppAssets.passwordIcon,width: 3.w,height: 25.h),
                            isPassword: true,
                            validator: AppValidators.validatePassword,
                          ),
                          SizedBox(height: 12.h),

                          // Forgot password
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () => context.push('/forgot-password'),
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

                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed: state is AuthLoading
                                  ? null
                                  : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                disabledBackgroundColor: AppColors.textTertiary,
                              ),
                              child: state is AuthLoading
                                  ? SizedBox(
                                      height: 24.h,
                                      width: 24.h,
                                      child: const CircularProgressIndicator(
                                        color: AppColors.primary,
                                      ),
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

                          // Register link
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
                                        context.push('/register');
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 30.h),

                          // OR Divider
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
                                  color: AppColors.textTertiary.withOpacity(0.3),
                                  thickness: 2,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30.h),

                          // Google Sign-In Button
                          SizedBox(
                            width: double.infinity,
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed: state is AuthLoading
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
                              child: state is AuthLoading
                                  ? SizedBox(
                                      height: 24.h,
                                      width: 24.h,
                                      child: const CircularProgressIndicator(
                                        color: AppColors.primary,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
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
