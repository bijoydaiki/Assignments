import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/form_field-model.dart';
import 'package:http/http.dart'as http;



class DynamicField extends StatelessWidget {
  final FormFieldModel field;

  const DynamicField({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return Consumer<FormProvider>(
      builder: (context, provider, child) {
        final error = provider.errors[field.key];
        Widget inputWidget;

        switch (field.type) {
          case 'textfield':
            inputWidget = TextField(
              decoration: InputDecoration(
                labelText: field.title,
                hintText: field.placeholder ?? 'Enter ${field.title}',
                errorText: error,
              ),
              onChanged: (value) => provider.updateValue(field.key, value),
              controller: TextEditingController(text: provider.values[field.key] ?? ''),
            );
            break;
          case 'dropdown':
            inputWidget = DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: field.title,
                errorText: error,
              ),
              value: provider.values[field.key] == '' ? null : provider.values[field.key],
              items: field.options?.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  provider.updateValue(field.key, value);
                }
              },
            );
            break;
          case 'radio':
            inputWidget = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(field.title, style: Theme.of(context).textTheme.titleMedium),
                ...?field.options?.map((option) {
                  return RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: provider.values[field.key],
                    onChanged: (value) {
                      if (value != null) {
                        provider.updateValue(field.key, value);
                      }
                    },
                  );
                }),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(error, style: const TextStyle(color: Colors.red)),
                  ),
              ],
            );
            break;
          case 'checkbox':
          case 'checkboxes':
            final List<String> values = List<String>.from(provider.values[field.key] ?? []);

            inputWidget = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(field.title, style: Theme.of(context).textTheme.titleMedium),
                ...?field.options?.map((option) {
                  return CheckboxListTile(
                    title: Text(option),
                    value: values.contains(option),
                    onChanged: (checked) {
                      final List<String> newValues = List<String>.from(values);
                      if (checked == true) {
                        if (!newValues.contains(option)) {
                          newValues.add(option);
                        }
                      } else {
                        newValues.remove(option);
                      }
                      provider.updateValue(field.key, newValues);
                    },
                  );
                }),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(error, style: const TextStyle(color: Colors.red)),
                  ),
              ],
            );
            break;
          default:
            inputWidget = const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: inputWidget,
        );
      },
    );
  }
}




