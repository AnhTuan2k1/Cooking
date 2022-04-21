import 'package:flutter/material.dart';

class Ingredients extends StatefulWidget {
  const Ingredients({Key? key}) : super(key: key);

  @override
  _IngredientsState createState() => _IngredientsState();
}

class _IngredientsState extends State<Ingredients> {
  List<Widget> list = <Widget>[];

  @override
  void initState(){
    list.add(ingredient());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Text('Nguyên liệu', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Column(children: list,),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:[
                GestureDetector(
                  onTap: () => setState(()=> list.add(ingredient())),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add),
                      Text('Thêm nguyên liệu', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(()=> list.removeLast()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.remove),
                      Text('Xóa nguyên liệu', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ]
          ),
        ]
    );

/*    Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Text('Nguyên liệu', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Expanded(
              child: ListView.builder(itemBuilder: (context, index) {
                return ingredient();
              })),
          widget(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[
                  GestureDetector(
                    onTap: () => setState(()=> list.add(ingredient())),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add),
                        Text('Thêm nguyên liệu', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(()=> list.removeLast()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.remove),
                        Text('Xóa nguyên liệu', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ]
            ),
          ),
        ]
    );*/
  }

  Widget ingredient()
  {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextField(
              maxLength: 56,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(15),
                filled: true,
                hintText: '300g thịt',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),

/*        PopupMenuButton(
          itemBuilder: (context){
            return [
              const PopupMenuItem<int>(value: 0, child: Text('Thêm nguyên liệu'),),
              const PopupMenuItem<int>(value: 1, child: Text('Xóa nguyên liệu này')),
            ];
          },
          onSelected: (value){
            if(value == 0){
              setState(() {
                list.add(ingredient());
              });
            }else if(value == 1){
              setState(() {
                list.removeLast();
              });
            }
          },
        )*/
      ],
    );
  }
}