import 'package:flutter/material.dart';

class GastosIngresosPage extends StatelessWidget {
  const GastosIngresosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        title: const Text(
          "Finanzas",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [

            // SALDO
            Card(
              color: Colors.green.shade700,
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "Saldo Total",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "\$0",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [

                Expanded(
                  child: Card(
                    color: Colors.blue,
                    child: const Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Icon(Icons.arrow_downward,
                              color: Colors.white, size: 35),
                          SizedBox(height: 10),
                          Text(
                            "Ingresos",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "\$0",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Card(
                    color: Colors.red,
                    child: const Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Icon(Icons.arrow_upward,
                              color: Colors.white, size: 35),
                          SizedBox(height: 10),
                          Text(
                            "Gastos",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "\$0",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Cuentas",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            cuenta("💵 Caja", "\$0"),
            cuenta("🏦 Bancolombia", "\$0"),
            cuenta("📱 Nequi", "\$0"),
            cuenta("💳 Daviplata", "\$0"),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text("Registrar Ingreso"),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {},
                icon: const Icon(Icons.remove),
                label: const Text("Registrar Gasto"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cuenta(String nombre, String saldo) {
    return Card(
      color: const Color(0xFF1E1E1E),
      child: ListTile(
        title: Text(
          nombre,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: Text(
          saldo,
          style: const TextStyle(
            color: Colors.greenAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}