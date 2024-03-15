import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/cart_model.dart';
import 'package:shopping_cart/db_helper.dart';
import 'cart_provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper dbhelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent[100],
        title: const Text('My Products'),
        centerTitle: true,
        actions: [
          Badge(
            label: Consumer<CartProvider>(
              builder: (context, value, child){
                return Text(value.getCounter().toString());
              },
            ),
            child: Icon(Icons.shopping_cart_outlined),
          ),
          SizedBox(width: 20,),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder <List<Cart>>(
                future: cart.getData(),
                builder: (context, AsyncSnapshot<List<Cart>> snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, index){
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image(
                                          height: 100,
                                          width: 100,
                                          image: NetworkImage(snapshot.data![index].image.toString())),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(snapshot.data![index].productName.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                                InkWell(
                                                    onTap: (){
                                                      dbhelper.delete(snapshot.data![index].id!);
                                                      cart.removeItem();
                                                      cart.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                                      print('Product Removed Successfully');
                                                    },
                                                    child: const Icon(Icons.delete, color: Colors.red,))
                                              ],
                                            ),
                                            const SizedBox(height: 5,),
                                            Text(snapshot.data![index].unitTag.toString()+" "+r'$'+ snapshot.data![index].initialPrice.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                            const SizedBox(height: 5,),
                                            InkWell(
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: Container(
                                                  height: 35,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                      color: Colors.lightBlueAccent.shade100,
                                                      borderRadius: BorderRadius.circular(5)
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      InkWell(
                                                          onTap: (){
                                                            int quantity = snapshot.data![index].quantity!;
                                                            int? price = snapshot.data![index].productPrice!;
                                                            quantity--;
                                                            int newPrice = quantity * price;
                                                            dbhelper.updateQuantity(
                                                                Cart(
                                                                  id: snapshot.data![index].id,
                                                                  productId: snapshot.data![index].productId.toString(),
                                                                  productName: snapshot.data![index].productName!,
                                                                  initialPrice: snapshot.data![index].initialPrice!,
                                                                  productPrice: newPrice,
                                                                  quantity: quantity,
                                                                  unitTag: snapshot.data![index].unitTag,
                                                                  image: snapshot.data![index].image,
                                                                )
                                                            ).then((value){
                                                              newPrice = 0;
                                                              quantity = 0;
                                                              cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString(),));
                                                            }).onError((error, stackTrace){
                                                              print(error.toString());
                                                            });
                                                          },
                                                          child: const Icon(Icons.remove, size: 16,)),
                                                      Text(snapshot.data![index].quantity!.toString()),
                                                      InkWell(
                                                          onTap: (){
                                                            int quantity = snapshot.data![index].quantity!;
                                                            int? price = snapshot.data![index].productPrice!;
                                                            quantity++;
                                                            int newPrice = quantity * price;
                                                            dbhelper.updateQuantity(
                                                              Cart(
                                                                  id: snapshot.data![index].id,
                                                                  productId: snapshot.data![index].productId.toString(),
                                                                  productName: snapshot.data![index].productName!,
                                                                  initialPrice: snapshot.data![index].initialPrice!,
                                                                  productPrice: newPrice,
                                                                  quantity: quantity,
                                                                  unitTag: snapshot.data![index].unitTag,
                                                                  image: snapshot.data![index].image,
                                                              )
                                                            ).then((value){
                                                              newPrice = 0;
                                                              quantity = 0;
                                                              cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString(),));
                                                            }).onError((error, stackTrace){
                                                              print(error.toString());
                                                            });
                                                          },
                                                          child: const Icon(Icons.add, size: 16,))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                  return const Text('');
                }
            ),
          ),
          Consumer<CartProvider>(builder: (context, value, child){
            return Visibility(
              visible: value.totalPrice.toStringAsFixed(2) == "0.00" ? false : true,
              child: Column(
                children: [
                  ReuseableWidget(title: 'Sub Total', value: r'$'+value.totalPrice.toStringAsFixed(2))
                ],
              ),
            );
          })
        ],
      )
    );
  }
}

class ReuseableWidget extends StatelessWidget {
  final String title , value;
  const ReuseableWidget({ required this.title, required this.value });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium,),
          Text(value, style: Theme.of(context).textTheme.titleSmall,),
        ],
      ),
    );
  }
}