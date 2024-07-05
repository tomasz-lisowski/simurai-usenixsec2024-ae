# Physical UE with SIMurai

This setup shows that SIMurai can function as SIM replacement for commercial smartphones. In this case, we connect two smartphones to a 2G Yate network. One of the smartphones is using SIMurai for a SIM. Our goal is to show that SIMurai is indeed compatible with commercial smartphones. Further, this setup provides the basis for experiment `1__spyware`.

This setup requires physical hardware, and closely replicating our physical setup. If the required hardware is unavailable, we suggest to try setup 2 first, `../2__srsue`, which uses a *virtualized* cellular network.

## Setup

![alt text](./setup.png)

This setup requires physical hardware:
- two host computers,
- two smartphones (UE1, UE2),
- a faraday box,
- BladeRF Software-Defined Radio for YateBTS,
- SIMtrace2 and SIM adapter cables that fit the two smartphones.
  - `cardem` firmware on the SIMtrace2, as described in the [Osmocom Wiki Page](https://osmocom.org/projects/simtrace2/wiki/Cardem).

As such, our scripts cannot automate everything, and manual efforts are required:
- Set up both smartphones for use with `adb`
- Set up UE 1 with SIMurai, using the SIMtrace2 adapter board
- Set up a physical SIM card for UE 2

