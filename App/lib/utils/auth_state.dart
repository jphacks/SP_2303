import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_state.g.dart';

@Riverpod(keepAlive: true)
Stream<User?> userChanges(UserChangesRef ref) {
  return FirebaseAuth.instance.idTokenChanges();
}

///ユーザ
@Riverpod(keepAlive: true)
User? user(UserRef ref) {
  final userChanges = ref.watch(userChangesProvider);
  return userChanges.when(
    data: (user) => user,
    loading: () => null,
    error: (err, stack) => null,
  );
}

//サインインしているかどうか
@Riverpod(keepAlive: true)
bool isSignedIn(IsSignedInRef ref) {
  final user = ref.watch(userProvider);
  return user != null;
}
