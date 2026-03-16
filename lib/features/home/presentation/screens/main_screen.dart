import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_conatiner.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../browse/presentation/screen/browes_screen.dart';
import '../../../profile/presentation/bloc/profile_state.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../search/presentation/screen/search_screen.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'home_screen.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late final ProfileBloc _profileBloc;

  final List<Widget> _pages = const [
    HomeScreen(),
    SearchScreen(),
    BrowseScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _profileBloc = getIt<ProfileBloc>();
    if (_profileBloc.state is! ProfileLoaded && _profileBloc.state is! ProfileLoading) {
      _profileBloc.add(const FetchUserProfile());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>.value(
      value: _profileBloc,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomBottomNavBar(
                currentIndex: _currentIndex,
                onTap: (index) => setState(() => _currentIndex = index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}