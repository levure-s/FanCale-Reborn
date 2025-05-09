import 'package:fancale/add_anniversary/add_anniversary_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddAnniversary extends StatelessWidget {
  final DateTime? selectedDay;
  const AddAnniversary({super.key, required this.selectedDay});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final TextEditingController yearController =
        TextEditingController(text: selectedDay?.year.toString());

    return ChangeNotifierProvider(
      create: (_) => AddAnniversaryModel(), // 変更したモデルを使う
      child: AlertDialog(
        title: const Text('記念日を入力してください'), // 記念日メモに変更
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
            )
          ],
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('キャンセル')),
          Consumer<AddAnniversaryModel>(builder: (context, model, child) {
            return TextButton(
                onPressed: () async {
                  try {
                    await model.addAnniversary(selectedDay, controller.text,
                        yearController.text); // 変更したメソッド名
                  } catch (e) {
                    final snackBar = SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(e.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } finally {
                    Navigator.pop(context);
                  }
                },
                child: const Text('OK'));
          })
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
