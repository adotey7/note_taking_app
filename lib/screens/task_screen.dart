import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:note_taking/models/task.dart';
import 'package:provider/provider.dart';

import '../providers/tasks.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});
  static const routeName = '/add-task';

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _description;
  var _showChecker = false;
  var _rebuilt = true;
  var _existingTask = <String, String>{};
  var _task = Task();
  int? _id;

  @override
  void didChangeDependencies() {
    if (_rebuilt) {
      _id = ModalRoute.of(context)?.settings.arguments as int?;
      if (_id != null) {
        final task = Provider.of<Tasks>(context, listen: false).findById(_id!);
        _existingTask = {
          'title': task.title!,
          'description': task.body!,
        };
        _title = _existingTask['title'];
        _description = _existingTask['description'];
        
      }
    }
    _rebuilt = false;
    super.didChangeDependencies();
  }

  // Check if fields are empty
  void _checker() {
    if (_description != null &&
        _description!.isNotEmpty &&
        _title != null &&
        _title!.isNotEmpty) {
      setState(() {
        _showChecker = true;
      });
    } else {
      setState(() {
        _showChecker = false;
      });
    }
  }

  // Submit task
  void _onSubmit(String title, String description, DateTime date) {
    if (_id == null) {
      title = title.trimRight();
      _task.title = title;
      _task.body = description;
      _task.date = date;
      Provider.of<Tasks>(context, listen: false).addTask(_task);
      Navigator.of(context).pop();
    } else {
      _task.id = _id!;
      _task.title = title;
      _task.body = description;
      _task.date = date;
      Provider.of<Tasks>(context, listen: false).updateTask(_id!, _task);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: AutoSizeText(
          _id == null ? 'New Note' : _existingTask['title']!,
          style: Theme.of(context).textTheme.titleLarge,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            onPressed: _showChecker
                ? () => _onSubmit(
                      _title!,
                      _description!,
                      DateTime.now(),
                    )
                : null,
            iconSize: 28,
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 8.0, left: 20, right: 20),
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        height: MediaQuery.of(context).size.height * 0.89,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF899294).withOpacity(0.2),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const CurrentDay(),
                TextFormField(
                  initialValue: _existingTask['title'],
                  minLines: 1,
                  maxLines: null,
                  maxLength: 100,
                  onChanged: (value) {
                    _title = value;
                    _checker();
                  },
                  style: Theme.of(context).textTheme.titleLarge,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Add title',
                    border: InputBorder.none,
                    counterText: '',
                    contentPadding: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                  ),
                ),
                TextFormField(
                  initialValue: _existingTask['description'],
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  onChanged: (value) {
                    _description = value;
                    _checker();
                  },
                  decoration: const InputDecoration(
                    hintText: 'Add notes',
                    border: InputBorder.none,
                    counterText: '',
                    contentPadding: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CurrentDay extends StatelessWidget {
  const CurrentDay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AutoSizeText(
          DateFormat('dd/MM/y').format(DateTime.now()),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        AutoSizeText(
          ' - today',
          style: Theme.of(context).textTheme.bodySmall,
        )
      ],
    );
  }
}
