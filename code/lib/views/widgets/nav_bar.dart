import 'package:flutter/material.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget mainItem; // Main item on the left
  final List<Widget> additionalItems; // Additional items on the right

  const NavBar(
      {super.key, required this.mainItem, required this.additionalItems});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          // Main item aligned to the left
          mainItem,
          Spacer(), // Adds space between main item and additional items
          // Additional items aligned to the right
          Row(
            mainAxisSize: MainAxisSize.min,
            children: additionalItems,
          ),
        ],
      ),
      centerTitle: false, // Prevent the title from being centered
      backgroundColor: const Color.fromARGB(255, 181, 189, 193), // Set background color to sky blue
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
