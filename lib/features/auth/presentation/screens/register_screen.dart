import 'package:carousel_slider/carousel_slider.dart';
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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

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

  final List<String> _avatarList = [
    AppAssets.avatar1,
    AppAssets.avatar2,
    AppAssets.avatar3,
    AppAssets.avatar4,
    AppAssets.avatar5,
    AppAssets.avatar6,
    AppAssets.avatar7,
    AppAssets.avatar8,
    AppAssets.avatar9,
  ];

  int _selectedAvatarIndex = 0;

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
              photoUrl: _avatarList[_selectedAvatarIndex],
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
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: AppColors.primary,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Center(
                      child: Text(
                        'Register',
                        style: AppStyles.h2.copyWith(
                          fontSize: 16.sp,
                          color: AppColors.primary
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Center(
                            child: Column(
                              children: [
                                SizedBox(height: 16.h),
                                CarouselSlider(
                                  options: CarouselOptions(
                                    height: 140.h,
                                    viewportFraction: 0.35,
                                    enlargeCenterPage: true,
                                    enableInfiniteScroll: true,
                                    scrollDirection: Axis.horizontal,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _selectedAvatarIndex = index;
                                      });
                                    },
                                  ),
                                  items: _avatarList.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    String avatar = entry.value;
                                    bool isSelected = index == _selectedAvatarIndex;

                                    return Container(
                                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: isSelected
                                            ? Border.all(
                                                color: AppColors.primary,
                                                width: 3.w,
                                              )
                                            : null,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedAvatarIndex = index;
                                          });
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100.r),
                                          child: Image.asset(
                                            avatar,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(height: 14.h),

                                Text(
                                  'Avatar',
                                  style: AppStyles.h5.copyWith(fontSize: 14.sp),
                                ),

                                SizedBox(height: 20.h),
                              ],
                            ),
                          ),

                          AuthTextField(
                            hintText: 'Name',
                            controller: _nameController,
                             prefixIcon: Image.asset(AppAssets.nameIcon,width: 3.w,height: 25.h),
                            validator: AppValidators.validateName,
                          ),
                          SizedBox(height: 20.h),

                          AuthTextField(
                            hintText: 'Email',
                            controller: _emailController,
                            prefixIcon: Image.asset(AppAssets.emailIcon,width: 3.w,height: 25.h,),
                            keyboardType: TextInputType.emailAddress,
                            validator: AppValidators.validateEmail,
                          ),
                          SizedBox(height: 20.h),

                          AuthTextField(
                            hintText: ' Phone number',
                            controller: _phoneController,
                            prefixIcon: Image.asset(AppAssets.phoneIcon,width: 3.w,height: 25.h,),
                            keyboardType: TextInputType.phone,
                            validator: AppValidators.validatePhone,
                          ),
                          SizedBox(height: 20.h),

                          AuthTextField(
                            hintText: ' Password',
                            controller: _passwordController,
                           prefixIcon: Image.asset(AppAssets.passwordIcon,width: 3.w,height: 25.h),
                            isPassword: true,
                            validator: AppValidators.validatePassword,
                          ),
                          SizedBox(height: 20.h),

                          AuthTextField(
                            hintText: 'Confirm Password',
                            controller: _confirmPasswordController,
                           prefixIcon: Image.asset(AppAssets.passwordIcon,width: 3.w,height: 25.h),
                            isPassword: true,
                            validator: (value) => AppValidators.validateConfirmPassword(
                              value,
                              _passwordController.text,
                            ),
                          ),
                          SizedBox(height: 30.h),

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


