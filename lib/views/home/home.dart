import 'package:flutter/material.dart';
import 'package:wildgids/config/theme/custom_theme.dart';
import 'package:wildgids/config/theme/size_setter.dart';
import 'package:wildgids/services/animal.dart';
import 'package:wildgids/views/map/map.dart';
import 'package:wildgids/views/profile/profile.dart';
import 'package:wildgids/views/wiki/wiki.dart';
import 'package:wildgids/views/home/widgets/bottom_navigation_bar_indicator.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: selectedIndex,
            children: [
              MapView(animalService: AnimalService()),
              const WikiView(),
              const ProfileView(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Stack(
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              splashFactory: NoSplash.splashFactory,
            ),
            child: SizedBox(
              height: SizeSetter.getBottomNavigationBarHeight(),
              child: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    key: Key('home_view_button'),
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    key: Key('wiki_view_button'),
                    icon: Icon(Icons.book),
                    label: 'Wiki',
                  ),
                  BottomNavigationBarItem(
                    key: Key('profile_view_button'),
                    icon: Icon(Icons.person),
                    label: 'Profiel',
                  ),
                ],
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Theme.of(context).primaryColor,
                unselectedItemColor: Colors.black,
                backgroundColor: Colors.white,
                selectedFontSize: SizeSetter.getBodySmallSize(),
                unselectedFontSize: SizeSetter.getBodySmallSize(),
                currentIndex: selectedIndex,
                unselectedLabelStyle:
                    CustomTheme(context).themeData.textTheme.bodySmall,
                selectedLabelStyle:
                    CustomTheme(context).themeData.textTheme.bodySmall,
                onTap: onItemTapped,
              ),
            ),
          ),
          BottomNavigationBarIndicator(
            selectedIndex: selectedIndex,
            indicatorWidth: 55,
          ),
        ],
      ),
    );
  }
}
