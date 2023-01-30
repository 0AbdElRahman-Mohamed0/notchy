import 'package:flutter/material.dart';
import 'package:notchy/providers/auth_provider.dart';
import 'package:notchy/ui/screens/auth_screens/login_screen.dart';
import 'package:notchy/ui/screens/edit_profile_screen.dart';
import 'package:notchy/ui/widget/custom_button.dart';
import 'package:notchy/ui/widget/profile_card.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ProfileCard(
                      title: 'Edit Profile Data',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
                CustomButton(
                  onTap: () {
                    context.read<AuthProvider>().logout();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  title: 'Logout',
                  logout: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}