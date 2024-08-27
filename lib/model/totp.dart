import 'package:uuid/uuid.dart';

class TOTP {
  final String id;
  String accountName;
  final String secret;
  String? totp;

  TOTP({required this.accountName, required this.secret, this.totp})
      : id = const Uuid().v4();
}
