// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Model {
  final String id;
  final int created;
  final String root;

  Model({required this.id, required this.created, required this.root});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'created': created,
      'root': root,
    };
  }

  factory Model.fromMap(Map<String, dynamic> map) {
    return Model(
      id: map['id'],
      created: map['created'],
      root: map['root'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Model.fromJson(String source) =>
      Model.fromMap(json.decode(source) as Map<String, dynamic>);

  static List<Model> modelsFromSnapShot(List snapshot) {
    return snapshot.map((e) => Model.fromMap(e)).toList();
  }
}
