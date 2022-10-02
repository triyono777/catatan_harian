import 'package:catatan_harian/services/firebase_db_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<QuerySnapshot<Map<String, dynamic>>> getData() async {
    var box = await Hive.openBox('userBox');
    var uid = await box.get('uid');
    setState(() {});
    return await FirebaseDBServices().getCatatan(uid);
  }

  TextEditingController judulController = TextEditingController();
  TextEditingController isiController = TextEditingController();
  addCatatan(BuildContext context) async {
    var hasil = await showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              contentPadding: EdgeInsets.all(8),
              title: Text('Add Catatan'),
              children: [
                TextField(
                  controller: judulController,
                  decoration: InputDecoration(
                    labelText: 'judul',
                    hintText: 'Masukkan judul',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: isiController,
                  decoration: InputDecoration(
                    labelText: 'isi',
                    hintText: 'Masukkan isi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SimpleDialogOption(
                      child: Text('Simpan'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      padding: EdgeInsets.all(8),
                    ),
                    SimpleDialogOption(
                      child: Text('Batal'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      padding: EdgeInsets.all(8),
                    ),
                  ],
                ),
              ],
            ));
    if (hasil == true) {
      FirebaseDBServices()
          .addCatatan(
        judulCatatan: judulController.text,
        isiCatatan: isiController.text,
      )
          .then((value) {
        setState(() {});
      });
    }
  }

  editCatatan(BuildContext context,
      {required String? uidCatatn, String? judul, String? isi}) async {
    judulController.text = judul ?? '';
    isiController.text = isi ?? '';
    var hasil = await showDialog(
        context: context,
        builder: (_) => SimpleDialog(
              contentPadding: EdgeInsets.all(8),
              title: Text('Edit Catatan'),
              children: [
                TextField(
                  controller: judulController,
                  decoration: InputDecoration(
                    labelText: 'judul',
                    hintText: 'Masukkan judul',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: isiController,
                  decoration: InputDecoration(
                    labelText: 'isi',
                    hintText: 'Masukkan isi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SimpleDialogOption(
                      child: Text('Simpan'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      padding: EdgeInsets.all(8),
                    ),
                    SimpleDialogOption(
                      child: Text('Batal'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      padding: EdgeInsets.all(8),
                    ),
                  ],
                ),
              ],
            ));
    if (hasil == true) {
      FirebaseDBServices()
          .editCatatan(
        uidCatatan: uidCatatn,
        judulCatatan: judulController.text,
        isiCatatan: isiController.text,
      )
          .then((value) {
        setState(() {});
      });
    }
    judulController.clear();
    isiController.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    // getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addCatatan(context);
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<QuerySnapshot>(
          future: getData(),
          builder: (context, snapshot) {
            print(snapshot.connectionState);
            if (snapshot.connectionState == ConnectionState.active) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.done) {
              return Text('done');
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Text('none');
            } else if (snapshot.data?.docs.isEmpty ?? true) {
              return Center(child: Text('No data'));
            } else if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.data?.docs.isNotEmpty ?? true) {
              return ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: snapshot.data?.docs.length ?? 0,
                itemBuilder: (_, index) {
                  var data = snapshot.data;
                  return Dismissible(
                    key: Key('${data?.docs[index]}'),
                    background: Container(
                      color: Colors.red,
                    ),
                    confirmDismiss: (_) async {
                      FirebaseDBServices().deleteCatatan(data?.docs[index].id);
                      return true;
                    },
                    onDismissed: (_) {
                      // showDialog(context: context, builder: );
                    },
                    child: Card(
                      child: ListTile(
                        title: Text('${data?.docs[index]['judul']}'),
                        subtitle: Text('tanggal catatan'),
                        trailing: IconButton(
                          onPressed: () {
                            editCatatan(context,
                                uidCatatn: '${data?.docs[index].id}',
                                judul: '${data?.docs[index]['judul']}',
                                isi: '${data?.docs[index]['isi']}');
                          },
                          icon: Icon(Icons.edit),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
