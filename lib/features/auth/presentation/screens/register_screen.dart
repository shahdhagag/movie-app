import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/app_validators.dart';
import '../../presentation/bloc/auth_bloc.dart';
import '../../presentation/bloc/auth_event.dart';
import '../../presentation/bloc/auth_state.dart';
import '../widgets/auth_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            RegisterEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              name: _nameController.text.trim(),
              phoneNumber: _phoneController.text.trim(),
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            // Navigate to login screen
            context.go('/login');
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
                    SizedBox(height: 30.h),

                    // Title
                    Center(
                      child: Text(
                        'Register',
                        style: AppStyles.h2,
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Avatar selection (placeholder)
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  'Avatar',
                                  style: AppStyles.h5.copyWith(fontSize: 14.sp),
                                ),
                                SizedBox(height: 12.h),
                                Container(
                                  width: 60.w,
                                  height: 60.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.grey,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: AppColors.textTertiary,
                                    size: 30.sp,
                                  ),
                                ),
                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),

                          // Name field
                          AuthTextField(
                            label: 'Name',
                            hintText: 'Enter your full name',
                            controller: _nameController,
                            prefixIcon: Icons.person_outline_rounded,
                            validator: AppValidators.validateName,
                          ),
                          SizedBox(height: 20.h),

                          // Email field
                          AuthTextField(
                            label: 'Email',
                            hintText: 'Enter your email',
                            controller: _emailController,
                            prefixIcon: Icons.mail_outline_rounded,
                            keyboardType: TextInputType.emailAddress,
                            validator: AppValidators.validateEmail,
                          ),
                          SizedBox(height: 20.h),

                          // Phone field
                          AuthTextField(
                            label: 'Phone Number',
                            hintText: 'Enter your phone number',
                            controller: _phoneController,
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: AppValidators.validatePhone,
                          ),
                          SizedBox(height: 20.h),

                          // Password field
                          AuthTextField(
                            label: 'Password',
                            hintText: 'Enter your password',
                            controller: _passwordController,
                            prefixIcon: Icons.lock_outline_rounded,
                            isPassword: true,
                            validator: AppValidators.validatePassword,
                          ),
                          SizedBox(height: 20.h),

                          AuthTextField(
                            label: 'Confirm Password',
                            hintText: 'Confirm your password',
                            controller: _confirmPasswordController,
                            prefixIcon: Icons.lock_outline_rounded,
                            isPassword: true,
                            validator: (value) => AppValidators.validateConfirmPassword(
                              value,
                              _passwordController.text,
                            ),
                          ),
                          SizedBox(height: 30.h),

                          // Register button
                          SizedBox(
                            width: double.infinity,
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed: state is AuthLoading ? null : _handleRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                disabledBackgroundColor: AppColors.textTertiary,
                              ),
                              child: state is AuthLoading
                                  ? SizedBox(
                                      height: 24.h,
                                      width: 24.h,
                                      child: const CircularProgressIndicator(
                                        color: AppColors.background,
                                      ),
                                    )
                                  : Text(
                                      'Create Account',
                                      style: AppStyles.h5.copyWith(
                                        fontSize: 16.sp,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Login link
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Already Have Account ? ',
                                style: AppStyles.h5.copyWith(
                                  fontSize: 14.sp,
                                  color: AppColors.textTertiary,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Login',
                                    style: AppStyles.h5.copyWith(
                                      fontSize: 14.sp,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        context.push('/login');
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 40.h),
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


