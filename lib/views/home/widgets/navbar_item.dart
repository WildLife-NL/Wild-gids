import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wildgids/config/theme/asset_icons.dart';
import 'package:wildgids/config/theme/custom_colors.dart';
import 'package:wildgids/views/reporting/reporting.dart';
import 'package:wildlife_api_connection/models/interaction_type.dart';

// ignore: must_be_immutable
class NavbarItem extends StatelessWidget {
  NavbarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.isCenter,
    this.interactionTypes,
  });

  final IconData icon;
  final String label;
  final int index;
  final int selectedIndex;
  final Function(int) onItemTapped;
  final bool isCenter;
  List<InteractionType>? interactionTypes;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!isCenter) {
            onItemTapped(index);
          } else {
            if (interactionTypes != null) {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0)),
                ),
                backgroundColor: CustomColors.light700,
                builder: (context) => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Maak rapportage:",
                            style: TextStyle(
                              fontSize: 20,
                              color: CustomColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.grey,
                              size: 28,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (interactionTypes!.isNotEmpty)
                        _buildInteractionTypes(interactionTypes!)
                      else
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              );
            }
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: isCenter ? 40 : 28,
              color: isCenter || selectedIndex == index
                  ? CustomColors.primary
                  : Colors.black,
            ),
            if (label.isNotEmpty)
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: selectedIndex == index
                      ? CustomColors.primary
                      : Colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionTypes(List<InteractionType> interactionTypes) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 20.0,
        childAspectRatio: 0.8,
      ),
      itemCount: interactionTypes.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            ReportingView.show(
              context: context,
              interactionType: interactionTypes[index],
              initialPage: 0,
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SvgPicture.asset(
                    AssetIcons.getInteractionIcon(interactionTypes[index].name),
                    fit: BoxFit.cover,
                    placeholderBuilder: (BuildContext context) => Container(
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                interactionTypes[index].name,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
