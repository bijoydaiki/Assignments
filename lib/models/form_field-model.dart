import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

class FormFieldModel {
  final String type;
  final String title;
  final String key;
  final List<String>? options;
  final String? placeholder;

  FormFieldModel({
    required this.type,
    required this.title,
    required this.key,
    this.options,
    this.placeholder,
  });

  factory FormFieldModel.fromJson(Map<String, dynamic> json) {
    List<String>? optionsList;
    if (json['options'] != null) {
      optionsList = (json['options'] as List).map((item) => item.toString()).toList();
    }

    return FormFieldModel(
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      key: json['id'] ?? '', // Using 'id' as the key
      options: optionsList,
      placeholder: json['placeholder'],
    );
  }
}

class FormProvider with ChangeNotifier {
  List<FormFieldModel> _fields = [];
  Map<String, dynamic> _values = {};
  Map<String, String?> _errors = {};
  bool _isLoading = false;
  String? _errorMessage;

  List<FormFieldModel> get fields => _fields;
  Map<String, dynamic> get values => _values;
  Map<String, String?> get errors => _errors;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  FormProvider() {
    fetchFields();
  }

  Future<void> fetchFields() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://team.dev.helpabode.com:54292/api/wempro/flutter-dev/coding-test-2025/'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        if (jsonData['json_response'] != null && jsonData['json_response']['attributes'] is List) {
          final List<dynamic> fieldsData = jsonData['json_response']['attributes'];
          _fields = fieldsData.map((json) => FormFieldModel.fromJson(json)).toList();
          _values = {};

          for (var field in _fields) {
            if (field.type == 'checkbox' || field.type == 'checkboxes') {
              _values[field.key] = <String>[];
            } else {
              _values[field.key] = '';
            }
          }

          _errorMessage = null;
        } else {
          _errorMessage = 'Invalid response format: Expected a list of attributes';
        }
      } else {
        _errorMessage = 'Failed to load form fields: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error fetching fields: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  void updateValue(String key, dynamic value) {
    _values[key] = value;
    _errors[key] = null;
    notifyListeners();
  }

  bool validate() {
    _errors = {};
    bool isValid = true;

    for (var field in _fields) {
      final value = _values[field.key];
      // Assume all fields are required
      if (field.type == 'checkbox' || field.type == 'checkboxes') {
        if (value is List && value.isEmpty) {
          _errors[field.key] = '${field.title} is required';
          isValid = false;
        }
      } else if (value == null || (value is String && value.isEmpty)) {
        _errors[field.key] = '${field.title} is required';
        isValid = false;
      }
    }

    notifyListeners();
    return isValid;
  }

  void reset() {
    _values = {};
    for (var field in _fields) {
      if (field.type == 'checkbox' || field.type == 'checkboxes') {
        _values[field.key] = <String>[];
      } else {
        _values[field.key] = '';
      }
    }
    _errors = {};
    notifyListeners();
  }
}