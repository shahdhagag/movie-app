import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
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
      _nameController = TextEditingController(
        text: state.userProfile.displayName,
      );
      _phoneController = TextEditingController(
        text: state.userProfile.phoneNumber,
      );
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

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('', style: AppStyles.h4.copyWith(color: AppColors.primary)),
              Gap(20.h),
              GridView.builder(
                shrinkWrap: true,
                itemCount: _avatarList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16.h,
                  crossAxisSpacing: 16.w,
                ),
                itemBuilder: (context, index) {
                  final avatar = _avatarList[index];
                  final isSelected = _selectedAvatar == avatar;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedAvatar = avatar);
                      Navigator.pop(context);
                    },
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
              Gap(20.h),
            ],
          ),
        );
      },
    );
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
    final blocState = context.watch<ProfileBloc>().state;
    final isDeleting =
        blocState is ActionLoading && blocState.action == 'Deleting account';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.primary,
            size: 27.sp,
          ),
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
            context.go(AppRoutes.profile);
          } else if (state is ActionError && state.action == 'update_profile') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.red,
              ),
            );
          } else if (state is ActionError && state.action == 'delete_account') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.red,
              ),
            );
          } else if (state is LogoutSuccess || state is DeleteAccountSuccess) {
            context.go(AppRoutes.login);
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Gap(20.h),
                // Large Circular Avatar - Trigger BottomSheet
                GestureDetector(
                  onTap: _showAvatarPicker,
                  child: Container(
                    width: 150.w,
                    height: 150.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 1.w),
                    ),
                    child: ClipOval(
                      child: Image.asset(_selectedAvatar, fit: BoxFit.cover),
                    ),
                  ),
                ),
                Gap(40.h),
                // Name Field
                AuthTextField(
                  hintText: 'Name',
                  controller: _nameController,
                  prefixIcon: Image.asset(
                    AppAssets.userIcon,
                    width: 10.w,
                    height: 10.h,
                  ),
                  validator: AppValidators.validateName,
                ),
                Gap(20.h),
                // Phone Field
                AuthTextField(
                  hintText: 'Phone number',
                  controller: _phoneController,
                  prefixIcon: Image.asset(
                    AppAssets.phoneIcon,
                    width: 10.w,
                    height: 10.h,
                  ),
                  validator: AppValidators.validatePhone,
                ),
                Gap(20.h),
                // Reset Password Text
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () async {
                      try {
                        await context.push(AppRoutes.forgotPassword);
                      } catch (_) {
                        if (!mounted) {
                          return;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Unable to open reset password screen right now.',
                            ),
                            backgroundColor: AppColors.red,
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Reset Password',
                      style: AppStyles.h5.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                Gap(310.h),
                // Delete Account Button
                SizedBox(
                  width: double.infinity,
                  height: 60.h,
                  child: ElevatedButton(
                    onPressed: isDeleting
                        ? null
                        : () {
                            _showDeleteAccountConfirmation(context);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                    child: isDeleting
                        ? SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.textPrimary,
                            ),
                          )
                        : Text(
                            'Delete Account',
                            style: AppStyles.h4.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                Gap(16.h),
                // Update Data Button
                SizedBox(
                  width: double.infinity,
                  height: 60.h,
                  child: ElevatedButton(
                    onPressed: _handleUpdate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                    ),
                    child: Text(
                      'Update Data',
                      style: AppStyles.h4.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

  void _showDeleteAccountConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Delete Account',
            style: AppStyles.h3.copyWith(color: AppColors.red),
          ),
          content: Text(
            'This action cannot be undone. Your account and all data will be permanently deleted.',
            style: AppStyles.h5.copyWith(color: AppColors.textTertiary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: AppStyles.h5.copyWith(color: AppColors.textPrimary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                if (_profileBloc.state is! ActionLoading) {
                  _profileBloc.add(const DeleteAccountEvent());
                }
              },
              child: Text(
                'Delete',
                style: AppStyles.h5.copyWith(color: AppColors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
