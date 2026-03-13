import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/di/injection_conatiner.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_button.dart';
import '../widgets/tab_indicator.dart';
import '../widgets/movie_grid_widget.dart';
import '../widgets/empty_state_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    _profileBloc = getIt<ProfileBloc>();
    _profileBloc.add(const FetchUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>.value(
      value: _profileBloc,
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            // Navigate to login screen on successful logout
            context.go(AppRoutes.login);
          } else if (state is DeleteAccountSuccess) {
            // Navigate to login screen after successful account deletion
            context.go(AppRoutes.login);
          } else if (state is ProfileError) {
            // Show error snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: AppColors.red, size: 60.sp),
                    Gap(16.h),
                    Text(
                      state.message,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

          if (state is ProfileLoaded) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Header with padding
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                    child: ProfileHeader(
                      userProfile: state.userProfile,
                      watchListCount: state.watchList.length,
                      historyCount: state.history.length,
                    ),
                  ),

                  // Action Buttons
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        // Edit Profile Button
                        ProfileButton(
                          label: 'Edit Profile',
                          onPressed: () {
                            // TODO: Navigate to edit profile
                          },
                          backgroundColor: AppColors.grey,
                          textColor: AppColors.textPrimary,
                        ),
                        Gap(12.h),

                        // Update Data Button
                        ProfileButton(
                          label: 'Update Data',
                          onPressed: () {
                            // TODO: Navigate to update data
                          },
                          backgroundColor: AppColors.grey,
                          textColor: AppColors.textPrimary,
                        ),
                        Gap(12.h),

                        // Exit (Logout) Button
                        ProfileButton(
                          label: 'Exit (Logout)',
                          onPressed: () {
                            _showLogoutConfirmation(context);
                          },
                          backgroundColor: AppColors.grey,
                          textColor: AppColors.textPrimary,
                          icon: Icons.exit_to_app_rounded,
                        ),
                        Gap(12.h),

                        // Delete Account Button
                        ProfileButton(
                          label: 'Delete Account',
                          onPressed: () {
                            _showDeleteAccountConfirmation(context);
                          },
                          backgroundColor: AppColors.red.withOpacity(0.2),
                          textColor: AppColors.red,
                          icon: Icons.delete_rounded,
                        ),
                      ],
                    ),
                  ),

                  Gap(32.h),

                  // Tabs Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TabIndicator(
                          label: 'Watch List',
                          icon: Icons.bookmark,
                          isSelected: state.selectedTabIndex == 0,
                          onTap: () {
                            context.read<ProfileBloc>().add(const SwitchTabEvent(0));
                          },
                        ),
                        TabIndicator(
                          label: 'History',
                          icon: Icons.history,
                          isSelected: state.selectedTabIndex == 1,
                          onTap: () {
                            context.read<ProfileBloc>().add(const SwitchTabEvent(1));
                          },
                        ),
                      ],
                    ),
                  ),

                  Gap(24.h),

                  // Content based on selected tab
                  SizedBox(
                    height: 500.h,
                    child: state.selectedTabIndex == 0
                        ? _buildWatchListTab(state)
                        : _buildHistoryTab(state),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: EmptyStateWidget(
              icon: Icons.person_outline,
              message: 'No profile data available',
            ),
          );
          },
        ),
      ),
    );
  }

  Widget _buildWatchListTab(ProfileLoaded state) {
    if (state.watchList.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.bookmark_outline,
        message: 'No movies in your watch list yet',
      );
    }

    return MovieGridWidget(
      movies: state.watchList,
      onMovieTap: (movie) {
        context.push(
          AppRoutes.movieDetails,
          extra: movie.movieId,
        );
      },
    );
  }

  Widget _buildHistoryTab(ProfileLoaded state) {
    if (state.history.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.history,
        message: 'No watched movies in your history',
      );
    }

    return MovieGridWidget(
      movies: state.history,
      onMovieTap: (movie) {
        context.push(
          AppRoutes.movieDetails,
          extra: movie.movieId,
        );
      },
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.grey,
          title: Text(
            'Logout',
            style: AppStyles.h3,
          ),
          content: Text(
            'Are you sure you want to logout?',
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
                context.read<ProfileBloc>().add(const LogoutEvent());
              },
              child: Text(
                'Logout',
                style: AppStyles.h5.copyWith(color: AppColors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.grey,
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
                context.read<ProfileBloc>().add(const DeleteAccountEvent());
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
