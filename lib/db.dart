import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class DB {
  final db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<dynamic> login(_email, _pwd) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _pwd);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "لم يتم العثور على مستخدم لهذا البريد الإلكتروني.";
      } else if (e.code == 'wrong-password') {
        return "كلمة مرور خاطئة لهذا المستخدم";
      }
    }
  }

  Future<dynamic> signup(_email, _pwd) async {
    try {
      // UserCredential userCredential =
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _pwd);
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
      return "تم إرسال البريد الإلكتروني للتحقق";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'كلمة المرور المقدمة ضعيفة للغاية.';
      } else if (e.code == 'email-already-in-use') {
        return 'الحساب موجود بالفعل لهذا البريد الإلكتروني.';
      }
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot?> getData(doc, path) async {
    try {
      await Firebase.initializeApp();
      return await db.collection(path).doc(doc).get();
    } catch (e) {
      return null;
    }
  }

  Future<QuerySnapshot?> getDatagroup(path) async {
    try {
      await Firebase.initializeApp();
      return await db.collection(path).get();
    } catch (e) {
      return null;
    }
  }

  Future<bool> setData(doc, path, Map<String, dynamic> data) async {
    try {
      await Firebase.initializeApp();
      await db.collection(path).doc(doc).set(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateData(doc, path, Map<String, dynamic> data) async {
    try {
      await Firebase.initializeApp();
      await db.collection(path).doc(doc).update(data);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteDataDoc(path, documentId) async {
    try {
      await Firebase.initializeApp();
      await db.collection(path).doc(documentId).delete();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteDataField(path, documentId, field) async {
    try {
      await Firebase.initializeApp();
      await db
          .collection(path)
          .doc(documentId)
          .update({field: FieldValue.delete()});
      return true;
    } catch (_) {
      return false;
    }
  }
}
