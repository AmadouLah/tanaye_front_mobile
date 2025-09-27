import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_constants.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _getTabsData().length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(child: _buildTabContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.horizontalPaddingLarge),
      child: Row(
        children: [
          Text(
            'Mes Activités',
            style: GoogleFonts.roboto(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = _getTabsData();

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.horizontalPaddingLarge,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: tabs.map((tab) => _buildTab(tab.title)).toList(),
        labelColor: AppColors.surface,
        unselectedLabelColor: AppColors.textPrimary,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          color: AppColors.tabIndicator,
        ),
        labelStyle: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        dividerHeight: 0,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
    );
  }

  Widget _buildTab(String title) {
    return Container(
      height: AppSizes.tabBarHeight,
      alignment: Alignment.center,
      child: Text(title),
    );
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: _getTabsData().map(_buildEmptyState).toList(),
    );
  }

  Widget _buildEmptyState(TabData tabData) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.horizontalPaddingLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          _buildEmptyMessage(tabData.emptyMessage),
          const SizedBox(height: AppSizes.verticalSpacingLarge),
          _buildEmptyIcon(tabData.emptyIcon),
          const Spacer(),
          if (tabData.actionButtonText != null)
            _buildActionButton(
              tabData.actionButtonText!,
              tabData.actionButtonColor!,
              tabData.onActionPressed!,
            ),
          const SizedBox(height: AppSizes.verticalSpacingLarge),
        ],
      ),
    );
  }

  Widget _buildEmptyMessage(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: GoogleFonts.roboto(
          fontSize: 14,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildEmptyIcon(IconData icon) {
    return Icon(
      icon,
      size: AppSizes.emptyIconSize,
      color: AppColors.emptyStateIcon,
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.actionButtonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // Data Configuration
  List<TabData> _getTabsData() {
    return [
      TabData(
        title: 'Expéditions',
        emptyMessage: 'Vous n\'avez aucun colis à expédier',
        emptyIcon: Icons.inventory_2_outlined,
        actionButtonText: 'Commencer mon 1er envoi',
        actionButtonColor: AppColors.primary,
        onActionPressed: () => _handleAction('expedition'),
      ),
      TabData(
        title: 'Voyages',
        emptyMessage: 'Vous n\'avez pas de voyages en cours',
        emptyIcon: Icons.luggage_outlined,
        actionButtonText: 'Commencer mon 1er voyage',
        actionButtonColor: AppColors.secondary,
        onActionPressed: () => _handleAction('voyage'),
      ),
      TabData(
        title: 'Réceptions',
        emptyMessage: 'Vous n\'avez aucun colis à réceptionner',
        emptyIcon: Icons.hourglass_empty_outlined,
        onActionPressed: () => _handleAction('reception'),
      ),
    ];
  }

  // Action Handlers
  void _handleAction(String action) {
    switch (action) {
      case 'expedition':
        // Implémenter la logique pour commencer un envoi
        break;
      case 'voyage':
        // Implémenter la logique pour commencer un voyage
        break;
      case 'reception':
        // Implémenter la logique pour les réceptions
        break;
    }
  }
}
