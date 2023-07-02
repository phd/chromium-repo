Chromium Browser .deb repositories for Ubuntu 20.04+
====================================================

Repositories for Chromium Browser .deb packages originally released by Linux Mint.

Installation:
-------------

    $ source /etc/lsb-release

    $ echo "deb https://freeshell.de/phd/phd-chromium-browser/${DISTRIB_CODENAME} /" \
      | sudo tee /etc/apt/sources.list.d/phd-chromium-browser.list

    $ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 869689FE09306074

    $ sudo apt-get update

    $ sudo apt-get remove chromium-browser

    $ sudo apt-get install chromium
