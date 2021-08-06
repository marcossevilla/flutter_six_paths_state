import 'package:uuid/uuid.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;

  User({
    required this.name,
    required this.email,
  }) : this.id = Uuid().v4();

  @override
  List<Object> get props => [id, name, email];
}
