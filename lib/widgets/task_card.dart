import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:note_taking/screens/task_screen.dart';

import '../icons/custom_icons_icons.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    required this.id,
    required this.title,
    required this.date,
    required this.onDismissed,
    super.key,
  });
  final DateTime date;
  final String title;
  final int id;
  final void Function(DismissDirection)? onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: onDismissed,
      background: Container(
        padding: const EdgeInsets.only(right: 30),
        alignment: Alignment.centerRight,
        // margin: const EdgeInsets.only(top: 10, bottom: 10),
        color: Colors.red,
        child: const Icon(CustomIcons.trash),
      ),
      child: InkWell(
        // radius: 20,
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).pushNamed(AddTask.routeName, arguments: id);
        },
        child: Container(
          // margin: const EdgeInsets.only(top: 10, bottom: 10),
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 10,
          ),
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFF899294).withOpacity(0.2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(
                DateFormat('dd/MM/y').format(date),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              AutoSizeText(
                title,
                style: Theme.of(context).textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
