import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/form_field-model.dart';


class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FormProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Summary'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: provider.values.entries.map((entry) {
                final field = provider.fields.firstWhere((f) => f.key == entry.key);
                String displayValue;

                if (entry.value is List) {
                  displayValue = (entry.value as List).map((item) => item.toString()).join(', ');
                } else {
                  displayValue = entry.value.toString();
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    title: Text(field.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(displayValue),
                  ),
                );
              }).toList(),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  provider.reset();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Start Over'),
              ),
            ),
          ),
        );
      },
    );
  }
}