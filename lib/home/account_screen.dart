import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tanaye_front_mobile/utils/shared_preference_service.dart';

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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey.shade200,
                  child: Text(
                    _initials,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _fullName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _email,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Confidentialité'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Paramètres'),
              onTap: () {},
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text('Se déconnecter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await SharedPreferenceService.clearUserData();
    Get.offAllNamed('/login');
  }
}


