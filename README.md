# Course Explorer v2

Praktikum Pemrograman Mobile — Pertemuan 6
**State Management & Mobile Application Architecture**

- **Nama:** Syaeful Darmawan
- **NIM:** 2415051059
- **Program Studi:** Pendidikan Teknik Informatika
- **Universitas:** Universitas Pendidikan Ganesha

---

## Deskripsi

Course Explorer v2 adalah aplikasi Flutter yang menampilkan daftar
mata kuliah dengan fitur:

- Responsive layout (compact / medium / expanded)
- Adaptive navigation (NavigationBar ↔ NavigationRail)
- Shared favorites lintas screen
- Async loading / error / success state
- Form feedback dengan validasi

Aplikasi ini adalah hasil refactor dari Course Explorer v1
(Pertemuan 5) dengan penambahan **state management** dan
**layered architecture**.

---

## Arsitektur

Arah dependency:

    UI (Screens/Widgets)
        ↓
    Provider (CourseProvider, CourseState)
        ↓
    Repository (CourseRepository)
        ↓
    Service (CourseService)
        ↓
    JSON / API / DB

**Aturan:**
- UI **tidak** boleh mengakses `rootBundle` atau `jsonDecode` langsung.
- Service **tidak** boleh mengandung `Widget` atau `BuildContext`.
- Provider **tidak** boleh menyimpan `BuildContext`.
- Repository hanya menjadi perantara; tidak melakukan I/O sendiri.

---

## Struktur Folder

    lib/
    ├── main.dart
    ├── constants.dart
    ├── models/
    │   └── course.dart
    ├── services/
    │   └── course_service.dart
    ├── repositories/
    │   └── course_repository.dart
    ├── providers/
    │   ├── course_state.dart
    │   └── course_provider.dart
    ├── screens/
    │   ├── main_shell.dart
    │   ├── home_tab.dart
    │   ├── courses_tab.dart
    │   ├── favorites_tab.dart
    │   ├── profile_tab.dart
    │   └── course_detail_page.dart
    └── widgets/
        ├── common_widgets.dart
        ├── course_card.dart
        ├── counter_demo.dart
        └── feedback_form.dart

---

## Tanggung Jawab Tiap Layer

| Layer | File | Tanggung Jawab |
|---|---|---|
| Entry point | `main.dart` | Setup `MultiProvider`, jalankan app |
| Model | `models/course.dart` | Representasi data + parsing JSON |
| Service | `services/course_service.dart` | Baca asset JSON |
| Repository | `repositories/course_repository.dart` | Abstraksi data source |
| Provider (state) | `providers/course_state.dart` | Shared favorites |
| Provider (async) | `providers/course_provider.dart` | Loading/Error/Success |
| Screens | `screens/*.dart` | Halaman & navigasi |
| Widgets | `widgets/*.dart` | Komponen reusable |

---

## State Management

- **`CourseState`** — `ChangeNotifier` untuk favorites (shared state).
- **`CourseProvider`** — `ChangeNotifier` untuk data course + loading/error.
- **`ValueNotifier<int>`** — demo `CounterDemo` (local listener).
- **`setState`** — untuk local state seperti toggle summary di Home.

**Akses Provider:**
- `context.watch<T>()` — saat UI perlu rebuild saat state berubah.
- `context.read<T>()` — untuk aksi imperatif (button callback).
- `Consumer<T>` — untuk mempersempit area rebuild.

---

## Cara Menjalankan

    flutter pub get
    flutter run -d chrome

---

## Uji Fungsional

| Fitur | Cara Uji |
|---|---|
| Loading state | Reload app, amati spinner |
| Error state | Ubah path asset jadi salah, reload |
| Success state | Tab Courses tampil list course |
| Favorites shared | Tap ❤️ di Courses → cek di Home, Favorites, Profile |
| Detail page | Tap course card → masuk Detail |
| Form feedback | Tab Profile → isi form → Kirim → Dialog → Loading → SnackBar |
| Responsive | Ubah lebar Chrome < 840 vs ≥ 840 |
| Adaptive nav | Compact: NavigationBar; Expanded: NavigationRail |
| Master-detail | Expanded + tab Courses: 2 panel |

---

## Lisensi

Praktikum akademik — Universitas Pendidikan Ganesha.

## Audit Architecture

Tanggung jawab tiap folder:

| Folder | Tanggung Jawab | Dependency |
|---|---|---|
| `models/` | Representasi data + parsing JSON | Tidak ada |
| `services/` | Baca data dari sumber (JSON/API) | `models/` |
| `repositories/` | Abstraksi data source | `models/`, `services/` |
| `providers/` | State management + business logic | `models/`, `repositories/` |
| `screens/` | Halaman & navigasi | `models/`, `providers/`, `widgets/` |
| `widgets/` | Komponen reusable | `models/` (opsional) |

**Arah dependency:** `UI → Provider → Repository → Service → Data Source`

**Aturan yang divalidasi:**
- Tidak ada `rootBundle` / `jsonDecode` di folder `screens/` atau `widgets/`
- Tidak ada `BuildContext` di folder `providers/`, `services/`, `repositories/`
- Tidak ada `Widget` di folder `services/` atau `repositories/`
- Tidak ada circular dependency antar layer

---

## Dokumentasi API (Pertemuan 7)

**Endpoint Latihan:** `https://jsonplaceholder.typicode.com/posts`
**HTTP Method:** `GET`
**Status Code:** `200 OK`
**Resource:** Array of Posts (di-map menjadi Course di aplikasi)

**Struktur JSON (contoh 1 item):**
```json
{
  "userId": 1,
  "id": 1,
  "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
  "body": "quia et suscipit\nsuscipit..."
}