import 'package:flutter/material.dart';
import 'package:flutterapp/screens/temp.dart';
import 'package:flutterapp/services/auth.dart';
import 'package:flutterapp/shared/loading.dart';
import '../../shared/frequent.dart';


class loginPage extends StatefulWidget{

  final Function toggleView;
  loginPage({this.toggleView});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return loginPageState();
  }


}
class loginPageState extends State<loginPage>{

  final AuthService _auth = AuthService();
  final _formKey=GlobalKey<FormState>();
  bool loading=false;

  //text field state
  String email='';
  String password='';
  String error='';


  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return loading ? Loading(): Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Login'),
          backgroundColor: Colors.lightBlue[800],
          elevation: 0.0,

          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('Sign Up'),
              onPressed: (){
                widget.toggleView();

              },
            )
          ],

        ),
      body: new Stack(
        fit: StackFit.expand,
            children: <Widget>[
        new Image(image: new AssetImage("images/welcomeimage.jpg"),
        fit: BoxFit.cover,
        color: Colors.black87,
          colorBlendMode: BlendMode.darken,
        ),


              new ListView(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Padding(padding: EdgeInsets.only(top:30.0)),

                  welcomeImageAsset(),
                  new Padding(padding: EdgeInsets.only(top:15.0)),



                  new Form(
                    key: _formKey,
                    child:new Theme(
                      data: new ThemeData(
                        brightness: Brightness.dark,
                        primarySwatch: Colors.teal,
                        inputDecorationTheme: new InputDecorationTheme(
                          labelStyle: new TextStyle(
                            color: Colors.teal,fontSize: 20.0
                          )

                        )
                      ),
                      child:Container(
                        padding: EdgeInsets.all(10.0),
                        child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[

                          new TextFormField(
                            decoration: new InputDecoration(
                                prefixIcon: Icon(Icons.mail,color: Colors.teal,),

                                labelText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)
                              )

                            ),
                            keyboardType: TextInputType.emailAddress,

                            validator: (val)=>val.isEmpty?'Enter an email':null,
                            onChanged: (val){
                              setState(()=>email=val);
                            },

                          ),

                          new Padding(padding: EdgeInsets.only(top:10.0)),

                          new TextFormField(
                            decoration: new InputDecoration(
                                prefixIcon: Icon(Icons.vpn_key,color: Colors.teal,),

                                labelText: "Password",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0)
                                )
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: true,

                            validator: (val)=>val.length<6?'Enter a password 6+ characters long':null,
                            onChanged: (val){
                              setState(()=>password=val);
                            },


                          ),

                          new Padding(padding: EdgeInsets.only(top:10.0)),


                          new RaisedButton(
                            color: Colors.lightBlue,
                            elevation: 6.0,
                            child: Text('Login',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),),
                            onPressed:() async{
                              if(_formKey.currentState.validate()){
                                setState(() =>loading=true);

                                print('valid');
                                dynamic result =await _auth.loginWithEmailAndPassword(email,password);
                                if(result==null){

                                  setState(() {
                                    error='Could not login with those credentials';
                                    loading=false;
                                  });
                                }
                                }
                              },

                            splashColor:Colors.red
                          ),
                          SizedBox(height: 12.0,),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red,fontSize: 14.0),

                          )

                        ],
                      )
                  )
                  )
                  )
                ],
              )

        ],
      )
    );
  }

}


