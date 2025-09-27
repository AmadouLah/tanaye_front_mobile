import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:tanaye_front_mobile/utils/shared_preference_service.dart';
import '../utils/app_constants.dart';

// Models
class MenuItemData {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? subtitleColor;
  final Widget? trailing;
  final Color? iconColor;
  final Color? titleColor;
  final VoidCallback onTap;

  const MenuItemData({
    required this.icon,
    required this.title,
    this.subtitle,
    this.subtitleColor,
    this.trailing,
    this.iconColor,
    this.titleColor,
    required this.onTap,
  });
}

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _fullName = '';
  String _initials = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prenom = await SharedPreferenceService.getValue('prenom');
    final nom = await SharedPreferenceService.getValue('nom');
    final email = await SharedPreferenceService.getValue('email');
    final display = [prenom, nom].where((e) => e.trim().isNotEmpty).join(' ');
    setState(() {
      _fullName = display.isEmpty ? 'Utilisateur' : display;
      _initials = _computeInitials(prenom, nom);
      _email = email;
    });
  }

  String _computeInitials(String a, String b) {
    final first = a.trim().isNotEmpty ? a.trim()[0] : '';
    final second = b.trim().isNotEmpty ? b.trim()[0] : '';
    final result = (first + second).toUpperCase();
    return result.isEmpty ? 'U' : result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [_buildHeader(), Expanded(child: _buildContent())],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: AppSizes.headerHeight,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
            AppColors.primaryDeep,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAvatar(),
            const SizedBox(height: 16),
            _buildUserName(),
            const SizedBox(height: 8),
            _buildRating(),
            const SizedBox(height: 32),
            _buildStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: AppSizes.avatarRadius,
      backgroundColor: Colors.white.withValues(alpha: 0.3),
      child: Text(
        _initials,
        style: GoogleFonts.roboto(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.surface,
        ),
      ),
    );
  }

  Widget _buildUserName() {
    return Column(
      children: [
        Text(
          _fullName,
          style: GoogleFonts.roboto(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.surface,
          ),
        ),
        if (_email.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            _email,
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '5',
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.surface,
          ),
        ),
        const Icon(Icons.star, color: Colors.amber, size: 20),
      ],
    );
  }

  Widget _buildStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatCard('0,0€', 'Gains voyages'),
        Container(
          height: 60,
          width: 1,
          color: Colors.white.withValues(alpha: 0.3),
        ),
        _buildStatCard('0,0€', 'Gains parrainage'),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.roboto(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.surface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.roboto(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.horizontalPadding,
          vertical: AppSizes.verticalSpacing,
        ),
        child: Column(children: _getMenuItems().map(_buildMenuItem).toList()),
      ),
    );
  }

  List<MenuItemData> _getMenuItems() {
    return [
      MenuItemData(
        icon: Icons.verified_outlined,
        title: 'Statut du compte',
        subtitle: 'Compte non vérifié',
        subtitleColor: AppColors.textSecondary,
        onTap: () => _handleMenuTap('status'),
      ),
      MenuItemData(
        icon: Icons.people_outline,
        title: 'Code parrainage',
        trailing: Text(
          'Partager',
          style: GoogleFonts.roboto(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () => _handleMenuTap('referral'),
      ),
      MenuItemData(
        icon: Icons.credit_card_outlined,
        title: 'Gérer mes paiements',
        onTap: () => _handleMenuTap('payments'),
      ),
      MenuItemData(
        icon: Icons.privacy_tip_outlined,
        title: 'Confidentialité',
        onTap: () => _handleMenuTap('privacy'),
      ),
      MenuItemData(
        icon: Icons.settings_outlined,
        title: 'Paramètres',
        onTap: () => _handleMenuTap('settings'),
      ),
      MenuItemData(
        icon: Icons.share_outlined,
        title: 'Partager l\'application',
        onTap: () => _handleMenuTap('share'),
      ),
      MenuItemData(
        icon: Icons.language_outlined,
        title: 'Changer de langue',
        onTap: () => _handleMenuTap('language'),
      ),
      MenuItemData(
        icon: Icons.lightbulb_outline,
        title: 'Améliorer l\'application',
        onTap: () => _handleMenuTap('feedback'),
      ),
      MenuItemData(
        icon: Icons.email_outlined,
        title: 'Nous contacter',
        onTap: () => _handleMenuTap('contact'),
      ),
      MenuItemData(
        icon: Icons.security_outlined,
        title: 'Sécurité & confidentialité',
        onTap: () => _handleMenuTap('security'),
      ),
      MenuItemData(
        icon: Icons.logout,
        title: 'Se déconnecter',
        iconColor: AppColors.error,
        titleColor: AppColors.error,
        onTap: _logout,
      ),
    ];
  }

  Widget _buildMenuItem(MenuItemData item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.horizontalPadding,
          vertical: AppSizes.menuItemVerticalPadding,
        ),
        leading: Icon(
          item.icon,
          color: item.iconColor ?? AppColors.textSecondary,
          size: 24,
        ),
        title: Text(
          item.title,
          style: GoogleFonts.roboto(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: item.titleColor ?? Colors.black87,
          ),
        ),
        subtitle:
            item.subtitle != null
                ? Text(
                  item.subtitle!,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: item.subtitleColor ?? AppColors.textSecondary,
                  ),
                )
                : null,
        trailing:
            item.trailing ??
            Icon(Icons.arrow_forward_ios, color: AppColors.divider, size: 16),
        onTap: item.onTap,
      ),
    );
  }

  // Action handlers
  void _handleMenuTap(String action) {
    switch (action) {
      case 'status':
        // Implémenter la logique pour le statut du compte
        break;
      case 'referral':
        // Implémenter la logique pour le code parrainage
        break;
      case 'payments':
        // Implémenter la logique pour les paiements
        break;
      case 'privacy':
        // Implémenter la logique pour la confidentialité
        break;
      case 'settings':
        // Implémenter la logique pour les paramètres
        break;
      case 'share':
        // Implémenter la logique pour partager l'application
        break;
      case 'language':
        // Implémenter la logique pour changer de langue
        break;
      case 'feedback':
        // Implémenter la logique pour les améliorations
        break;
      case 'contact':
        // Implémenter la logique pour nous contacter
        break;
      case 'security':
        // Implémenter la logique pour la sécurité
        break;
    }
  }

  Future<void> _logout() async {
    await SharedPreferenceService.clearUserData();
    Get.offAllNamed('/login');
  }
}
