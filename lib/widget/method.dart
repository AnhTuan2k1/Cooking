import 'package:cooking/widget/images.dart';
import 'package:flutter/material.dart';

class Methods extends StatefulWidget {
  const Methods({Key? key}) : super(key: key);

  @override
  _MethodsState createState() => _MethodsState();
}

class _MethodsState extends State<Methods> {
  List<Widget> listStep = <Widget>[];
  List<Widget> listStepsImages = <Widget>[];

  @override
  void initState() {
    listStep.add(step(listStep.length));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Cách làm',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Column(children: listStep),
        const SizedBox(height: 10.0),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          GestureDetector(
            onTap: () => setState(() => listStep.add(step(listStep.length))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add),
                Text('Thêm bước',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => listStep.removeLast()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.remove),
                Text('Xóa bước',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ]),
      ],
    );
  }

  Widget step(int index) {
    return Column(
        children: [
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                (index + 1).toString(),
                style: TextStyle(color: Colors.white),
              ),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black45,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15),
                    filled: true,
                    hintText: 'Thịt rửa sạch để ráo và cắt nhỏ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 120, child: Images())
    ]);
  }
}
