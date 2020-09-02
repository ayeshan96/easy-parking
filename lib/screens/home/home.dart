import 'package:flutter/material.dart';
import 'package:flutterapp/models/user_details.dart';
import 'package:flutterapp/screens/home/my_home_page.dart';
import 'package:flutterapp/screens/home/profile_view.dart';
import 'package:flutterapp/screens/wrapper.dart';
import 'package:flutterapp/services/auth.dart';
import 'package:flutterapp/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  String hemawelemaoni;
  Home({this.hemawelemaoni});

  @override
  _HomeState createState() => _HomeState(hemawelemaoni:hemawelemaoni);
}

class _HomeState extends State<Home> {

  String hemawelemaoni;
  _HomeState({this.hemawelemaoni});


  ModalRoute<dynamic> _route;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _route?.removeScopedWillPopCallback(_onWillPop);
    _route = ModalRoute.of(context);
    _route?.addScopedWillPopCallback(_onWillPop);
  }

  @override
  void dispose() {
    _route?.removeScopedWillPopCallback(_onWillPop);
    super.dispose();
  }

  Future<bool> _onWillPop() => Future.value(false);



  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel(){
      showModalBottomSheet(context: context,builder: (context){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 60.0),
          color: Colors.black26,
          child: ProfileView(hemawelemaoni:hemawelemaoni),

        );

      });
    }

    // TODO: implement build
    return StreamProvider<List<UserDetails>>.value(
        value: DatabaseService().userdetails,
        child:Scaffold(

            backgroundColor: Colors.brown[50],
            appBar: AppBar(
              title: Text('Easy Parking'),
              backgroundColor: Colors.lightBlue[800],
              elevation: 0.0,
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.power_settings_new),
                  label:Text('Logout'),
                  onPressed: () async{
                    await _auth.signOut();
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => Wrapper()));

                    print("******************************************* Log OUT");
                  },
                ),
                FlatButton.icon(
                    icon: Icon(Icons.account_circle),
                    label: Text('Profile'),
                    //onPressed: ()=>_showSettingsPanel(),

                    onPressed: ()async{

                      _showSettingsPanel();

                      //var route=new MaterialPageRoute(builder: (BuildContext context)=>new ProfileView(result),);


                    })
              ],
            ),

            //body:UserDetailsList(),
            body: MyHomePage(hemawelemaoni:hemawelemaoni)

        ));
  }

}