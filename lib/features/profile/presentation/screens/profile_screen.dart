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
import '../widgets/empty_state_widget.dart';
import '../widgets/movie_grid_widget.dart';
import '../widgets/profile_header.dart';
import '../widgets/tab_indicator.dart';

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
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            context.go(AppRoutes.login);
          }
          if (state is DeleteAccountSuccess) {
            context.go(AppRoutes.login);
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          }

          if (state is ProfileError) {
            return SafeArea(
              child: Scaffold(
                body: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.red,
                          size: 60,
                        ),
                        Gap(16.h),
                        Text(
                          state.message,
                          style: AppStyles.h5.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 14.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Gap(24.h),
                        ElevatedButton(
                          onPressed: () {
                            _profileBloc.add(const FetchUserProfile());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          if (state is ProfileLoaded) {
            return Scaffold(
              body: Column(
                children: [
                  Gap(40.h),
                  // Header section
                  ProfileHeader(
                    userProfile: state.userProfile,
                    watchListCount: state.watchList.length,
                    historyCount: state.history.length,
                  ),

                  Gap(24.h),

                  // Action Buttons Row
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 17.w),
                    child: Row(
                      children: [
                        // Edit Profile Button
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 60.h,

                            child: ElevatedButton(
                              onPressed: () {
                                context.push(AppRoutes.editProfile);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                              ),
                              child: Text(
                                'Edit Profile',
                                style: AppStyles.h4.copyWith(
                                  fontSize: 20.sp,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Gap(12.w),
                        // Exit Button
                        Expanded(
                          child: SizedBox(
                            height: 60.h,
                            child: ElevatedButton(
                              onPressed: () {
                                _showLogoutConfirmation(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Exit',
                                    style: AppStyles.h4.copyWith(
                                      fontSize: 20.sp,
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Gap(10.w),
                                  Icon(
                                    Icons.logout,
                                    color: AppColors.textPrimary,
                                    size: 20.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Gap(32.h),

                  // Tabs Section
                  Row(
                    children: [
                      TabIndicator(
                        label: 'Watch List',
                        icon: Icons.list,
                        isSelected: state.selectedTabIndex == 0,
                        onTap: () {
                          context.read<ProfileBloc>().add(
                            const FetchUserProfile(
                              selectedTabIndex: 0,
                              verifyFreshness: true,
                            ),
                          );
                        },
                      ),
                      TabIndicator(
                        label: 'History',
                        icon: Icons.folder,
                        isSelected: state.selectedTabIndex == 1,
                        onTap: () {
                          context.read<ProfileBloc>().add(
                            const FetchUserProfile(
                              selectedTabIndex: 1,
                              verifyFreshness: true,
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  // Content based on selected tab
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: AppColors.background,
                      child: state.selectedTabIndex == 0
                          ? _buildWatchListTab(state)
                          : _buildHistoryTab(state),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Scaffold(body: Center(child: EmptyStateWidget()));
        },
      ),
    );
  }

  Widget _buildWatchListTab(ProfileLoaded state) {
    if (state.watchList.isEmpty) {
      return const EmptyStateWidget();
    }

    return MovieGridWidget(
      movies: state.watchList,
      onMovieTap: (movie) {
        context.push(AppRoutes.movieDetails, extra: movie.movieId).then((_) {
          _profileBloc.add(
            const FetchUserProfile(selectedTabIndex: 0, verifyFreshness: true),
          );
        });
      },
    );
  }

  Widget _buildHistoryTab(ProfileLoaded state) {
    if (state.history.isEmpty) {
      return const EmptyStateWidget();
    }

    return MovieGridWidget(
      movies: state.history,
      onMovieTap: (movie) {
        context.push(AppRoutes.movieDetails, extra: movie.movieId).then((_) {
          _profileBloc.add(
            const FetchUserProfile(selectedTabIndex: 1, verifyFreshness: true),
          );
        });
      },
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text('Logout', style: AppStyles.h3),
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
                _profileBloc.add(const LogoutEvent());
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
}
