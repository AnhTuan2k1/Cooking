import 'package:cooking/widget/images.dart';
import 'package:flutter/material.dart';

import '../model/method.dart';

class Methods extends StatefulWidget {
  Methods({required this.steps, Key? key}) : super(key: key);
  List<Method> steps;

  @override
  _MethodsState createState() => _MethodsState();
}

class _MethodsState extends State<Methods> {
  List<Widget> listStep = <Widget>[];
  //List<Widget> listStepsImages = <Widget>[];

  @override
  void initState() {
    widget.steps.add(Method((widget.steps.length + 1).toString(), '', null));
    widget.steps[widget.steps.length - 1].image = <String>[];
    listStep.add(step(widget.steps[listStep.length]));
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
            onTap: () => setState(() {
              widget.steps.add(Method((widget.steps.length + 1).toString(), '', null));
              widget.steps[widget.steps.length - 1].image = <String>[];
              listStep.add(step(widget.steps[listStep.length]));
            }),
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
            onTap: () => setState(() {
              widget.steps.removeLast();
              listStep.removeLast();
            }),
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

  Widget step(Method index) {
    return Column(
        children: [
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                index.stepid,
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
                  onChanged: (value) => index.content = value,
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
      SizedBox(height: 120, child: Images(image: widget.steps[int.parse(index.stepid) - 1].image))
    ]);
  }
}
