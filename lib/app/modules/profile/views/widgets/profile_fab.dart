import 'package:flutter/material.dart';
import 'package:chartnalyze_apps/app/constants/colors.dart';

class ProfileExpandableFAB extends StatefulWidget {
  const ProfileExpandableFAB({super.key});

  @override
  State<ProfileExpandableFAB> createState() => _ProfileExpandableFABState();
}

class _ProfileExpandableFABState extends State<ProfileExpandableFAB> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_expanded) ...[
          MiniActionButton(
            icon: Icons.description_outlined,
            onPressed: () {
              // TODO: Navigate to add post
              setState(() => _expanded = false);
            },
          ),
          const SizedBox(height: 12),
          MiniActionButton(
            icon: Icons.edit_outlined,
            onPressed: () {
              // TODO: Navigate to edit profile
              setState(() => _expanded = false);
            },
          ),
          const SizedBox(height: 16),
        ],
        FloatingActionButton(
          backgroundColor: AppColors.primaryGreen,
          onPressed: () => setState(() => _expanded = !_expanded),
          child: Icon(_expanded ? Icons.close : Icons.add, color: Colors.white),
        ),
      ],
    );
  }
}

class MiniActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const MiniActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      backgroundColor: AppColors.primaryGreen,
      onPressed: onPressed,
      child: Icon(icon, color: Colors.white),
    );
  }
}
