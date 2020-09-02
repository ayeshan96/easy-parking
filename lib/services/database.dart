import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterapp/models/user_details.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference profileCollection=Firestore.instance.collection('userdetails');

  Future updateUserDetails(String name,String phoneNumber,String email)async{
    return await profileCollection.document(uid).setData({
      'name':name,
      'phoneNumber':phoneNumber,
      'email':email,
      'check' :false,
      'park':'',
      'firstDate':'',
      'firstTime':'',
      'checkingTime':false,
      'lastPayment':0
    });
  }

  //user details list from snapshot
  List<UserDetails>_userdetailslistFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return UserDetails(
        name: doc.data['name']??'',
        phoneNumber: doc.data['phoneNumber']??'',
        email: doc.data['email']??'',
      );
    }).toList();
  }

  //get userdetails stream
  Stream<List<UserDetails>>get userdetails{
    return profileCollection.snapshots()
    .map(_userdetailslistFromSnapshot);
  }

}