import 'package:firebase_auth/firebase_auth.dart';
import 'package:gohan_map/firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      clientId: DefaultFirebaseOptions.currentPlatform.iosClientId,
    ).signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    if (googleAuth == null) {
      return null;
    }
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<int> signOut() async {
    try {
      await GoogleSignIn(
        clientId: DefaultFirebaseOptions.currentPlatform.iosClientId,
      ).signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print("ログアウトに失敗しました: $e");
      return 1;
      // ここに失敗時の追加処理を書く（例: ユーザーに通知する、ログを記録するなど）
    }
    return 0;
  }
}
