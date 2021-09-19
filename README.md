# Useful Ubuntu Scripts

## Install CERN ROOT

Install all requires prerequisites and comple latest CERN ROOT libraries on your Ubuntu-based linux. Script will also set up your environment variables. Open your terminal and paste following code.

```
mkdir -p ~/Downloads && cd ~/Downloads
wget -O install-root-latest.sh https://raw.githubusercontent.com/petrstepanov/ubuntu-scripts/master/install-root-latest.sh
chmod +x ./install-root-latest.sh
./install-root-latest.sh
```
Tested on clean install Ubuntu 20.04 LTS. Feel free to open an Issue if script is not working.
