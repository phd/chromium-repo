Chromium .deb repositories for Ubuntu 20.04+
============================================

Repositories for Chromium browser .deb packages originally released by Linux Mint.

Installation:
-------------

    $ source /etc/lsb-release

    $ echo "deb https://freeshell.de/phd/chromium/${DISTRIB_CODENAME} /" \
      | sudo tee /etc/apt/sources.list.d/phd-chromium.list

    $ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 869689FE09306074

    $ sudo apt-get update

    $ sudo apt-get remove chromium-browser

    $ sudo apt-get install chromium

Source code:
------------

Visit https://github.com/phd/chromium-repo for a full source code.
