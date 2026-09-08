import 'package:flutter/material.dart';

class ActivityTwoPage extends StatefulWidget {
  const ActivityTwoPage({super.key});

  @override
  State<ActivityTwoPage> createState() => _ActivityTwoPageState();
}

class _ActivityTwoPageState extends State<ActivityTwoPage> {
  final TextEditingController _controller = TextEditingController();
  String _preview = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity Two')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Type something',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _preview = value),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(Icons.preview),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _preview.isEmpty ? 'Preview will appear here' : _preview,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
