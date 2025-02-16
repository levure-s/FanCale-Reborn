import 'package:fancale/edit_profile/edit_form.dart';
import 'package:fancale/edit_profile/edit_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage(this.name, {super.key});
  final String name;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditProfileModel(name),
      child: Scaffold(
        appBar: AppBar(title: const Text('プロフィール編集')),
        body: const Center(child: EditForm()),
      ),
    );
  }
}
