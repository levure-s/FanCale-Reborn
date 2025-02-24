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
    final model = context.watch<DeleteAccountModel>();

    return AlertDialog(
      title: const Text('アカウントの削除'),
      content: model.isLoading
          ? const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('アカウントを削除しています...'),
                SizedBox(height: 16),
                CircularProgressIndicator(),
              ],
            )
          : const Text('アカウントを削除すると、すべてのデータが完全に削除され、'
              '復元することはできません。\n\n'
              'アカウントを削除してもよろしいですか？'),
      actions: model.isLoading
          ? null // ローディング中はボタンを表示しない
          : [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('キャンセル'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await model.deleteAccount();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  } catch (e) {
                    // エラーハンドリング
                    Navigator.of(context).pop(false);
                  }
                },
                child: const Text('削除する'),
              ),
            ],
    );
  }
}
