import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../states/polls_state.dart';
import '../models/poll.dart';

class PollsPage extends StatefulWidget {
  const PollsPage({super.key});

  @override
  State<PollsPage> createState() => _PollsPageState();
}

class _PollsPageState extends State<PollsPage> {
  @override
  void initState() {
    super.initState();
    context.read<PollsState>().fetchPolls();
  }

  @override
  Widget build(BuildContext context) {
    final polls = context.watch<PollsState>().polls;

    return ListView.builder(
      itemCount: polls.length,
      itemBuilder: (context, index) {
        final poll = polls[index];
        return ListTile(
          title: Text(poll.name),
          subtitle: Text(poll.description),
          onTap: () {
            Navigator.pushNamed(context, '/polls/detail', arguments: poll);
          },
        );
      },
    );
  }
}