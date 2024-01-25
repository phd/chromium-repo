Chromium .deb repositories for Ubuntu 20.04+
============================================


Repositories for Chromium browser .deb packages originally released by Linux Mint.

Supported Ubuntu releases:

  * Ubuntu 20.04 Focal (LTS)
  * Ubuntu 22.04 Jammy (LTS)
  * Ubuntu 22.10 Kinetic (EOL)
  * Ubuntu 23.04 Lunar (EOL)
  * Ubuntu 23.10 Mantic
  * Ubuntu 24.04 Noble (LTS, unreleased)


Installation:
-------------

    $ source /etc/lsb-release

    $ echo "deb https://freeshell.de/phd/chromium/${DISTRIB_CODENAME} /" \
      | sudo tee /etc/apt/sources.list.d/phd-chromium.list

    $ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 869689FE09306074

    $ sudo apt-get update

    $ sudo apt-get remove chromium-browser

    $ sudo apt-get install chromium


Signing key renewal:
--------------------

    $ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 869689FE09306074


Repository:
-----------

The repository is hosted at https://freeshell.de/phd/chromium/.


Source code:
------------

Visit https://github.com/phd/chromium-repo for a full source code.
