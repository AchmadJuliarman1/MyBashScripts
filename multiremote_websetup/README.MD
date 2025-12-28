# Dokumentasi Belajar Vagrant (Cloud Computing & DevOps)

Dokumentasi ini berisi langkah-langkah setup lab **Vagrant** dengan satu VM **scriptbox** dan tiga VM **web** (web01, web02, web03). Tujuan lab ini adalah melatih otomasi dan distribusi konfigurasi ke banyak server (konsep dasar DevOps & Cloud).

---

## Topologi Singkat

- **scriptbox** : node kontrol (menjalankan dan mendistribusikan script)
- **web01** : 192.168.10.13
- **web02** : 192.168.10.14
- **web03** : 192.168.10.15

---

## Setup Awal

Jalankan dari **host**:

```bash
vagrant up
```

Masuk ke VM **scriptbox**:

```bash
vagrant ssh scriptbox
sudo -i
```

Edit file hosts:

```bash
vim /etc/hosts
```

Tambahkan:

```text
192.168.10.13 web01
192.168.10.14 web02
192.168.10.15 web03
```

---

## Pembuatan User di VM Web

Lakukan pada masing-masing VM web.

### VM web01

```bash
useradd devops
passwd devops
```

### VM web02

```bash
useradd devops
passwd devops
```

### VM web03

```bash
useradd devops
passwd devops
```

> Catatan: `useradd` dan `adduser` berbeda tergantung distro. Untuk konsistensi, digunakan `useradd`.

---

## Setup SSH Key (Passwordless SSH)

Lakukan di **scriptbox**:

```bash
ssh-keygen
```

Salin SSH key ke seluruh VM web:

```bash
ssh-copy-id devops@web01
ssh-copy-id devops@web02
ssh-copy-id devops@web03
```

---

## Direktori Script

Buat direktori kerja di **scriptbox**:

```bash
mkdir -p /opt/scripts/remote_websetup
```

---

## Alur Pengelolaan Script

Pembuatan dan perubahan script dilakukan di **host** agar lebih mudah.

Alur kerja:

```
script (host)
   ↓
copy ke scriptbox
   ↓
scriptbox mendistribusikan ke web01/web02/web03
```

---

## Copy File dari Host ke Scriptbox

Generate konfigurasi SSH Vagrant (di **host**):

```bash
vagrant ssh-config > vagrant_ssh_config
```

Copy file ke **scriptbox**:

```bash
scp -F vagrant_ssh_config setup.sh  scriptbox:/opt/scripts/remote_websetup/
scp -F vagrant_ssh_config deploy.sh scriptbox:/opt/scripts/remote_websetup/
scp -F vagrant_ssh_config remhosts  scriptbox:/opt/scripts/remote_websetup/
```

---

## Menjalankan Script

Masuk ke **scriptbox**, lalu jalankan:

```bash
cd /opt/scripts/remote_websetup
chmod +x deploy.sh
./deploy.sh
```

---

## Catatan Tambahan

- **scriptbox** berperan seperti _bastion host_ atau _control node_ (mirip Ansible controller).
- Setup ini mensimulasikan proses deployment terpusat ke banyak server.
- Cocok sebagai latihan awal sebelum menggunakan tools seperti **Ansible**, **Terraform**, atau **CI/CD pipeline**.

---

✅ Dokumentasi ini ditujukan untuk pembelajaran pribadi dan eksplorasi konsep **Cloud Computing** serta **DevOps** menggunakan Vagrant.
