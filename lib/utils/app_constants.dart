import 'package:flutter/material.dart';

// Models
class TabData {
  final String title;
  final String emptyMessage;
  final IconData emptyIcon;
  final String? actionButtonText;
  final Color? actionButtonColor;
  final VoidCallback? onActionPressed;

  const TabData({
    required this.title,
    required this.emptyMessage,
    required this.emptyIcon,
    this.actionButtonText,
    this.actionButtonColor,
    this.onActionPressed,
  });
}

class BottomNavItemData {
  final IconData icon;
  final String label;
  final bool isSelected;

  const BottomNavItemData({
    required this.icon,
    required this.label,
    required this.isSelected,
  });
}

// Constants
class AppColors {
  static const primary = Color(0xFF2196F3);
  static const primaryDark = Color(0xFF1976D2);
  static const primaryDeep = Color(0xFF0D47A1);
  static const secondary = Color(0xFF4CAF50);
  static const error = Colors.red;
  static const surface = Colors.white;
  static final background = Colors.grey[50]!;
  static final backgroundLight = Colors.grey[100]!;
  static final textPrimary = Colors.black87;
  static final textSecondary = Colors.grey[600]!;
  static final divider = Colors.grey[400]!;
  static final tabIndicator = Colors.black;
  static final emptyStateIcon = Colors.grey[300]!;
}

class AppSizes {
  static const double avatarRadius = 50.0;
  static const double cardBorderRadius = 12.0;
  static const double horizontalPadding = 16.0;
  static const double horizontalPaddingLarge = 24.0;
  static const double verticalSpacing = 20.0;
  static const double verticalSpacingLarge = 40.0;
  static const double menuItemVerticalPadding = 8.0;
  static const double headerHeight = 400.0;
  static const double tabBarHeight = 50.0;
  static const double emptyIconSize = 120.0;
  static const double actionButtonHeight = 50.0;
  static const double bottomNavHeight = 80.0;
  static const double borderRadius = 25.0;
}
