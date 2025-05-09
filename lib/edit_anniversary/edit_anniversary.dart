import 'package:fancale/edit_anniversary/edit_anniversary_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditAnniversary extends StatelessWidget {
  final DateTime? selectedDay;
  final String title; // 記念日のタイトル
  final String year; // 記念日の年
  final String id; // 記念日のID
  const EditAnniversary({
    super.key,
    required this.selectedDay,
    required this.title,
    required this.year,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: title);
    final TextEditingController yearController =
        TextEditingController(text: year);

    return ChangeNotifierProvider(
      create: (_) => EditAnniversaryModel(), // 編集用でも同じモデルを使う
      child: AlertDialog(
        title: const Text('記念日を編集してください'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: controller),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: yearController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: '年',
                      hintText: '手入力 or ▼ボタンで選択',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  onPressed: () => _showYearPicker(context, yearController),
                ),
                TextButton(
                  onPressed: () {
                    yearController.text = ''; // 年を空にする
                  },
                  child: const Text('年を指定しない'),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('キャンセル'),
          ),
          Consumer<EditAnniversaryModel>(
            builder: (context, model, child) {
              return TextButton(
                onPressed: () async {
                  try {
                    await model.updateAnniversary(
                      id, // 記念日ID
                      selectedDay,
                      controller.text, // 新しいタイトル
                      yearController.text, // 新しい年
                    );
                  } catch (e) {
                    final snackBar = SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(e.toString()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } finally {
                    Navigator.pop(context);
                  }
                },
                child: const Text('保存'),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showYearPicker(
      BuildContext context, TextEditingController yearController) {
    final now = DateTime.now().year;
    final int startYear = 1;
    final itemHeight = 48.0;
    final initialIndex = int.tryParse(yearController.text) ?? now;
    final scrollIndex = (initialIndex - startYear).clamp(0, now - startYear);
    final controller = FixedExtentScrollController(initialItem: scrollIndex);

    int selectedIndex = scrollIndex;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  // グラデーションレイヤー
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                          stops: [0, 0.3, 0.7, 1],
                        ),
                      ),
                    ),
                  ),
                  // リストホイール
                  ListWheelScrollView.useDelegate(
                    controller: controller,
                    itemExtent: itemHeight,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      setState(() => selectedIndex = index);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        final year = startYear + index;
                        final isCenter = (index == selectedIndex);
                        return GestureDetector(
                          onTap: () {
                            if (isCenter) {
                              yearController.text = year.toString();
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              '$year年',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: isCenter ? Colors.black : Colors.grey,
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: now - startYear + 1,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
