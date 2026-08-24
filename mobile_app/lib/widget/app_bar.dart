import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget{

  final String title;

  const AppBarWidget({
    super.key,
    required this.title,
    });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),

      actions: [
        IconButton(
          onPressed: () {
            // Open notifications
          },
          icon: const Icon(
            Icons.notifications_none_rounded,
          ),
        ),

        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize =>const Size.fromHeight(kToolbarHeight);

}