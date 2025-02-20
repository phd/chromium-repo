Chromium .deb repositories for Ubuntu 20.04+
============================================


Repositories for Chromium browser .deb packages originally released by Linux Mint.

Supported Ubuntu releases:

  * Ubuntu 20.04 Focal (LTS)
  * Ubuntu 22.04 Jammy (LTS)
  * Ubuntu 22.10 Kinetic (EOL)
  * Ubuntu 23.04 Lunar (EOL)
  * Ubuntu 23.10 Mantic (EOL)
  * Ubuntu 24.04 Noble (LTS)
  * Ubuntu 24.10 Oracular
  * Ubuntu 25.04 Plucky (unreleased)


Installation:
-------------

    $ sudo wget 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x869689FE09306074' \
      -O '/etc/apt/trusted.gpg.d/phd-chromium.asc'

    $ echo "deb https://freeshell.de/phd/chromium/$(lsb_release -sc) /" \
      | sudo tee /etc/apt/sources.list.d/phd-chromium.list

    $ sudo apt-get update

    $ sudo apt-get remove chromium-browser

    $ sudo apt-get install chromium


Signing key renewal:
--------------------

    $ sudo wget 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x869689FE09306074' \
      -O '/etc/apt/trusted.gpg.d/phd-chromium.asc'


Repository:
-----------

The repository is hosted at https://freeshell.de/phd/chromium/.


Source code:
------------

Visit https://github.com/phd/chromium-repo for a full source code.
