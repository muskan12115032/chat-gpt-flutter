import 'package:chat_gpt_clone/models/model.dart';
import 'package:chat_gpt_clone/services/api_services.dart';
import 'package:flutter/material.dart';

class ModelsProvider with ChangeNotifier {
  List<Model> models = [];
  String currentModel = 'text-davinci-003';
  List<Model> getModelList() {
    return models;
  }

  String getCurrentModel() {
    return currentModel;
  }

  void setCurrentModel(String value) {
    currentModel = value;
    notifyListeners();
  }

  Future<List<Model>> getAllModels() async {
    models = await ApiServices.getModels();
    return models;
  }
}
