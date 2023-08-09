import 'dart:async';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class PaymentService{
  late StreamSubscription? _purchaseUpdatedSubscription;
  late StreamSubscription? _purchaseErrorSubscription;
  late StreamSubscription? _conectionSubscription;


  String _platformVersion = 'Unknown';
  /*List<IAPItem> _items = [];
  List<PurchasedItem> _purchases = [];*/



  void dispose(){
    if (_conectionSubscription != null) {
      _conectionSubscription!.cancel();
      _conectionSubscription = null;
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {

    var result = await FlutterInappPurchase.instance.initialize();
    print('result: $result');


    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAll();
      print('consumeAllItems: $msg');
    } catch (err) {
      print('consumeAllItems error: $err');
    }

    _conectionSubscription = FlutterInappPurchase.connectionUpdated.listen((connected) {
          print('connected: $connected');
        });

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) {
          print('purchase-updated: $productItem');
        });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
          print('purchase-error: $purchaseError');
        });
  }

  void requestPurchase(String productId) {
    FlutterInappPurchase.instance.requestPurchase(productId).then((value) => print("payment value ${value}"));
  }

  Future<List<IAPItem>>  getProduct(List<String> product) async {

    List<IAPItem> items = [];
    items=await FlutterInappPurchase.instance.getSubscriptions(product);
    items.forEach((element) {
      print('items ${element.productId} ${element.price}');
    });

    return items;
  }

  Future<List<PurchasedItem>?> getPurchases() async {
    List<PurchasedItem>? items = [];
    items=await FlutterInappPurchase.instance.getAvailablePurchases();
    return items;
  }

  Future<List<PurchasedItem>?> getPurchaseHistory() async {
    List<PurchasedItem>? items=[];
    items= await FlutterInappPurchase.instance.getPurchaseHistory();
    return items;
  }

}