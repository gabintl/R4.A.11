import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../configs.dart';
import '../models/poll.dart';
import '../result.dart';


class PollsState extends ChangeNotifier {
  String? _token;
  List<Poll> _polls = [];

  List<Poll> get polls => _polls;

  void setAuthToken(String? token) {
    _token = token;
  }

  Future<void> fetchPolls() async {
    final response = await http.get(
      Uri.parse('${Configs.baseUrl}/polls'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_token',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    if (response.statusCode == HttpStatus.ok) {
      final List<dynamic> data = json.decode(response.body);
      _polls = data.map((e) => Poll.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<Result<String, String>> updatePollImage(int id, File imageFile) async {
  final fileContent = await imageFile.readAsBytes();

  final request = http.MultipartRequest('POST', Uri.parse('${Configs.baseUrl}/polls/$id/image'))
    ..headers.addAll({
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_token'
    })
    ..files.add(http.MultipartFile.fromBytes(
      '',
      fileContent,
      filename: imageFile.path.split('/').last,
    ));

  final response = await http.Response.fromStream(await request.send());

  if (response.statusCode == HttpStatus.ok) {
    final imageName = Poll.fromJson(json.decode(response.body)).imageName!;
    notifyListeners();
    return Result.success(imageName);
  } else {
    return Result.failure('Une erreur est survenue');
  }
}

Future<Result<bool, String>> registerToPoll(int id) async {
  final response = await http.post(
    Uri.parse('${Configs.baseUrl}/polls/$id/votes'),
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $_token',
      HttpHeaders.contentTypeHeader: 'application/json',
    },
  );

  if (response.statusCode == HttpStatus.ok) {
    return Result.success(true);
  }

  return Result.failure('Une erreur est survenue');
}

  Future<Result<String, String>> updatePoll(int id, String name, String description, DateTime date) async {
    final response = await http.put(
      Uri.parse('${Configs.baseUrl}/polls/$id'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $_token',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: json.encode({
        'name': name,
        'description': description,
        'eventDate': date.toIso8601String(),
      }),
    );
    if (response.statusCode == HttpStatus.ok) {
      final updatedPoll = Poll.fromJson(json.decode(response.body));
      final index = _polls.indexWhere((p) => p.id == id);
      if (index != -1) {
        _polls[index] = updatedPoll;
        notifyListeners();
      }
      return Result.success('Événement mis à jour avec succès');
    } else {
      return Result.failure('Une erreur est survenue');
    }

  }
}