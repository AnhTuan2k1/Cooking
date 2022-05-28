import 'package:cooking/resource/firestore_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/user.dart';
import 'others_account_page.dart';

String urlDragonAvatar =
    'https://firebasestorage.googleapis.com/v0/b/cooking-afe47.appspot.com/o/others%2Fdragon-100.png?alt=media&token=0b205c77-90cf-45be-80aa-2a4820777d0b';

class FollowingPage extends StatelessWidget {
  const FollowingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder<List<User>>(
        future: FirestoreApi.getAllFollowingUser(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 72,
            );
          } else if (snapshot.hasData) {
            return buildUsers(snapshot.data!);
          } else if (snapshot.hasError) {
            print(snapshot.error.toString() + 'following page');
            return const SizedBox(
              height: 72,
            );
          } else {
            return buildNoneUser();
          }
        },
      ),
    );
  }

  Widget buildUsers(List<User> list) {
    if (list.isEmpty) return buildNoneUser();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              '${list.length} following',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OtherAccountPage(user: list[index]))),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                  list[index].imageUrl ?? urlDragonAvatar,
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                  child: Text(
                                list[index].name ?? "no name",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )),
                            ],
                          ),
                        ),
                        Container(
                          //width: 100,
                          margin: const EdgeInsets.only(right: 8.0, left: 8.0),
                          child: buildFollowing(list[index].id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNoneUser() {
    return const Center(
      child: Text(
        'Bạn chưa theo dõi ai cả 🙄',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildFollowing(String userId) {
    return GestureDetector(
      onTap: () {
        FirestoreApi.updateFollowing(userId);
      },
      child: StreamBuilder<bool>(
          stream: FirestoreApi.isFollowing(userId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // print('-------------folow1----------');
              return buildFollow(snapshot.data ?? true);
            } else {
              print('-------------Show folow error----------');
              return buildFollow(snapshot.data ?? false);
            }
          }),
    );
  }

  buildFollow(bool isfollow) {
    Color color = isfollow ? Colors.lightGreen : Colors.black45;
    return SizedBox(
      width: 120,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(
          Icons.stars_sharp,
          color: color,
        ),
        FittedBox(
          child: Text(
            isfollow ? " Đang theo dõi" : " Theo dõi",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13, color: color),
          ),
        )
      ]),
    );
  }
}

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }
