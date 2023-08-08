import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/bloc/CartList.dart';
import 'package:food_delivery/cart.dart';
import 'package:food_delivery/model/FoodItem.dart';

void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc((i) => CartListBloc()),
      ],
      dependencies: [],
      child: MaterialApp(
        title: "Food Delivery",
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class Home extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
            children: <Widget>[
              FirstHalf(),
              const SizedBox(height: 45),
              for (var foodItem in fooditemList.foodItems)
                Builder(
                  builder: (context) {
                    return ItemContainer(foodItem: foodItem);
                  },
                )
            ],
          )),
    );
  }
}

class ItemContainer extends StatelessWidget {
  
  ItemContainer({super.key, 
    required this.foodItem,
  });

  final FoodItem foodItem;
  final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();

  
  addToCart(FoodItem foodItem) {
    bloc.addToList(foodItem);
  }

  removeFromList(FoodItem foodItem) {
    bloc.removeFromList(foodItem);
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        addToCart(foodItem);
        final snackBar = SnackBar(
          content: Text('${foodItem.title} added to Cart'),
          duration: const Duration(milliseconds: 550),
        );

        Scaffold.of(context).showSnackBar(snackBar);
      },
      child: Items(
        hotel: foodItem.hotel,
        itemName: foodItem.title,
        itemPrice: foodItem.price,
        imgUrl: foodItem.imgUrl,
        leftAligned: (foodItem.id % 2) == 0 ? true : false,
      ),
    );
  }
}

class FirstHalf extends StatelessWidget {
  const FirstHalf({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 25, 0, 0),
      child: Column(
        children: <Widget>[
          CustomAppBar(),
          
          const SizedBox(height: 30),
          Title(color: Color.fromARGB(50, 0, 0, 0),),
          SizedB1ox(height: 30),
          SearchBar(),
          SizedBox(height: 45),
          categories(),
        ],
      ),
    );
  }
}


class Items extends StatelessWidget {
  Items({
    required this.leftAligned,
    required this.imgUrl,
    required this.itemName,
    required this.itemPrice,
    required this.hotel,
  });

  final bool leftAligned;
  final String imgUrl;
  final String itemName;
  final double itemPrice;
  final String hotel;

  @override
  Widget build(BuildContext context) {
    double containerPadding = 45;
    double containerBorderRadius = 10;

    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: leftAligned ? 0 : containerPadding,
            right: leftAligned ? containerPadding : 0,
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 200,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: ClipRRect(
                  borderRadius: BorderRadius.horizontal(
                    left: leftAligned
                        ? Radius.circular(0)
                        : Radius.circular(containerBorderRadius),
                    right: leftAligned
                        ? Radius.circular(containerBorderRadius)
                        : Radius.circular(0),
                  ),
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                  padding: EdgeInsets.only(
                    left: leftAligned ? 20 : 0,
                    right: leftAligned ? 0 : 20,
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(itemName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  )),
                            ),
                            Text("\$$itemPrice",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                )),
                          ],
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 15),
                                children: [
                                  TextSpan(text: "by "),
                                  TextSpan(
                                      text: hotel,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700))
                                ]),
                          ),
                        ),
                        SizedBox(height: containerPadding),
                      ])),
            ],
          ),
        )
      ],
    );
  }
}
