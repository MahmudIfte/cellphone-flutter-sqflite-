import 'package:flutter/material.dart';
import 'package:cellphone/sqflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController productController = TextEditingController();
  final TextEditingController pidController = TextEditingController();
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Products List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: productController,
              decoration: const InputDecoration(
                hintText: 'Product Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: pidController,
              keyboardType: TextInputType.number,
              maxLength: 5,
              decoration: const InputDecoration(
                hintText: 'Product Id',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _addProduct,
                  child: const Text('Add'),
                ),
                ElevatedButton(
                  onPressed: _updateProduct,
                  child: const Text('Update'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<Product>>(
              future: dbHelper.getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final products = snapshot.data;
                  return products.isEmpty
                      ? const Text(
                    'No Products yet..',
                    style: TextStyle(fontSize: 22),
                  )
                      : Expanded(
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) =>
                          _getRow(products[index]),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _getRow(Product product) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
          product.id! % 2 == 0 ? Colors.deepPurpleAccent : Colors.purple,
          foregroundColor: Colors.white,
          child: Text(
            product.name[0],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(product.pid),
          ],
        ),
        trailing: SizedBox(
          width: 70,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  productController.text = product.name;
                  pidController.text = product.pid;
                  setState(() {
                    selectedIndex = product.id!;
                  });
                },
                child: const Icon(Icons.edit),
              ),
              InkWell(
                onTap: () {
                  _deleteProduct(product.id!);
                },
                child: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addProduct() async {
    String name = productController.text.trim();
    String pid = pidController.text.trim();

    if (name.isNotEmpty && pid.isNotEmpty) {
      final product = Product(name: name, pid: pid);
      await dbHelper.insertProduct(product);

      setState(() {
        productController.text = '';
        pidController.text = '';
      });
    }
  }

  void _updateProduct() async {
    String name = productController.text.trim();
    String pid = pidController.text.trim();

    if (name.isNotEmpty && pid.isNotEmpty && selectedIndex != -1) {
      final updatedProduct = Product(id: selectedIndex, name: name, pid: pid);
      await dbHelper.updateProduct(updatedProduct);

      setState(() {
        productController.text = '';
        pidController.text = '';
        selectedIndex = -1;
      });
    }
  }

  void _deleteProduct(int id) async {
    await dbHelper.deleteProduct(id);

    setState(() {
      selectedIndex = -1;
    });
  }
}
