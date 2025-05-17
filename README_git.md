# 🛒 Changuito

**Changuito** es una aplicación móvil desarrollada con Flutter que permite a los usuarios cargar tickets de compra (en formato PDF o imagen), extraer texto mediante OCR (ML Kit) y almacenar los datos en Firebase para su análisis y organización.

---

## 🚀 Funcionalidades principales

- 📸 Carga de tickets desde cámara o archivos
- 🧠 Procesamiento de texto con Google ML Kit (OCR)
- ☁️ Almacenamiento seguro en Firebase Storage y Firestore
- 🛍 Identificación automática de mercado, fecha y contenido del ticket

---

## 🛠 Tecnologías utilizadas

- **Flutter** (Dart)
- **Firebase**: Auth, Firestore, Storage
- **Google ML Kit**: Text Recognition
- **Android SDK + Gradle**
- **Arquitectura limpia** con separación de widgets, services y screens

---

## ⚙️ Requisitos previos

- Flutter 3.x instalado ([guía oficial](https://docs.flutter.dev/get-started/install))
- Android Studio o VS Code
- Una cuenta de Firebase y proyecto configurado
- Archivos de configuración descargados:
  - `google-services.json` → `android/app/`
  - `GoogleService-Info.plist` → `ios/Runner/`

> Estos archivos están **excluidos del repositorio** por seguridad.

---

## 🧪 Cómo ejecutar el proyecto

```bash
git clone https://github.com/tu-usuario/changuito.git
cd changuito
flutter pub get
flutter run

## 🧪 Estructura del proyecto

lib/
├── models/              # Modelos de datos (ej: Market)
├── services/            # Servicios de Firebase, OCR y procesamiento
├── screens/             # Pantallas principales (Login, Home, etc.)
├── widgets/             # Componentes reutilizables (botones, banners)
├── main.dart            # Punto de entrada e inicialización Firebase


## 🧪 Seguridad
Las claves y archivos sensibles están excluidos vía .gitignore.

Firebase se inicializa de forma robusta para evitar errores [duplicate-app].