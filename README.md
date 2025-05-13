# changuito_demo 🛒

Changuito es una aplicación Flutter para móviles que permite a los usuarios **subir tickets de supermercado en formato PDF o imagen**, extraer automáticamente el texto con OCR (reconocimiento óptico de caracteres) y almacenar los resultados en Firebase.

---

## ✨ Funcionalidades principales

- 📤 Carga de tickets en formato **PDF o imagen** (`jpg`, `jpeg`, `png`)
- 🔁 Conversión automática de PDF a imagen (una imagen por página)
- 🔍 Extracción de texto mediante **Google ML Kit OCR**
- ☁️ Almacenamiento de archivos en **Firebase Storage**
- 🧾 Registro de metadatos en **Cloud Firestore** (usuario, fecha, nombre, URL)
- ✅ Indicador visual de éxito al procesar

---

## 🧠 Flujo de procesamiento

1. El usuario selecciona un archivo con el botón **"Subir Ticket"**.
2. El archivo se guarda localmente y se muestra su nombre.
3. Al presionar **"Procesar Ticket"**:
   - Se sube a Firebase Storage.
   - Se registra el ticket en Firestore.
   - Si es un PDF, se convierte en imágenes (`pdfx`).
   - Si es imagen, se usa directamente.
   - Se aplica OCR con `google_mlkit_text_recognition`.
   - Se guarda una copia del texto extraído en un archivo temporal (`ticket_debug.txt`).

---

## 🛠️ Dependencias clave

```yaml
pdfx: ^2.4.0  
google_mlkit_text_recognition: ^0.8.0  
firebase_core, firebase_storage, cloud_firestore, firebase_auth  
file_picker, path_provider, http  
