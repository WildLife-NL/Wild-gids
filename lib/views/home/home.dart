import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:wildgids/config/theme/size_setter.dart';
import 'package:wildgids/services/interaction_type.dart';
import 'package:wildgids/views/home/widgets/navbar_item.dart';
import 'package:wildgids/views/notifications/notifications.dart';
import 'package:wildgids/views/map/map.dart';
import 'package:wildgids/views/profile/profile.dart';
import 'package:wildgids/views/reporting/widgets/manager/location.dart';
import 'package:wildgids/views/reporting/widgets/snackbar_with_progress_bar.dart';
import 'package:wildgids/views/wiki/wiki.dart';
import 'package:wildgids/views/home/widgets/bottom_navigation_bar_indicator.dart';
import 'package:wildlife_api_connection/models/interaction.dart';
import 'package:wildlife_api_connection/models/interaction_type.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    this.interaction,
  });

  final Interaction? interaction;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selectedIndex = 0;
  List<InteractionType> _interactionTypes = [];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    LocationManager().requestLocationAccess(context);
    _getInteractionTypes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (widget.interaction != null &&
          widget.interaction!.questionnaire != null) {
        SnackBarWithProgress.show(
          context: context,
          interaction: widget.interaction!,
          questionnaire: widget.interaction!.questionnaire!,
        );
      }
    });
  }

  Future<void> _getInteractionTypes() async {
    try {
      var interactionTypesData =
          await InteractionTypeService().getAllInteractionTypes();
      interactionTypesData = interactionTypesData
          .where((interactionType) =>
              interactionType.name.toLowerCase() != 'schademelding')
          .toList();
      setState(() {
        _interactionTypes = interactionTypesData;
      });
    } catch (e) {
      debugPrint("Error fetching interaction types: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: selectedIndex,
            children: const [
              WikiView(),
              MapView(),
              NotificationsView(),
              ProfileView(),
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
            child: BottomAppBar(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              height: SizeSetter.getBottomNavigationBarHeight(),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  NavbarItem(
                    icon: Icons.book,
                    label: "Wiki",
                    index: 0,
                    selectedIndex: selectedIndex,
                    onItemTapped: onItemTapped,
                    isCenter: false,
                  ),
                  NavbarItem(
                    icon: Icons.map,
                    label: "Map",
                    index: 1,
                    selectedIndex: selectedIndex,
                    onItemTapped: onItemTapped,
                    isCenter: false,
                  ),
                  NavbarItem(
                    icon: Icons.add_box,
                    label: "",
                    index: -1,
                    selectedIndex: selectedIndex,
                    onItemTapped: onItemTapped,
                    isCenter: true,
                    interactionTypes: _interactionTypes,
                  ),
                  NavbarItem(
                    icon: Icons.history,
                    label: "Meldingen",
                    index: 2,
                    selectedIndex: selectedIndex,
                    onItemTapped: onItemTapped,
                    isCenter: false,
                  ),
                  NavbarItem(
                    icon: Icons.person,
                    label: "Account",
                    index: 3,
                    selectedIndex: selectedIndex,
                    onItemTapped: onItemTapped,
                    isCenter: false,
                  ),
                ],
              ),
            ),
          ),
          BottomNavigationBarIndicator(
            selectedIndex:
                selectedIndex >= 2 ? selectedIndex + 1 : selectedIndex,
            indicatorWidth: MediaQuery.of(context).size.width / 5,
          ),
        ],
      ),
    );
  }
}
