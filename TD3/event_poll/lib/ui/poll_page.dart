import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/polls_state.dart';
import '../models/poll.dart';

class PollPage extends StatefulWidget {
  const PollPage({super.key});

  @override
  State<PollPage> createState() => _PollPageState();
}

class _PollPageState extends State<PollPage> {
  late Poll poll;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    poll = ModalRoute.of(context)!.settings.arguments as Poll;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(poll.name, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(poll.description),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final result = await context.read<PollsState>().registerToPoll(poll.id);
              if (result.isSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Inscription réussie !')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result.failure!)),
                );
              }
            },
            child: const Text('S\'inscrire à cet événement'),
          ),
        ],
      ),
    );
  }
}