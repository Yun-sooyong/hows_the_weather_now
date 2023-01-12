import 'package:flutter/material.dart';

Widget drawer(BuildContext context) {
  //bool valueSwitch = false;
  return Drawer(
    backgroundColor: Colors.grey[100],
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          ListTile(
            title: const Text(
              '라이선스 공지',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              dialogBox(context);
            },
          ),
          // ListTile(
          //   title: const Text(
          //     '습도 표시',
          //     style: TextStyle(color: Colors.black),
          //   ),
          //   trailing: Switch(
          //     value: valueSwitch,
          //     onChanged: (value) => value,
          //   ),
          //   onTap: () {},
          // ),
        ],
      ),
    ),
  );
}

Future dialogBox(BuildContext context) {
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('라이선스'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Icon Pack'),
                  Text(
                    'Weather Color icon pack by Sihan Liu [ICONFINDER]',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                child: const Text('Flutter Package'),
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LicensePage())),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('확인'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
