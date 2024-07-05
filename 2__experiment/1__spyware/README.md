# SIM-based Spyware

This experiment extends SIMurai with SIM-based spyware, corresponding to Section `6.2.1 Simulating SIM Spyware` in our paper. SIM cards can issue commands to the connected smartphone. SIM-based spyware abuses this feature for, e.g., retrieval of the smartphone's location, and leaking that to an outside attacker via SIM-initiated SMS.

## Setup

Please refer to the [Setup 1 README](../../1__setup/1__physical_ue/README.md) for setup and installation instructions. Here, we use the same setup, but extend SIMurai to feature the SIM-based spyware.

## Building and Running

The installation script applies the patch `spyware.patch` that extends SIMurai. 

TODO