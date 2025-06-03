import 'package:flutter/material.dart';

class GreetingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const GreetingAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      title: Row(
        children: [
          Image.asset('assets/img/ISM.jpg', width: 30, height: 30),
          const SizedBox(width: 10),
          // Titre au centre (ou à gauche selon besoin)
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Avatar à droite
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black87,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 15,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFF6B00),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    'assets/images/avatar.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
