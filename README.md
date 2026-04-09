# AndraFM All-in-One IT Toolkit (PowerShell + IRM)

Toolkit ini dibuat untuk kebutuhan IT harian dengan GUI interaktif (Windows Forms) langsung dari PowerShell.

## 1) File Structure

- `ITToolkit.ps1` -> script utama GUI Toolkit (tab: Maintenance, Networking, Security, Update)
- `bootstrap.ps1` -> loader kecil untuk skenario `irm ... | iex`
- `maintenance-configs/*.ps1` -> setiap konfigurasi maintenance dipisah per file
- `networking-configs/*.ps1` -> konfigurasi modular tab Networking
- `security-configs/*.ps1` -> konfigurasi modular tab Security
- `update-configs/*.ps1` -> konfigurasi modular tab Update

## 2) Cara Pakai Lokal

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\ITToolkit.ps1
```

## 3) Cara Pakai via IRM

1. Upload `ITToolkit.ps1` dan `bootstrap.ps1` ke GitHub repo public.
2. Ambil raw URL `bootstrap.ps1`.
3. Jalankan command ini:

```powershell
irm "https://raw.githubusercontent.com/<username>/<repo>/<branch>/bootstrap.ps1" | iex
```

## 4) Security Notes (Recommended)

- Jangan pakai URL yang tidak kamu kontrol.
- Pin ke branch/tag tertentu (hindari URL mutable tanpa kontrol).
- Tambahkan checksum validation jika mau lebih aman.
- Idealnya script ditandatangani code signing certificate.

## 5) Current GUI Scope

Tab `Maintenance` berisi group `Auto Maintenance` dengan checklist:

- Create Restore Point
- Delete Temporary File
- Delete Prefetch File
- Run Disk Cleanup
- Set Services to Manual

Tab `Networking` berisi group `Auto Networking` (contoh awal):

- Flush DNS Cache
- Renew IP Address

Tab `Security` berisi group `Auto Security` (contoh awal):

- Enable Windows Firewall (All Profiles)
- Quick Microsoft Defender Scan

Tab `Update` berisi group `Auto Update` (contoh awal):

- Open Windows Update Settings
- Winget Upgrade All

Arsitektur tetap modular: setiap item checklist punya script sendiri di folder kategori masing-masing.
