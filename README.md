---
defaults: github-markdown
toc: false
---
<!-- *********************************************************************** -->
# matrixxx-os-build
- This repository is primarily a shell script collection to generate a
  customized OS for matrixxx (a D.I.Y linux live system)
  - scripts to download debian packages and install these in images
  - the compilation is ensured by special configuration files
  - as well as the selection of the debian suite (stable testing unstable
    experimental) and the possible software categories (main contrib
    non-free non-free-firmware)
- The result are several squasfs images which contains a customized os
  for x86 32-bit and 64-bit versions

## Other necessary components:
- boot-device-content repository (contains the initramfs with busybox and
  a specially produced kernel)
- remaster repository which contains the scripts for the configuration of
  the OS

#### briefly:
- see [readme: about][]
- see [readme: usage][]

#### links:
- home page of [debian.org][debian]

#### license:
- *GNU GENERAL PUBLIC LICENSE* [[text]](LICENSE)

<!-- *********************************************************************** -->
[readme: about]: doc/readme-matrixxx.md
[readme: usage]: doc/readme-usage.md

[debian]: https://www.debian.org

********************************************************************************
> [!WARNING]
> **DISCLAIMER:** THIS IS EXPERIMENTAL SOFTWARE. USE AT YOUR OWN RISK. THE
> AUTHOR CAN NOT BE HELD LIABLE UNDER ANY CIRCUMSTANCES FOR DAMAGE TO HARDWARE
> OR SOFTWARE, LOST DATA, OR OTHER DIRECT OR INDIRECT DAMAGE RESULTING FROM THE
> USE OF THIS SOFTWARE.
> YOU ARE RESPONSIBLE FOR YOUR OWN COMPLIANCE WITH ALL APPLICABLE LAWS.

********************************************************************************
> [!NOTE]
> All markdown files contain a `pandoc` specific extension:
> **yaml_metadata_block**. This block is displayed as a table by GitHub,
> but is useful (for me) for checking the appearance.

> [!NOTE]
> Regarding external links:
> This description may contain links to external websites operated by third
> parties, over which I have no control. Therefore, I cannot be held responsible
> for the content of these external websites. The sole responsibility for the
> content of these linked pages lies with the respective provider or operator.

********************************************************************************
