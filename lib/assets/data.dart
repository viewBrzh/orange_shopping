// import 'product.dart';
// import 'store.dart';
// import 'cart.dart';

// List<Product> productList = [
//   Product('Nigka Prowler edition. Pride month celebrate.', 'lib/images/p1.jpg',
//       35000, 'sport'),
//   Product('Nigka Air Jordan 1 KO Chicago limited edition.', 'lib/images/p2.png',
//       25000, 'sport'),
//   Product('Nigka Magista onda SG.', 'lib/images/p3.png', 5990, 'sport'),
//   Product('Nigka Big Ball Chunky A.', 'lib/images/p4.jpg', 3590, 'sport'),
//   Product('Nigka MASSIVE PLATFORM HOLOGRAPHIC.', 'lib/images/p5.jpg', 2990,
//       'sport'),
//   Product('GUCCI Bomber Jacket.', 'lib/images/f1.jpg', 92277, 'fashion'),
//   Product('Casio Edifice Chronograph.', 'lib/images/f2.jpg', 2590, 'fashion'),
//   Product('electric patient bed.', 'lib/images/ft1.jpg', 36900, 'furniture'),
//   Product('Extreme King Honor Gaming Chair.', 'lib/images/ft2.jpg', 4490,
//       'furniture'),
// ];

// List<Product> store1 = [productList[0],productList[1],productList[2],productList[3]];
// List<Product> store2 = [productList[4],productList[5]];
// List<Product> store3 = [productList[6],productList[7]];

// List<Store> storeList = [
//   Store(
//     'Nigka Shop',
//     'lib/images/s1.png',
//     store1
//   ),
//   Store(
//     'Siam watch',
//     'lib/images/s2.png',
//     store2
//   ),
//   Store(
//     'Michi furniture',
//     'lib/images/s3.png',
//     store3
//   ),
// ];
// List<Product> cartProduct = [Product('', '', 0, '')];
// Cart usCart = new Cart('','',cartProduct,'');


// Product searchProduct(Product product){
//   int st = 0, sp = 0;
//   for (int n = 0;n < storeList.length; n++){
//     for (int r = 0; r < storeList[n].productList.length; r++){
//       if (product.name == storeList[n].productList[r].name){
//         return storeList[n].productList[r];
//       }
//     }
//   }
//   return storeList[st].productList[sp];
// }

// Store searchStore(Product product){
//   int st = 0;
//   for (int n = 0;n < storeList.length; n++){
//     for (int r = 0; r < storeList[n].productList.length; r++){
//       if (product.name == storeList[n].productList[r].name){
//         return storeList[n];
//       }
//     }
//   }
//   return storeList[st];
// }

// login(String name,String pass){
//   usCart = Cart(name,pass,cartProduct,'');
// }

// List<Product> addProduct(Product newProduct){
//   if (productList[0].name == ''){
//     cartProduct[0] = newProduct;
//     return cartProduct;
//   }
//   else {
//     cartProduct.add(newProduct);
//     return cartProduct;
//   }
// }


