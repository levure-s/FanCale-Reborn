import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './delete_account_model.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ChangeNotifierProvider(
        create: (_) => DeleteAccountModel(),
        child: const DeleteAccountDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('アカウントの削除'),
      content: const Text('アカウントを削除すると、すべてのデータが完全に削除され、'
          '復元することはできません。\n\n'
          'アカウントを削除してもよろしいですか？'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('キャンセル'),
        ),
        Consumer<DeleteAccountModel>(
          builder: (context, model, child) {
            return TextButton(
              onPressed: () async {
                try {
                  await model.deleteAccount();
                  Navigator.of(context).pop(true);
                } catch (e) {
                  // エラーハンドリング
                  Navigator.of(context).pop(false);
                }
              },
              child: const Text('削除する'),
            );
          },
        ),
      ],
    );
  }
}
