import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../providers/tasks.dart';
import '../widgets/task_card.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<Tasks>(context);

    return tasks.tasks.isNotEmpty
        ? ListView.builder(
            itemBuilder: (context, index) {
              final item = tasks.tasks[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0, top: 10),
                child: TaskCard(
                  id: item.id,
                  title: item.title!,
                  date: item.date!,
                  onDismissed: (_) {
                    tasks.deleteTask(item.id, item);
                  },
                ),
              );
            },
            itemCount: tasks.tasks.length,
          )
        : Center(
            child: Lottie.asset(
              'assets/data.json',
              repeat: false,
            ),
          );
  }
}
