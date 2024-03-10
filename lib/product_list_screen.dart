import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/cart_model.dart';
import 'package:shopping_cart/cart_provider.dart';
import 'package:shopping_cart/cart_screen.dart';
import 'package:shopping_cart/db_helper.dart';
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}
 DBHelper? dbHelper = DBHelper();
class _ProductListScreenState extends State<ProductListScreen> {
  List <String> ProductName = ['Mango', 'Banana', 'Orange', 'Grapes', 'Peach', 'Cherry', 'Pine Apple'];
  List <String> ProductUnit = ['Kg', 'Dozen', 'Dozen', 'Kg', 'Kg', 'Kg', 'Kg'];
  List <int> ProductPrice = [10, 20, 30, 40, 50, 60, 70];
  List <String> ProductImg = [
    'https://media.istockphoto.com/id/168370138/zh/照片/mango.jpg?s=1024x1024&w=is&k=20&c=QW7dpY8HVchIGgqi81U41S42lt_YQVxjlC5J3AX4wpo=',
    'https://media.istockphoto.com/id/120492078/zh/照片/banana.jpg?s=1024x1024&w=is&k=20&c=a-Kmg_RqdEMZl92d4COYk8Wki_TmgUJZoTLDbdGxWMo=',
    'https://media.istockphoto.com/id/185284489/zh/照片/orange.jpg?s=1024x1024&w=is&k=20&c=KA3yIjDL6J5ZtWNyojmOv5yH6CJkjWAW05k8v3N6aSI=',
    'https://media.istockphoto.com/id/682505832/zh/照片/成熟的紅葡萄粉紅色的一束葉子與白色隔離帶裁剪路徑全場深度.jpg?s=1024x1024&w=is&k=20&c=Grcsqg5bsClTw3dyGmj7dIW3iXjDRFSiHCxczhWSMXc=',
    'https://media.istockphoto.com/id/1151868959/zh/照片/單瓣全桃果-葉-白色片.jpg?s=1024x1024&w=is&k=20&c=Y38jMDoNb-wFr772Vjx-fT-G_KSbCX_1DVPXK9IKWPY=',
    'https://media.istockphoto.com/id/464387287/zh/照片/bunch-of-cherries.jpg?s=1024x1024&w=is&k=20&c=_n2jOhUHsOMok7ES3fjqhNRtTxnh7UctIBe_7lDWD2E=',
    'https://media.istockphoto.com/id/158895679/zh/照片/sliced-open-pineapple-fruit-slices.jpg?s=1024x1024&w=is&k=20&c=Sg7-EeWa1E6CSxrhQGVyvxGoulA5fNaDTfKlEW4TK_I='
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent[100],
        title: const Text('Product List'),
        centerTitle: true,
        actions: [
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const CartScreen()));
              },
              child: Badge(
                label: Consumer<CartProvider>(
                    builder: (context, value, child){
                      return Text(value.getCounter().toString());
                    },
                    ),
                child: Icon(Icons.shopping_cart_outlined),
                        ),
            ),
          SizedBox(width: 20,),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                itemCount: ProductName.length,
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
                                    image: NetworkImage(ProductImg[index].toString())),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(ProductName[index], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                      const SizedBox(height: 5,),
                                      Text(ProductUnit[index].toString()+" "+r'$'+ ProductPrice[index].toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                      const SizedBox(height: 5,),
                                      InkWell(
                                        onTap: (){
                                          dbHelper!.insert(
                                            Cart(
                                                id: index,
                                                productId: index.toString(),
                                                productName: ProductName[index].toString(),
                                                initialPrice: ProductPrice[index],
                                                productPrice: ProductPrice[index],
                                                quantity: 1,
                                                unitTag: ProductUnit[index].toString(),
                                                image: ProductImg[index].toString()
                                            )
                                          ).then((value) => {
                                            print('Product is added to cart'),
                                            cart.addCounter(),
                                            cart.addTotalPrice(double.parse(ProductPrice[index].toString()))
                                          }).onError((error, stackTrace) => {
                                            print(error.toString())
                                          });
                                        },
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            height: 35,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.lightBlueAccent,
                                              borderRadius: BorderRadius.circular(5)
                                            ),
                                            child: const Center(
                                              child: Text('Add to Cart', style: TextStyle(color: Colors.white),),
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
                  })
          ),
        ],
      ),
    );
  }
}

