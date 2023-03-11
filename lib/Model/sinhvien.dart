import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SinhVienScreen extends StatefulWidget {
  const SinhVienScreen({Key? key}) : super(key: key);

  @override
  State<SinhVienScreen> createState() => _SinhVienScreenState();
}

class _SinhVienScreenState extends State<SinhVienScreen> {
  final TextEditingController _IdSinhVienController = TextEditingController();
  final TextEditingController _MaSinhVienController = TextEditingController();
  final TextEditingController _NgaySinhController = TextEditingController();
  final TextEditingController _GioiTinhController = TextEditingController();
  final TextEditingController _QueQuanController = TextEditingController();

  final CollectionReference _sinhvien =
      FirebaseFirestore.instance.collection('sinhvien');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _IdSinhVienController.text = documentSnapshot['IDSV'];
      _MaSinhVienController.text = documentSnapshot['MaSV'];
      _NgaySinhController.text = documentSnapshot['NgaySinh'];
      _GioiTinhController.text = documentSnapshot['GioiTinh'];
      _QueQuanController.text = documentSnapshot['QueQuan'];
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _IdSinhVienController,
                    decoration: const InputDecoration(labelText: 'IDSV'),
                  ),
                  TextField(
                    controller: _MaSinhVienController,
                    decoration: const InputDecoration(labelText: 'MaSV'),
                  ),
                  TextField(
                    controller: _NgaySinhController,
                    decoration: const InputDecoration(labelText: 'NgaySinh'),
                  ),
                  TextField(
                    controller: _GioiTinhController,
                    decoration: const InputDecoration(labelText: 'GioiTinh'),
                  ),
                  TextField(
                    controller: _QueQuanController,
                    decoration: const InputDecoration(labelText: 'QueQuan'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final String? IDSV = _IdSinhVienController.text;
                        final String? MaSV = _MaSinhVienController.text;
                        final String? NgaySinh = _NgaySinhController.text;
                        final String? GioiTinh = _GioiTinhController.text;
                        final String? QueQuan = _QueQuanController.text;

                        if (IDSV != null &&
                            MaSV != null &&
                            NgaySinh != null &&
                            GioiTinh != null &&
                            QueQuan != null) {
                          if (action == 'create') {
                            await _sinhvien.add({
                              'IDSV': IDSV,
                              'MaSV': MaSV,
                              'NgaySinh': NgaySinh,
                              'GioiTinh': GioiTinh,
                              'QueQuan': QueQuan,
                            });
                          }

                          if (action == 'update') {
                            await _sinhvien.doc(documentSnapshot!.id).update({
                              'IDSV': IDSV,
                              'MaSV': MaSV,
                              'NgaySinh': NgaySinh,
                              'GioiTinh': GioiTinh,
                              'QueQuan': QueQuan,
                            });
                          }

                          _IdSinhVienController.text = '';
                          _MaSinhVienController.text = '';
                          _NgaySinhController.text = '';
                          _GioiTinhController.text = '';
                          _QueQuanController.text = '';

                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(action == 'create' ? 'Create' : 'Update'))
                ],
              ),
            ),
          );
        });
  }

  Future<void> _deleteProduct(String productId) async {
    await _sinhvien.doc(productId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sinh Vien'),
      ),
      body: StreamBuilder(
        stream: _sinhvien.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if(streamSnapshot.hasData){
            return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index){
                  final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('IDSV: ' + documentSnapshot['IDSV']),
                            ],
                          ),
                        ),
                      ),
                      subtitle: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ma Sinh Vien: '+documentSnapshot['MaSV']),
                            Text('Gioi Tinh: '+documentSnapshot['GioiTinh']),
                            Text('Ngay Sinh: '+documentSnapshot['NgaySinh']),
                            Text('Que Quan: '+documentSnapshot['QueQuan']),
                          ],
                        ),
                      ),
                      trailing: SizedBox(
                        width: 100  ,
                        child: Row(
                          children: [
                            // Press this button to edit a single product
                            IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () =>
                                    _createOrUpdate(documentSnapshot)),
                            // This icon button is used to delete a single product
                            IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    _deleteProduct(documentSnapshot.id)),
                          ],
                        ),
                      ),
                    ),
                  );
            });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
