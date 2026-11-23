<div align="center">

# ✂️ Inventario

### Sistema de gestión integral para barberías

Controla clientes, barberos, servicios, productos, ventas y caja desde un solo lugar.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![GitHub Pages](https://img.shields.io/badge/Demo-GitHub%20Pages-14B8A6?style=for-the-badge&logo=github&logoColor=white)](https://elcocoxxx.github.io/inventario/)

**[🚀 Ver demo en línea](https://elcocoxxx.github.io/inventario/)** · **[📄 Plan de negocio](docs/PLAN_DE_NEGOCIO.md)**

</div>

---

## 📌 Descripción

**Inventario** es una aplicación multiplataforma (web, Android y escritorio) creada para que una barbería pueda dejar el cuaderno y las hojas de cálculo y manejar su negocio de forma ordenada: quién atendió, qué servicio se hizo, cuánto se vendió, qué productos quedan y cuánto debe cada cliente.

Está construida con **Flutter** y usa **Firebase** como backend, por lo que los datos se sincronizan en tiempo real entre dispositivos.

## ✨ Funcionalidades

| Módulo | Qué permite |
|---|---|
| 🔐 **Autenticación** | Registro e inicio de sesión con correo y contraseña o con Google. |
| 📊 **Dashboard** | Resumen con totales de clientes, barberos y servicios, accesos rápidos y gráfico de actividad. |
| 👥 **Clientes** | Alta, edición y búsqueda de clientes, y listado de **clientes con deuda**. |
| 💈 **Barberos** | Gestión del equipo de trabajo. |
| 🛎️ **Servicios** | Catálogo de servicios que ofrece la barbería. |
| ✂️ **Cortes** | Registro de cada atención realizada. |
| 📦 **Productos** | Inventario, entradas de stock y reporte de inventario. |
| 🛒 **Ventas** | Venta de productos con confirmación y estado de pago. |
| 💵 **Caja por barbero** | Seguimiento de lo generado por cada barbero. |
| 💸 **Gastos e ingresos** | Registro de gastos e ingresos del negocio. |
| 🧾 **Facturación** | Módulo de facturas. |

## 🖼️ Capturas

> Agrega tus capturas en la carpeta `docs/screenshots/` y reemplaza estas rutas.

| Login | Dashboard | Menú |
|:---:|:---:|:---:|
| ![Login](docs/screenshots/login.png) | ![Dashboard](docs/screenshots/dashboard.png) | ![Menú](docs/screenshots/menu.png) |

## 🛠️ Tecnologías

- **Framework:** Flutter (Material 3, tema oscuro centralizado)
- **Lenguaje:** Dart
- **Autenticación:** Firebase Authentication + Google Sign-In
- **Base de datos:** Cloud Firestore (tiempo real)
- **Gráficos:** fl_chart
- **Formato de fechas y monedas:** intl
- **Imágenes de productos:** Cloudinary (vía `http`)
- **Despliegue:** GitHub Actions + GitHub Pages

## 🗂️ Estructura del proyecto

```
lib/
├── main.dart                  # Punto de entrada, tema y control de sesión
├── home_page.dart             # Dashboard y menú lateral
├── Login/                     # Inicio de sesión, registro y firebase_options
├── menuprincipal/
│   ├── barberos/              # Barberos y caja por barbero
│   ├── clientes/              # Clientes y clientes con deuda
│   ├── cortes/                # Registro de cortes
│   ├── factura/               # Facturación
│   ├── gastos/                # Gastos e ingresos
│   ├── productos/             # Productos, ventas, reporte y servicio de imágenes
│   └── servicios/             # Catálogo de servicios
└── shared/
    ├── theme/                 # Colores, espaciado, tipografías y ThemeData global
    └── widgets/               # Botones, tarjetas, campos y buscador reutilizables
```

### Colecciones de Firestore

`clientes` · `barberos` · `servicios` · `cortes` · `productos` · `entradas_stock` · `ventas`

## 🚀 Instalación y ejecución

### Requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (canal *stable*)
- Un proyecto de [Firebase](https://console.firebase.google.com) con **Authentication** (correo y Google) y **Firestore** activados
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/)

### Pasos

```bash
# 1. Clonar el repositorio
git clone https://github.com/elcocoxxx/inventario.git
cd inventario

# 2. Instalar dependencias
flutter pub get

# 3. Conectar tu proyecto de Firebase (genera lib/Login/firebase_options.dart)
flutterfire configure

# 4. Ejecutar
flutter run -d chrome      # web
flutter run                # dispositivo o emulador conectado
```

> ⚠️ **Seguridad:** nunca subas claves privadas ni secretos de Cloudinary al repositorio. Usa variables de entorno o un backend para firmar las subidas.

## 🌐 Despliegue

El proyecto se publica automáticamente en **GitHub Pages** con cada `push` a `main`, mediante el workflow `.github/workflows/deploy.yml`.

Para que el inicio de sesión funcione en la versión en línea, agrega `elcocoxxx.github.io` en
**Firebase → Authentication → Settings → Authorized domains**.

## 🔒 Seguridad recomendada

- Configura las **reglas de Firestore** para que solo usuarios autenticados lean y escriban datos.
- Restringe las claves de API en la consola de Google Cloud a tus dominios.

## 🗺️ Roadmap

- [ ] Exportar reportes a PDF y Excel
- [ ] Roles y permisos (administrador / barbero)
- [ ] Agenda de citas y recordatorios
- [ ] Multi-sucursal
- [ ] Reportes por rango de fechas y por barbero
- [ ] Pruebas automatizadas

## 👤 Autor

**[Tu nombre]** · [@elcocoxxx](https://github.com/elcocoxxx)

## 📄 Licencia

Distribuido bajo la licencia MIT. Consulta el archivo `LICENSE` para más información.
