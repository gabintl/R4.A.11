import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/polls_state.dart';
import '../models/poll.dart';
import 'dart:io';
class PollEditPage extends StatefulWidget {
  const PollEditPage({super.key});

  @override
  State<PollEditPage> createState() => _PollEditPageState();
}

class _PollEditPageState extends State<PollEditPage> {
  late Poll poll;
  late String name;
  late String description;
  late DateTime date;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    poll = ModalRoute.of(context)!.settings.arguments as Poll;
    name = poll.name;
    description = poll.description;
    date = poll.eventDate;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue: name,
            style: Theme.of(context).textTheme.headlineMedium,
            onChanged: (value) => name = value,
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: description,
            onChanged: (value) => description = value,
            maxLines: null,
          ),
          const SizedBox(height: 8),
          ListTile(
            title: const Text('Date de l\'événement'),
            subtitle: Text(date.toString()),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() => date = picked);
              }
            },
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await context.read<PollsState>().updatePoll(poll.id, name, description, date);
              if (result.isSuccess) {
                if (mounted) Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result.failure!)),
                );
              }
            },
            child: const Text('Sauvegarder'),
          ),

          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<PollsState>().updatePollImage(poll.id, File('path/to/image'));
            },
            child: const Text('Modifier l\'image de cet événement'),
          ),
        ],
      ),
    );
  }
}
