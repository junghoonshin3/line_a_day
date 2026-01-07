import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> isBiometricAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: '일기를 열려면 인증이 필요합니다',
        biometricOnly: true,
        authMessages: [
          const IOSAuthMessages(cancelButton: "취소"),
          const AndroidAuthMessages(
            signInTitle: "생체인증",
            signInHint: "지문이나 얼굴로 인증해주세요",
            cancelButton: "취소",
          ),
        ],
      );
    } catch (e) {
      return false;
    }
  }

  Future<void> savePassword(SharedPreferences prefs, String password) async {
    // 실제 프로덕션에서는 암호화 필요
    await prefs.setString('app_password', password);
  }

  Future<bool> verifyPassword(SharedPreferences prefs, String password) async {
    final saved = prefs.getString('app_password');
    return saved == password;
  }

  Future<void> removePassword(SharedPreferences prefs) async {
    await prefs.remove('app_password');
  }
}
