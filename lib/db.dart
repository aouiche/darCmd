 
import 'package:cloud_firestore/cloud_firestore.dart';  
import 'package:firebase_auth/firebase_auth.dart';  

class DB{
 final db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; 
  

  Future<dynamic> login(_email,_pwd)async{    
     try {
     return (await _auth.signInWithEmailAndPassword(email: _email, password: _pwd)).user;   
       
     } catch (e) {
       return "error";
     }
  }  

  Future<dynamic> signup(_email,_pwd)async{  
    try {
     return (await _auth.createUserWithEmailAndPassword(email: _email, password: _pwd)).user;   
      
    } catch (e) {
            return "error";
      
    }  
  }  

  Future<DocumentSnapshot> getData(doc ,path ) async {
  return await db.collection(path)
      .document(doc)
      .get(); 
}

 Future<QuerySnapshot>getDatagroup(path ) async {
  return await db.collection(path).getDocuments(); 
}

Future<bool>setData(doc ,path , Map<String,dynamic> data) async { 
  try{
      await db.collection(path)
          .document(doc)
          .setData(data); 
          return true;
  }catch(_){
    return false;

  }  
     }
     
     
   Future<bool> updateData(doc,path , Map<String,dynamic> data) async { 
     try{
        await db.collection(path)
          .document(doc)
          .updateData(data);
          return true;
       }catch(_){
            return false;
          }
   }
 
 Future<bool>  deleteDataDoc(path , documentId) async {
  try{
  await db.collection(path) 
      .document(documentId)
      .delete();
          return true;
       }catch(_){
            return false;
          }
   }
 Future<bool>  deleteDataField(path , documentId, field) async {
  try{
  await db.collection(path) 
      .document(documentId)
      .updateData({field: FieldValue.delete()});
          return true;
       }catch(_){
            return false;
          }
   }
} 