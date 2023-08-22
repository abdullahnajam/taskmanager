
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/screens/navigators/bottom_nav.dart';
import 'package:taskmanager/screens/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../api/payment_service.dart';
import 'navigators/tabbed_bottom_nav.dart';



class Subscribe extends StatefulWidget {
  const Subscribe({Key? key}) : super(key: key);

  @override
  _SubscribeState createState() => _SubscribeState();
}

class _SubscribeState extends State<Subscribe> {

  final PaymentService _paymentService=PaymentService();
  String selectedProductId="";

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _paymentService.dispose();
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.1,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Subscribe!",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w600),),
                    SizedBox(width: 10,),
                    Image.asset("assets/images/crown.png",height: 20,)
                  ],
                ),
                SizedBox(height: 10,),
                Text("Please subscribe to use the app", style: TextStyle(fontWeight: FontWeight.w300),),



              ],
            ),
            SizedBox(height: 20,),
            Expanded(
              child: ListView(
                children: [
                  personalPackage(
                      productID: productLists[0],
                      title: 'Monthly Subscription',
                      price: '2.5'
                  ),
                  personalPackage(
                      productID: productLists[1],
                      title: 'Yearly Subscription',
                      price: '25'
                  ),
                  /*if(FirebaseAuth.instance.currentUser==null || provider.userData!.type=='Healthcare')
                              providerPackage(productLists[2])*/
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /*InkWell(
                              onTap: ()async{
                                if(provider.userData!.premium){
                                  await InAppPurchase.instance.restorePurchases();
                                }
                                else{
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    text: "No item purchased",
                                  );
                                }

                              },
                              child: Text('Restore Purchase',style: TextStyle(color: Color(provider.userData!.secondaryBrandColor),fontSize: 18,fontWeight: FontWeight.w600),),
                            ),*/
                  SizedBox(width: 10,),
                  InkWell(
                    onTap: ()async{
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => TabbedBottomNavBar()));

                      if(selectedProductId==""){
                        CoolAlert.show(
                          context: context,
                          type: CoolAlertType.error,
                          text: "No item selected",
                        );
                      }
                      else{
                        /*final provider = Provider.of<UserDataProvider>(context, listen: false);
                                  print('selected ID $selectedProductId');
                                  await _paymentService.getProductById(selectedProductId);
                                  await _paymentService.requestPurchase(selectedProductId).then((value)async{
                                    await FirebaseFirestore.instance.collection('users').doc(provider.userData!.userId).update({
                                      'premium':true,
                                    });
                                    Navigator.pop(context);
                                  }).onError((error, stackTrace){
                                    print('purchase error ${error.toString()}');
                                    CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.error,
                                      text: error.toString(),
                                    );
                                  });*/
                      }
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(10,0,10,0),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(4)
                      ),
                      child: Text("CONTINUE",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color:Colors.white),),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      /*body: Card(
        margin: EdgeInsets.all(20),
        child: FutureBuilder(
          future: _paymentService.initPlatformState(),
          builder: (BuildContext context, AsyncSnapshot initsnap) {
            if (initsnap.connectionState == ConnectionState.waiting) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
            else {
              if (initsnap.hasError) {
                print("error ${initsnap.error}");
                return  Center(
                  child: Text("Something went wrong : ${initsnap.error}"),
                );
              }

              else {

                return Column(
                  children: [
                    SizedBox(height: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Go Premium!",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                            SizedBox(width: 10,),
                            Image.asset("assets/icons/crown.png",height: 25,)
                          ],
                        ),
                        SizedBox(height: 10,),
                        Text("Free of ads",style: TextStyle(color: primaryColor,fontSize: 30,fontWeight: FontWeight.w600),),
                        SizedBox(height: 5,),
                        Text("Ads free app if subscribed. Cancel anytime.", style: TextStyle(fontWeight: FontWeight.w300),),

                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: InkWell(
                              onTap: ()async{
                                await launchUrl(Uri.parse('privacyUrl'))
                                    .then((value){
                                  print('val $value');
                                })
                                    .onError((error, stackTrace){
                                  print('error $error');
                                });
                              },
                              child: Text("View Privacy Policy", style: TextStyle(fontWeight: FontWeight.w300,color: primaryColor),),
                            )
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10),
                            child: InkWell(
                              onTap: ()async{
                                await launchUrl(Uri.parse('https://www.apple.com/legal/internet-services/itunes/dev/stdeula/'))
                                    .then((value){
                                  print('val $value');
                                })
                                    .onError((error, stackTrace){
                                  print('error $error');
                                });
                              },
                              child: Text("View Terms of use (EULA)", style: TextStyle(fontWeight: FontWeight.w300,color: primaryColor),),
                            )
                        ),

                      ],
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          personalPackage(
                              productID: productLists[0],
                              title: 'Monthly Subscription',
                              price: '2.99'
                          ),
                          personalPackage(
                              productID: productLists[1],
                              title: 'Yearly Subscription',
                              price: '29.9'
                          ),
                          *//*if(FirebaseAuth.instance.currentUser==null || provider.userData!.type=='Healthcare')
                            providerPackage(productLists[2])*//*
                        ],
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          *//*InkWell(
                            onTap: ()async{
                              if(provider.userData!.premium){
                                await InAppPurchase.instance.restorePurchases();
                              }
                              else{
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.error,
                                  text: "No item purchased",
                                );
                              }

                            },
                            child: Text('Restore Purchase',style: TextStyle(color: Color(provider.userData!.secondaryBrandColor),fontSize: 18,fontWeight: FontWeight.w600),),
                          ),*//*
                          SizedBox(width: 10,),
                          InkWell(
                            onTap: ()async{
                              if(selectedProductId==""){
                                CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.error,
                                  text: "No item selected",
                                );
                              }
                              else{
                                *//*final provider = Provider.of<UserDataProvider>(context, listen: false);
                                print('selected ID $selectedProductId');
                                await _paymentService.getProductById(selectedProductId);
                                await _paymentService.requestPurchase(selectedProductId).then((value)async{
                                  await FirebaseFirestore.instance.collection('users').doc(provider.userData!.userId).update({
                                    'premium':true,
                                  });
                                  Navigator.pop(context);
                                }).onError((error, stackTrace){
                                  print('purchase error ${error.toString()}');
                                  CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    text: error.toString(),
                                  );
                                });*//*
                              }
                            },
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              padding: EdgeInsets.fromLTRB(10,0,10,0),
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(4)
                              ),
                              child: Text("CONTINUE",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color:Colors.white),),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            }

          },
        ),

      ),*/
    );
  }
  Widget personalPackage({required String productID, title, price}){
    return InkWell(
      onTap: (){
        setState(() {
          selectedProductId=productID;
        });
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 2,
            color: selectedProductId==productID ? primaryColor: Colors.black38,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(

                  child: Text(title!,style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                ),
                SizedBox(width: 10,),
                AnimatedCrossFade(
                  firstChild: Image.asset('assets/images/ic_radio_on.png', color: primaryColor),
                  secondChild: Image.asset('assets/images/ic_radio_off.png', color: primaryColor),
                  crossFadeState: selectedProductId==productID ? CrossFadeState.showFirst: CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 100),
                  firstCurve: Curves.easeInOut,
                  secondCurve: Curves.easeInOut,
                ),
              ],
            ),
            Text("\$$price",style: TextStyle(color: primaryColor,fontSize: 16,fontWeight: FontWeight.w600),),
            //Text("Monthly subscription", style: TextStyle(fontWeight: FontWeight.w300),),

          ],
        ),
      ),
    );
  }


}