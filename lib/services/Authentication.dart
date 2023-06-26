import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class Authentication{
  final GoogleSignIn _googleSignIn= GoogleSignIn();
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

  Future<GoogleSignInAccount> googleSignIn() async {
    final  GoogleSignInAccount googleSignInAccount= await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication= await googleSignInAccount.authentication;
    final AuthCredential authCredential=GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken
    );
    final UserCredential userCredential= await _firebaseAuth.signInWithCredential(authCredential);
    final User user =userCredential.user;
    assert(user.displayName!=null);
    assert(user.email!=null);

    final User currentUser= _firebaseAuth.currentUser;
    assert(currentUser.uid==user.uid);
    return googleSignInAccount;
}
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}