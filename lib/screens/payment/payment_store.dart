import 'package:flutter/material.dart';
import 'package:animated_dialog_box/animated_dialog_box.dart';
import 'package:flutterapp/screens/wrapper.dart';


class PaymentStore extends StatefulWidget {

  String hemawelemaoni;
  String finalPayment;
  String fiTime;
  PaymentStore({this.hemawelemaoni,this.finalPayment,this.fiTime});


  @override
  _PaymentStoreState createState() => _PaymentStoreState(hemawelemaoni:hemawelemaoni,finalPayment:finalPayment,fiTime:fiTime);
}

class _PaymentStoreState extends State<PaymentStore> with SingleTickerProviderStateMixin{

  String hemawelemaoni;
  String finalPayment;
  String fiTime;
  _PaymentStoreState({this.hemawelemaoni,this.finalPayment,this.fiTime});



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




  TabController _tabController;


  @override
  void initState() {
    //print("KKKKKKKKKKKKK${stopWatchTimetodisplay}KKKKKKKKKKKKKKKKKKKKKKKKK");
    _tabController = new TabController(length: 1, vsync: this);
    super.initState();
  }



  Widget stopwatch(){
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                fiTime,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.center,
              child: Text(

                'Rs.${finalPayment}.00',
                style: TextStyle(
                  fontSize: 80.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: (){
                          animated_dialog_box.showRotatedAlert(
                              title: Center(child: Text("CONFIRM1")),
                              // IF YOU WANT TO ADD
                              context: context,
                              firstButton: MaterialButton(
                                // FIRST BUTTON IS REQUIRED
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  color: Colors.white,
                                  child: Text('Ok'),
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                        builder: (context) =>
                                        Wrapper()));

                                  }
                              ),
                              secondButton: MaterialButton(
                                // OPTIONAL BUTTON
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                color: Colors.white,
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              icon: Icon(
                                Icons.info_outline,
                                color: Colors.red,
                              ),
                              // IF YOU WANT TO ADD ICON
                              yourWidget: Container(
                          child: Column(
                          children: <Widget>[
                          new Padding(
                          padding: EdgeInsets.only(top: 25.0)),
                          Text(
                          'Press \'OK\' to go to Home Page.',
                          ),
                          new Padding(
                          padding: EdgeInsets.only(top: 20.0)),

                          ],
                          )));

                        },
                        color:Colors.deepOrangeAccent,
                        padding: EdgeInsets.symmetric(
                          horizontal: 80.0,
                          vertical: 25.0,
                        ),
                        child: Text(
                          'Home Page',
                          style: TextStyle(
                              fontSize: 24.0,
                              color: Colors.black
                          ),
                        ),

                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        children: <Widget>[
          stopwatch(),
        ],
        controller: _tabController,
      ),
    );
  }
}