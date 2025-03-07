import 'package:flutter/material.dart';

import '../../core/constants/constants.dart';
import '../../domain/entities/task.dart';

class EditingFormTaskAlertDialog extends StatefulWidget {
  const EditingFormTaskAlertDialog({
    super.key,
    this.task,
    required this.callback,
  });

  final Task? task;
  final Function({
    required String title,
    required String desc,
    required String category,
  }) callback;

  @override
  State<EditingFormTaskAlertDialog> createState() =>
      _EditingFormTaskAlertDialogState();
}

class _EditingFormTaskAlertDialogState
    extends State<EditingFormTaskAlertDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descController;

  final _formKey = GlobalKey<FormState>();

  late String _category;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descController = TextEditingController();

    _titleController.text = widget.task?.title ?? '';
    _descController.text = widget.task?.description ?? '';

    _category = widget.task?.category ?? kCategories[0];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Task'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter valid title';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter valid description';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Category:',
            ),
            SizedBox(
              height: 50,
              child: DropdownButton(
                items: kCategories.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                value: _category,
                onChanged: (String? value) {
                  setState(() {
                    _category = value!;
                  });
                },
              ),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () => _validate(),
          child: const Text(
            'Add',
          ),
        )
      ],
    );
  }

  _validate() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    widget.callback(
      title: _titleController.text,
      desc: _descController.text,
      category: _category,
    );

    Navigator.pop(context);
  }
}
