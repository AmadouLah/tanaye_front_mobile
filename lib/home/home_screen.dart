import 'package:flutter/material.dart';
import 'package:tanaye_front_mobile/utils/shared_preference_service.dart';
import 'package:tanaye_front_mobile/home/account_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _fullName = '';
  String _initials = '';
  int _currentTab = 1; // 0: Activities, 1: Home, 2: Account

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prenom = await SharedPreferenceService.getValue('prenom');
    final nom = await SharedPreferenceService.getValue('nom');
    final display = [prenom, nom].where((e) => e.trim().isNotEmpty).join(' ');
    final initials = _computeInitials(prenom, nom);
    setState(() {
      _fullName = display.isEmpty ? 'Utilisateur' : display;
      _initials = initials;
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
      backgroundColor: Colors.white,
      body:
          _currentTab == 1
              ? _buildHome()
              : _currentTab == 2
              ? const AccountScreen()
              : _buildActivities(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildHome() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeader(context)),
        SliverToBoxAdapter(child: const SizedBox(height: 12)),
        SliverToBoxAdapter(child: _buildActionCards(context)),
        SliverToBoxAdapter(child: const SizedBox(height: 16)),
        SliverToBoxAdapter(child: _buildSmallCards(context)),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Widget _buildActivities() {
    return Center(
      child: Text(
        'Activities',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  // Onglet Account déplacé dans AccountScreen

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1DA1F2), Color(0xFF5CC6FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: const [
              Icon(Icons.notifications_none, color: Colors.white),
            ],
          ),
          const SizedBox(height: 8),
          CircleAvatar(
            radius: 34,
            backgroundColor: Colors.white.withOpacity(0.9),
            child: Text(
              _initials,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1B2845),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _fullName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                '5',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.star, size: 16, color: Colors.yellow),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStat('Shipment', '0'),
              _buildStat('Travel', '0'),
              _buildStat('Reception', '0'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildActionCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _ActionCard(
            title: 'Send a package',
            subtitle: 'Find the ideal traveler for your shipment!',
            colors: const [Color(0xFF339AF0), Color(0xFF8AD0FF)],
            asset: 'assets/images/symbol.png',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _ActionCard(
            title: "I'm traveling",
            subtitle: 'Transport packages, earn money.',
            colors: const [Color(0xFF2ECC71), Color(0xFFA6F0C6)],
            asset: 'assets/images/chef_yoa.png',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSmallCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _SmallCard(
              title: 'See travels',
              colors: const [Color(0xFF74C0FC), Color(0xFFD7F0FF)],
              onTap: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SmallCard(
              title: 'See expeditions',
              colors: const [Color(0xFFFFC078), Color(0xFFFFE8CC)],
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return BottomNavigationBar(
      currentIndex: _currentTab,
      onTap: (i) {
        setState(() => _currentTab = i);
        if (i == 0) {
          // Activities
        } else if (i == 1) {
          // Home
        } else if (i == 2) {
          // Account
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.view_list_outlined),
          label: 'Activities',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Account',
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Color> colors;
  final String asset;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.asset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  asset,
                  width: 96,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: -6,
                bottom: -6,
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: onTap,
                    customBorder: const CircleBorder(),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.add, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallCard extends StatelessWidget {
  final String title;
  final List<Color> colors;
  final VoidCallback onTap;

  const _SmallCard({
    required this.title,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        alignment: Alignment.bottomLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
