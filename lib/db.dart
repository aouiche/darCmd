import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class DB {
  final db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<dynamic> login(_email, _pwd) async {
    try {
      await Firebase.initializeApp();
      return (await _auth.signInWithEmailAndPassword(
              email: _email, password: _pwd))
          .user;
    } catch (e) {
      return "error";
    }
  }

  Future<dynamic> signup(_email, _pwd) async {
    try {
      await Firebase.initializeApp();
      return (await _auth.createUserWithEmailAndPassword(
              email: _email, password: _pwd))
          .user;
    } catch (e) {
      return "error";
    }
  }

  Future<DocumentSnapshot> getData(doc, path) async {
    await Firebase.initializeApp();
    return await db.collection(path).doc(doc).get();
  }

  Future<QuerySnapshot> getDatagroup(path) async {
    await Firebase.initializeApp();
    return await db.collection(path).get();
  }

  Future<bool> setData(doc, path, Map<String, dynamic> data) async {
    try {
      await Firebase.initializeApp();
      await db.collection(path).doc(doc).set(data);
      return true;
    } catch (_) {
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
