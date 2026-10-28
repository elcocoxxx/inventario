import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:inventario/menuprincipal/productos/productos_page.dart';

import 'menuprincipal/clientes/clientes_page.dart';
import 'menuprincipal/factura/facturas_page.dart';
import 'menuprincipal/cortes/cortes_page.dart';
import 'menuprincipal/barberos/barberos_page.dart';
import 'menuprincipal/barberos/caja_barbero_page.dart';
import 'menuprincipal/servicios/servicios_page.dart';
import 'menuprincipal/gastos/gastos_ingreso.dart';
import 'shared/theme/app_colors.dart';
import 'shared/theme/app_spacing.dart';
import 'shared/widgets/app_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Cerrar sesión
  Future<void> _logout() => FirebaseAuth.instance.signOut();

  // Abrir una pantalla desde el cuerpo (no hay drawer que cerrar)
  void _open(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  // Abrir una pantalla desde el drawer (primero se cierra el drawer)
  void _openFromDrawer(BuildContext context, Widget? page) {
    Navigator.pop(context);
    if (page != null) _open(context, page);
  }

  String _userName() {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName;
    if (name != null && name.trim().isNotEmpty) return name.split(' ').first;
    return user?.email?.split('@').first ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _drawerMenu(context),
      appBar: AppBar(
        title: const Text('Barbería'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            color: AppColors.textSecondary,
            tooltip: 'Cerrar sesión',
            onPressed: _logout,
          ),
          AppSpacing.w4,
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: AppSpacing.screenPadding,
            children: [
              _header(),
              AppSpacing.h20,
              _statsRow(),
              AppSpacing.h24,
              _sectionTitle('Acciones rápidas'),
              AppSpacing.h12,
              _quickActions(context),
              AppSpacing.h24,
              _sectionTitle('Actividad general'),
              AppSpacing.h12,
              _activityChart(),
              AppSpacing.h16,
            ],
          ),
        ),
      ),
    );
  }

  // ================= DRAWER =================
  Widget _drawerMenu(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.soft(AppColors.primary),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.content_cut,
                        color: AppColors.primary),
                  ),
                  AppSpacing.w12,
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Barbería',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Panel de gestión',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _drawerItem(context, Icons.dashboard_rounded, 'Inicio', null,
                      selected: true),
                  _drawerItem(context, Icons.people_alt_rounded, 'Clientes',
                      const ClientesPage()),
                  _drawerItem(context, Icons.inventory_2_rounded, 'Productos',
                      const ProductosPage()),
                  _drawerItem(context, Icons.content_cut, 'Cortes',
                      const CortesPage()),
                  _drawerItem(context, Icons.person_rounded, 'Barberos',
                      const BarberosPage()),
                  _drawerItem(context, Icons.storefront_rounded, 'Servicios',
                      const ServiciosPage()),
                  _drawerItem(context, Icons.point_of_sale_rounded,
                      'Caja por barbero', const CajaBarberoPage()),
                  _drawerItem(context, Icons.account_balance_wallet_rounded,
                      'Gastos e ingresos', const GastosIngresosPage()),
                  _drawerItem(context, Icons.receipt_long_rounded,
                      'Facturación', const FacturasPage()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String text,
    Widget? page, {
    bool selected = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: ListTile(
        selected: selected,
        selectedColor: AppColors.primary,
        selectedTileColor: AppColors.soft(AppColors.primary, 28),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(icon),
        title: Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        onTap: () => _openFromDrawer(context, page),
      ),
    );
  }

  // ================= CABECERA =================
  Widget _header() {
    final name = _userName();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name.isEmpty ? 'Bienvenido' : 'Hola, $name',
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
        ),
        AppSpacing.h4,
        const Text(
          'Resumen general de tu barbería',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    );
  }

  // ================= ESTADÍSTICAS =================
  Widget _statsRow() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _StatCard(
            collection: 'clientes',
            title: 'Clientes',
            icon: Icons.people_alt_rounded,
            color: AppColors.accentPink,
          ),
        ),
        AppSpacing.w12,
        Expanded(
          child: _StatCard(
            collection: 'barberos',
            title: 'Barberos',
            icon: Icons.person_rounded,
            color: AppColors.primary,
          ),
        ),
        AppSpacing.w12,
        Expanded(
          child: _StatCard(
            collection: 'servicios',
            title: 'Servicios',
            icon: Icons.storefront_rounded,
            color: AppColors.accentAmber,
          ),
        ),
      ],
    );
  }

  // ================= ACCIONES RÁPIDAS =================
  Widget _quickActions(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: _QuickAction(
              icon: Icons.content_cut,
              label: 'Nuevo corte',
              color: AppColors.primary,
              onTap: () => _open(context, const CortesPage()),
            ),
          ),
          Expanded(
            child: _QuickAction(
              icon: Icons.person_add_alt_1_rounded,
              label: 'Nuevo barbero',
              color: AppColors.accentPurple,
              onTap: () => _open(context, const BarberosPage()),
            ),
          ),
          Expanded(
            child: _QuickAction(
              icon: Icons.storefront_rounded,
              label: 'Nuevo servicio',
              color: AppColors.accentAmber,
              onTap: () => _open(context, const ServiciosPage()),
            ),
          ),
        ],
      ),
    );
  }

  // ================= GRÁFICO =================
  Widget _activityChart() {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(8, 20, 20, 12),
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            minY: 0,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) =>
                  FlLine(color: AppColors.border, strokeWidth: 1),
            ),
            titlesData: FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                color: AppColors.primary,
                barWidth: 3,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withAlpha(90),
                      AppColors.primary.withAlpha(0),
                    ],
                  ),
                ),
                spots: const [
                  FlSpot(0, 1),
                  FlSpot(1, 2),
                  FlSpot(2, 1.5),
                  FlSpot(3, 3),
                  FlSpot(4, 2.5),
                  FlSpot(5, 4),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================
// Widgets privados del dashboard
// ======================================================

class _StatCard extends StatelessWidget {
  final String collection;
  final String title;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.collection,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.soft(color),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          AppSpacing.h16,
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection(collection).snapshots(),
            builder: (_, snapshot) {
              final count = snapshot.hasData ? '${snapshot.data!.docs.length}' : '–';
              return Text(
                count,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              );
            },
          ),
          AppSpacing.h4,
          Text(
            title,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.soft(color),
              child: Icon(icon, color: color),
            ),
            AppSpacing.h8,
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
