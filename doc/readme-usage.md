---
defaults: github-markdown
toc: false
---
<!-- *********************************************************************** -->
# os-build usage
- This shell script collection can be used to generate a customized OS for
  matrixxx (a D.I.Y linux live system)
- To make this possible, the scripts create a `chroot` environment in which the
  operating system is generated.
- This `chroot` environment is contained within a `qcow` image.
  - Note: QEMU QCOW Image (v3) is a self-growth image;
    here limited to 12GB; compressed < 4GB - file size limit for FAT32
- To process essentially 'unlimited' amounts of data, multiple `qcow` images
  are combined into a UnionFs (here `aufs`) and written to sequentially
  (the `chroot` environment only ever sees the UnionFs).
  - Note: Specific configuration files will be used for the desired operating
    system packages, which will be distributed across the `qcow` images.
    Ensure that the 12 GB limit for `qcow` images is not exceeded.

> [!NOTE]
> **Debian** and its repositories are used to build the operating system.
> The defined software categories are `main`, `contrib`, and
> `non-free-firmware`. The configured Debian suite is `testing`.
> `debootstrap --variant=minbase` is used as the base OS builder.
> The base desktop environment is intended to be `LXDE` or `LXQT`.
> (All these default settings can be adjusted with minimal effort)

### Configuration of the OS
- As an example, `categories_standard` in the `/SCRIPTS` subdirectory should
  be used here, which must be unpacked here from the release
- Check whether the `categories` link points to this directory.
  (This can be done with the bash script `script-set-working-link.sh`.
  This can also be done with your own directories - all you have to do is
  to insert the name into the script)
- Currently the structure is designed so that four `qcow` images
  (with scripts A-D) + an additional (N) for testing new features can be
  created. The layers that are created count from 1-5.

### Script structure:
```
.
├── lib                                     - bash function libraries for the host system
├── perl
│   └── log-file-evaluation.pl              - searching for patterns in a sections of a log file
├── SCRIPTS                                 - bash scripts and function libraries for a chroot environment
│   └── categories                          - location of the configuration files for the OS structure
├── system_debian                           - basic configuration of the Debian system (including an empty qcow-image)
├── 00-build-system-configuration.sh        - script only needed if the basic configuration of the OS needs to be adjusted
├── init                                    - basic configuration of the host system scripts
├── script-log-file-evaluation.sh           - Called script: Evaluates the log files for errors and incompatibilities that occurred.
└── xx-build.sh                             - Script that executes the build process
```

#### Bash function libraries for the host system
```
.
└── lib
    ├── func_chroot-handling
    ├── func-debootstrap-handling
    ├── func_install-handling
    ├── func_layer-handling
    ├── func_mk-squashfs-image-handling
    ├── func_qcow2-handling
    ├── func_script-logging-handling ->
    │     ../LIB/func_script-logging-handling
    ├── func_unionfs-handling
    ├── func_update-archive-handling
    └── func_virtual-device-handling
```

#### Bash function libraries for the chroot environment
```
.
└── SCRIPTS
    ├── LIB
    │   ├── func_apt-get-download-handling
    │   ├── func_apt-get-handling
    │   ├── func_category-file-handling
    │   ├── func_script-logging-handling
    │   ├── func_search-and-replace-handling
    │   └── system-baseconfig
    ├── 00-basical-config.sh
    ├── A1-apt-handler.sh
    ├── A2-apt-handler.sh
    ├── B1-apt-handler.sh
    ├── B2-apt-handler.sh
    ├── C1-apt-handler.sh
    ├── C2-apt-handler.sh
    ├── categories -> categories_...
    ├── D1-apt-handler.sh
    ├── D2-apt-handler.sh
    ├── script-apt-handler.sh
    ├── script-clean_up_package_lists.sh
    ├── script-dpkg-l.sh
    ├── script-set-working-link.sh
    └── script-update.sh
```

#### Debian default settings (including an empty qcow-image)
- rootfs.tar.gz contains the files with the Debian default settings and is
  included during the build process

```
.
└── system_debian
    ├── 12GB.qcow2.img
    ├── config-system-modernize
    │   └── rootfs.tar.gz
    ├── init_distribution
    ├── init--process-control
    ├── lib
    │   └── func_system-config-modernize
    └── list
```

********************************************************************************
> [!WARNING]
> **DISCLAIMER:** THIS IS EXPERIMENTAL SOFTWARE. USE AT YOUR OWN RISK. THE
> AUTHOR CAN NOT BE HELD LIABLE UNDER ANY CIRCUMSTANCES FOR DAMAGE TO HARDWARE
> OR SOFTWARE, LOST DATA, OR OTHER DIRECT OR INDIRECT DAMAGE RESULTING FROM THE
> USE OF THIS SOFTWARE.
> YOU ARE RESPONSIBLE FOR YOUR OWN COMPLIANCE WITH ALL APPLICABLE LAWS.

********************************************************************************
# Verwendung von `os-build`
- Diese Sammlung von Shell-Skripten kann verwendet werden, um ein angepasstes
  Betriebssystem für matrixxx (a D.I.Y linux live system) zu generieren.
- Um dies zu ermöglichen, erstellen die Skripte eine `chroot`-Umgebung, in der
  die Generierung des Betriebssystems stattfindet.
- Diese `chroot`-Umgebung ist in einem `qcow`-Image enthalten.
  - Hinweis: Das QEMU QCOW-Image (v3) ist ein selbstwachsendes Image;
    hier auf 12 GB beschränkt; komprimiert < 4 GB -
    Dateigrößenbeschränkung für FAT32
- Um praktisch 'unbegrenzte' Datenmengen zu verarbeiten werden mehrere
  `qcow`-Image in einem UnionFs (hier `aufs`) zusammengefasst und sequenziell
  beschrieben (die `chroot`-Umgebung sieht immer nur die UnionFs)
  - Hinweis: Mit Hilfe von speziellen Konfigurationsdateien, welche die
    gewünschten OS Pakete enthalten werden diese auf die `qcow`-Images verteilt.
    Dabei muss darauf geachtet werden, dass die 12 GB `qcow`-Image Begrenzung
    nicht überschritten wird

> [!NOTE]
> Für die Erzeugung des OS wird **Debian** und seine Quellen verwendet.
> Die definierten Software Kategorien sind `main` `contrib` und
> `non-free-firmware`. Die eingestellte debian suite ist `testing`.
> Als Basis OS Erzeugung wird `debootstrap --variant=minbase` verwendet.
> Als Basis Desktop Umgebung ist `LXDE` oder `LXQT` vorgesehen.
> (All diese Voreinstellungen sind mit wenig aufwand anpassbar)

### Konfiguration des OS
- Beispielhaft soll hier `categories_standard` im Unterverzeichnis `/SCRIPTS`
  dienen welches vom Release hierhin entpackt werden muss
- Es ist zu überprüfen, ob der Link `categories` auf dieses Verzeichnis zeigt.
  (Mit dem Bash-Skript `script-set-working-link.sh` lässt sich dies
  durchführen. Im übrigen lässt sich dies auch mit eigenen Verzeichnissen
  durchführen - dazu ist nur der Name in das Skript einzufügen)
- Momentan ist die Struktur so ausgelegt, dass vier `qcow`-Images
  (mit Skripten A-D) + einem zusätzlichen (N) für Tests von Neuerungen
  erzeugt werden können. Die Layer die dabei entstehen zählen von 1-5.

********************************************************************************
> [!WARNING]
> **DISCLAIMER:** DIES IST EXPERIMENTELLE SOFTWARE. DIE BENUTZUNG ERFOLGT AUF
> EIGENE GEFAHR. DER AUTOR KANN UNTER KEINEN UMSTÄNDEN HAFTBAR GEMACHT
> WERDEN FÜR SCHÄDEN AN HARD- UND SOFTWARE, VERLORENE DATEN UND ANDERE DIREKT
> ODER INDIREKT DURCH DIE BENUTZUNG DER SOFTWARE ENTSTEHENDE SCHÄDEN.
> FÜR DIE EINHALTUNG GESETZLICHER VORSCHRIFTEN SIND SIE SELBST VERANTWORTLICH.

********************************************************************************
