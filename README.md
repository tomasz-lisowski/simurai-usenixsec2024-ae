# USENIX Security '24 Artifacts: SIMurai

This repository contains supporting materials for the USENIX Security '24 Artifact Evaluation for the following paper:

> Tomasz Lisowski, Merlin Chlosta, Jinjin Wang, and Marius Muench. “SIMurai: Slicing Through the Complexity of SIM Card Security Research”. In: USENIX Security Symposium. 2024.

The paper, the artifact appendix and the artifacts are under embargo until 2024-08-14; please keep the contents confidential. Once published, we will include links to the paper here.

## About

SIMurai is a software implementation of a *SIM "card"*, which is useful in various research contexts. We show how SIMurai replaces the SIM card of a physical smartphone (called User Equipment (UE) or terminal) and successfully performs the authentication that is required to access mobile networks. Further, we show its application in security-related contexts.

## Structure

We supply three setups that allow replication of the major claims of our paper. Particularly, the functionality of the setups shows that SIMurai is a practical SIM replacement in multiple scenarios.

- [`1__setup/1__physical_ue`](1__setup/1__physical_ue/README.md) (S1): Use SIMurai as the SIM of a physical smartphone, in a 2G testbed.
- [`1__setup/2__srsue`](1__setup/2__srsue/README.md) (S2): Use SIMurai as SIM for a fully virtualized, srsRAN-based 4G testbed.
- [`1__setup/3__emulated_ue`](1__setup/3__emulated_ue/README.md) (S3): Use SIMurai as SIM in a FirmWire-emulated baseband firmware.

S1 requires a cellular test bed with hardware requirements such as BladeRF and SIMtrace2.

Further, we utilize the setups for additional experiments:
- [`2__experiment/1__spyware`](2__experiment/1__spyware/README.md): Building on setup S1, we extend SIMurai to implement a SIM-based spyware.
- [`2__experiment/2__fuzzing`](2__experiment/2__fuzzing/README.md): Building on setup S3, we launch a fuzzing campaign.

Additionally, we provide PCAPs for two case studies that show the potential of SIM-originating attacks:
- [`3__case_study/1__interposer`](3__case_study/1__interposer/README.md): SIM-originating attack using a custom firmware on an interposer.
- [`3__case_study/2__remote_ota_install`](3__case_study/2__remote_ota_install/README.md): SIM-originating attack by remotely updating a SIM card.

All folders contain READMEs with further explanations and interpretations of the results.

## Requirements

Setup S1 and experiment E1 involve a cellular network setup with hardware such as BladeRF and SIMtrace2 required. As such, replication using our scripts requires closely following the setup instructions.

All other experiments can run in a virtual machine without hardware requirements. Hence, if the required hardware is not available, the general functionality of SIMurai can still be assessed using only the virtual setups.

Our general requirements:

- Ubuntu 22.04
- x86 machine

Additionally, the following software is required:
- Docker
- `adb` and `scrcpy` for monitoring smartphones
- Wireshark

We suggest using an Ubuntu 22.04 virtual machine with a desktop environment (for Wireshark and `scrcpy`). To install the required software, run:

```
sudo apt install wireshark adb scrcpy
```

Docker installation as per [the Docker manual](https://docs.docker.com/engine/install/ubuntu/):
```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

```
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

```
sudo groupadd docker
sudo usermod -aG docker $USER
```

A logout (or reboot) might be required for the group change to take effect.

## Building and Running the Experiments

We provide scripts that orchestrate building and running of the experiments:

```
./1__install.sh
./2__basic_test.sh
./3__run.sh
```

For each script, you have to select the setup / experiment to prepare or run, and it guides you through the process.

We do not automatically build all experiments, as we compile key dependencies within the Docker containers, and this might take a while. Hence, first run the `1__install.sh` script and select the item to prepare, then run `3__run.sh` and select the same item.