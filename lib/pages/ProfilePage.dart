import 'package:flutter/material.dart';
import 'package:nfc_reader_flush/api/modules/user.dart';
import 'package:nfc_reader_flush/pages/LoginPage.dart';
import 'package:nfc_reader_flush/util/StorageUtils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void onLogoutPressed() async {
    bool isSuccess = await StorageUtils.clear();
    if (isSuccess) {
      if (!mounted) return; // ✅ tránh dùng context nếu widget đã dispose

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      if (!mounted) return; // ✅ tránh dùng context nếu widget đã dispose

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logout failed, please try again!')));
    }
  }

  Future<void> _loadProfile() async {
    final result = await getProfile();

    if (mounted && result != null && result['user'].isNotEmpty) {
      setState(() {
        user = result['user'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user != null ? '${user!['firstname']} ${user!['lastname']}' : 'Loading...',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user != null ? user!['email'] : 'Loading...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () {
                      // Edit profile
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Edit profile feature coming soon!')));
                    },
                    child: const Text('Edit Profile'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Security Settings
            const Text(
              'Security Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _buildSettingItem(
              context,
              icon: Icons.notifications,
              title: 'Card Activity Alerts',
              subtitle: 'Get notified of new transactions',
              isSwitch: true,
              initialValue: true,
            ),

            _buildSettingItem(
              context,
              icon: Icons.security,
              title: 'RFID Protection Reminders',
              subtitle: 'Receive reminders about card security',
              isSwitch: true,
              initialValue: true,
            ),

            _buildSettingItem(
              context,
              icon: Icons.fingerprint,
              title: 'Biometric Authentication',
              subtitle: 'Use fingerprint or face ID',
              isSwitch: true,
              initialValue: false,
            ),

            const Divider(height: 32),

            // App Settings
            const Text(
              'App Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _buildSettingItem(
              context,
              icon: Icons.language,
              title: 'Language',
              subtitle: 'English',
              isSwitch: false,
            ),

            _buildSettingItem(
              context,
              icon: Icons.brightness_6,
              title: 'Theme',
              subtitle: 'Light',
              isSwitch: false,
            ),

            const Divider(height: 32),

            // About & Help
            const Text(
              'About & Help',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _buildSettingItem(
              context,
              icon: Icons.help_outline,
              title: 'Help Center',
              subtitle: 'Get help with the app',
              isSwitch: false,
            ),

            _buildSettingItem(
              context,
              icon: Icons.info_outline,
              title: 'About RFID Cards',
              subtitle: 'Learn about card technology',
              isSwitch: false,
            ),

            _buildSettingItem(
              context,
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              isSwitch: false,
            ),

            const SizedBox(height: 24),

            Center(
              child: TextButton.icon(
                onPressed: () {
                  // Logout
                  onLogoutPressed();
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: Text(
                'App Version 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSwitch,
    bool initialValue = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: isSwitch
          ? Switch(
              value: initialValue,
              onChanged: (value) {
                // Handle switch change
              },
              activeColor: Theme.of(context).primaryColor,
            )
          : const Icon(Icons.chevron_right),
      onTap: isSwitch
          ? null
          : () {
              // Handle tap
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$title settings coming soon!')));
            },
    );
  }
}
