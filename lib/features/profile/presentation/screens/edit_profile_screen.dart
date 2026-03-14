import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_conatiner.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/app_validators.dart';
import '../../../auth/presentation/widgets/auth_text_field.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
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

  late String _selectedAvatar;
  late ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _profileBloc = context.read<ProfileBloc>();
    final state = _profileBloc.state;
    
    if (state is ProfileLoaded) {
      _nameController = TextEditingController(text: state.userProfile.displayName);
      _phoneController = TextEditingController(text: state.userProfile.phoneNumber);
      _selectedAvatar = state.userProfile.photoUrl ?? _avatarList[0];
    } else {
      _nameController = TextEditingController();
      _phoneController = TextEditingController();
      _selectedAvatar = _avatarList[0];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleUpdate() {
    if (_formKey.currentState!.validate()) {
      _profileBloc.add(
        UpdateProfile(
          displayName: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          photoUrl: _selectedAvatar,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: AppColors.primary, size: 24.sp),
        ),
        title: Text(
          'Pick Avatar',
          style: AppStyles.h4.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
            context.pop();
            _profileBloc.add(const FetchUserProfile());
          } else if (state is ActionError && state.action == 'update_profile') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.red),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Gap(20.h),
                // Large Circular Avatar
                Container(
                  width: 150.w,
                  height: 150.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2.w),
                  ),
                  child: ClipOval(
                    child: Image.asset(_selectedAvatar, fit: BoxFit.cover),
                  ),
                ),
                Gap(40.h),
                // Name Field
                AuthTextField(
                  hintText: 'Name',
                  controller: _nameController,
                  prefixIcon: Icon(Icons.person, color: AppColors.textTertiary),
                  validator: AppValidators.validateName,
                ),
                Gap(20.h),
                // Phone Field
                AuthTextField(
                  hintText: 'Phone number',
                  controller: _phoneController,
                  prefixIcon: Icon(Icons.phone, color: AppColors.textTertiary),
                  validator: AppValidators.validatePhone,
                ),
                Gap(30.h),
                // Reset Password Text
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Reset Password',
                    style: AppStyles.h5.copyWith(color: AppColors.textTertiary),
                  ),
                ),
                Gap(40.h),
                // Avatar Grid in a Container
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16.h,
                      crossAxisSpacing: 16.w,
                    ),
                    itemCount: _avatarList.length,
                    itemBuilder: (context, index) {
                      final avatar = _avatarList[index];
                      final isSelected = _selectedAvatar == avatar;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedAvatar = avatar),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: AppColors.primary, width: 2.w)
                                : null,
                          ),
                          child: ClipOval(
                            child: Image.asset(avatar, fit: BoxFit.cover),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Gap(40.h),
                // Delete Account Button
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle delete confirmation
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    child: Text('Delete Account', style: AppStyles.h5.copyWith(color: AppColors.textPrimary)),
                  ),
                ),
                Gap(16.h),
                // Update Data Button
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: _handleUpdate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    child: Text('Update Data', style: AppStyles.h5.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                  ),
                ),
                Gap(40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
