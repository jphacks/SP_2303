import 'package:firebase_auth/firebase_auth.dart';
import 'package:gohan_map/firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {

  //SigninwithGoogle
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

  //SigninwithApple
  //iOSのみ
  Future<UserCredential?> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );
    return FirebaseAuth.instance.signInWithCredential(oauthCredential);
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

  //アカウント削除
  Future<int> deleteAccount() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
    } catch (e) {
      print("アカウント削除に失敗しました: $e");
      return 1;
      // ここに失敗時の追加処理を書く（例: ユーザーに通知する、ログを記録するなど）
    }
    return 0;
  }
}
