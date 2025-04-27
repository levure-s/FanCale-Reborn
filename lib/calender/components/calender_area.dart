import 'package:fancale/calender/model/calender_model.dart';
import 'package:fancale/calender/model/graphics_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderArea extends StatelessWidget {
  const CalenderArea({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<Calender>();
    final graphics = context.watch<Graphics>();

    return Stack(
      children: [
        TableCalendar(
            locale: 'ja_JP',
            firstDay: DateTime.utc(1997, 8, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: model.focusedDay,
            calendarFormat: model.calendarFormat,
            eventLoader: model.getEventsForDay,
            onFormatChanged: (format) {
              model.changeFormat(format);
            },
            selectedDayPredicate: (day) => isSameDay(model.selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              model.changedDay(selectedDay, focusedDay);
            },
            onPageChanged: (focusedDay) {
              model.changePage(focusedDay);
              graphics.changeCurrentMonth(focusedDay.month);
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return _buildEventsMarker(context, events);
                }
                return null;
              },
            )),
        Align(
            alignment: Alignment.topCenter, // ← これで左右中央寄せ
            child: Padding(
                padding: const EdgeInsets.only(top: 8), // 上からちょっと下げる
                child: TextButton(
                  onPressed: () {
                    final today = DateTime.now(); // 今日の日付を取得
                    model.changedDay(
                        today, today); // changedDayメソッドを呼び出して、今日の日付を渡す
                  },
                  child: Text('今日'), // テキストを表示
                ))),
      ],
    );
  }
}

Widget _buildEventsMarker(BuildContext context, List events) {
  return Positioned(
    right: 5,
    bottom: 5,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primary, // ColorSchemeを使用
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 12.0,
          ),
        ),
      ),
    ),
  );
}
