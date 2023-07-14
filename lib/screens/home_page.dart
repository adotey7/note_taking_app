import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:note_taking/providers/theme_mode.dart';
import 'package:provider/provider.dart';

import '../icons/custom_icons_icons.dart';

import '../providers/tasks.dart';
import '../widgets/task_card.dart';
import '../widgets/tasks_list.dart';
import './task_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late bool isDark;

  @override
  void initState() {
    super.initState();
    isDark = Provider.of<ToggleTheme>(context, listen: false).themeMode;

    // if (isDark) {
    //   isDark = true;
    // } else {
    //   isDark = false;
    // }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ToggleTheme>(context);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          centerTitle: true,
          title: AutoSizeText(
            'Notes',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isDark = !isDark;
                });
                theme.toggleDarkTheme(isDark);
              },
              icon: theme.themeMode
                  ? const Icon(Icons.sunny)
                  : const Icon(Icons.dark_mode_rounded),
            ),
            IconButton(
              onPressed: () {
                showSearch(context: context, delegate: CustomSearch());
              },
              icon: const Icon(Icons.search_rounded),
            )
          ],
        ),
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 8.0, left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SizedBox(
                    height: double.infinity,
                    child: TasksList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add new note',
          onPressed: () {
            Navigator.of(context).pushNamed(AddTask.routeName);
          },
          child: const Icon(
            CustomIcons.pencil,
          ),
        ),
      ),
    );
  }
}

class CustomSearch extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: Theme.of(context).appBarTheme,
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear_rounded),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(CustomIcons.left_open),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var matchQuery = <String>[];

    // get all tasks
    final taskData = Provider.of<Tasks>(context);
    final tasks = taskData.tasks;

    // get task titles
    final titles = tasks.map((e) => e.title).toList();

    for (var task in titles) {
      if (task!.toLowerCase().contains(query.toLowerCase())) {
        // var newQuery = tasks.firstWhere(
        //     (element) => element.title!.toLowerCase() == query.toLowerCase());
        matchQuery.add(task);
      }
    }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 20, right: 20),
      child: ListView.builder(
        itemBuilder: (context, index) {
          final item = taskData.findByTitle(matchQuery[index].toLowerCase());
          return TaskCard(
            id: item.id,
            title: item.title!,
            date: item.date!,
            onDismissed: (_) {
              Provider.of<Tasks>(context, listen: false)
                  .deleteTask(item.id, item);
            },
          );
        },
        itemCount: matchQuery.length,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var matchQuery = <String>[];

    // get all tasks
    final tasks = Provider.of<Tasks>(context).tasks;

    // get task titles
    final titles = tasks.map((e) => e.title).toList();

    for (var task in titles) {
      if (task!.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(task);
      }
    }
    return matchQuery.isNotEmpty
        ? ListView.builder(
            itemBuilder: (context, index) {
              final item = matchQuery[index];
              return ListTile(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(AddTask.routeName, arguments: tasks[index].id);
                },
                title: Text(item),
              );
            },
            itemCount: matchQuery.length,
          )
        : const Center(
            child: Text('Note is empty.'),
          );
  }
}
