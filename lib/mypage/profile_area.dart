import 'package:fancale/delete_account_dialog/delete_account_dialog.dart';
import 'package:fancale/mypage/my_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileArea extends StatelessWidget {
  const ProfileArea({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MyModel>();

    if (model.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            model.name ?? '名前なし',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(model.email ?? 'メールアドレスなし'),
          const SizedBox(height: 8),
          TextButton(
              onPressed: () async {
                bool isSuccess = false;
                try {
                  await model.logout();
                  isSuccess = true;
                } finally {
                  if (isSuccess) {
                    Navigator.of(context).pop();
                  }
                }
              },
              child: const Text('ログアウト')),
          TextButton(
              onPressed: () async {
                final bool? result = await DeleteAccountDialog.show(context);
                if (result == true) {
                  Navigator.of(context).pop(); // プロフィール画面を閉じる
                }
              },
              child: const Text('アカウントを削除')),
        ],
      ),
    );
  }
}
