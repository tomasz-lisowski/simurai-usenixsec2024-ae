# Description

This directory holds an automated setup for experiment 2 (fuzzing).

It requires that the docker for setup 3 (emulated UE) was built.

# Setup

To setup the environment for fuzzing run:
```bash
$ ./1__install.sh
```

This will extract the seed corpus and create a snapshot ready for fuzzing.
The snapshot is set directly inside the USAT fuzzing task, just before the AFL forkserver is started.

# Running the fuzzing campaign

To start the fuzzing campaign, execute:
```bash
$ sudo ./2__run.sh
```

This will run afl-system-config to optimize your system for fuzzing *on your host*.
The changes of afl-system-config will be discarded after a reboot of your system, however, keep in mind that they lower the security of your host.

Afterwards, the fuzzing campaign is started inside a docker container and run for 24hours. To change this time limit, please modify `FUZZING_TIME` inside `scripts/2__run_fuzzing.sh`.

The results will be stored to `result/out/main`, and follows the normal AFL++ directory structure.
Note that the directory will be owned by the root user, as fuzzing is done under root permissions inside the Docker container.

# Replaying test cases

To replay a single testcase, or a directory containing multiple testcases, run:
```bash
$ ./3__replay.sh path_to_replay_target`
```

If the replay target is a single file, it will be replayed alone. If the replay target is a directory, all containing files in this directory are replayed.
In both cases, an according log file is created.

## Interpreting the results

To verify whether the fuzzer found the expected vulnerabilities, it is advised to replay the `result/out/main/crashes/` and `result/out/main/hangs` directory.
Afterwards, the logs can be inspected and we advise to look out for the following three behaviors:

### 1) False Positive Crashes

A lot of the produced crashes may look as follows:
```
[1.33049][AFL_USAT] 0x4580024f pal_MsgSendTo(USAT (188)) - PALMsg<0x1f01, USAT (bc) -> USAT_SYNC (bf), 8 bytes>
[1.33103][USAT] 0x41bdd731 0b100: [../../../PSS/StackService/USAT/Code/Src/usat_main.c] - [USAT_0] ------------------------- USAT TASK ----------------------------
[1.33142][USAT] 0x41bdcb71 0b11: [../../../PSS/StackService/USAT/Code/Src/usat_main.c] - [USAT_0] 7. USAT <== SIM_PROACTIVE_CMD_IND [USAT]
[1.33160][USAT] 0x41bdca53 0b100: [../../../PSS/StackService/USAT/Code/Src/usat_main.c] - [USAT_0] usat_State -> USAT_ACTIVE
[1.33180][USAT] 0x41bdcd97 0b10: [../../../PSS/StackService/USAT/Code/Src/usat_main.c] - [USAT_0] Displaying Received Message: MsgLen = 16
[1.33203][USAT] 0x41bdfcd7 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_UsimIntfManagement.c] - [USAT_0] ProcessProactiveCmdReq: Entry
[1.33224][USAT] 0x41bd8923 0b100: [../../../PSS/StackService/USAT/Code/Src/usat_ProactiveCmds.c] - [USAT_0] DisplayProactiveCmdType
[1.33241][USAT] 0x41bd89dd 0b100: [../../../PSS/StackService/USAT/Code/Src/usat_ProactiveCmds.c] - [USAT_0] ProactiveCmdType: PROACTIVE_CMD_OPEN_CHANNEL
[1.33259][USAT] 0x41be8927 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_ProactiveCmdHandler.c] - [USAT_0] usat_CheckSafetyMode: CmdType = 0x40
[1.33278][USAT] 0x41bdceeb 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_main.c] - [USAT_0] Get :FlagIndex 12 result 1
[1.33294][USAT] 0x41bded19 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_UsimIntfManagement.c] - [USAT_0] DecodeProactiveCmdInd: len = 20
[1.33312][USAT] 0x41bdceeb 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_main.c] - [USAT_0] Get :FlagIndex 12 result 1
[1.33366][USAT] 0x41bde849 0b1: [../../../PSS/StackService/USAT/Code/Src/usat_pducodec.c] - [USAT_0] CD_CODER:usat_ErrorDecoder = 0x0
[1.33386][USAT] 0x41bdefeb 0b100: [../../../PSS/StackService/USAT/Code/Src/usat_UsimIntfManagement.c] - [USAT_0] In usat_CheckCmdSuppInTermProf - Curr Rat - 255, cmd type - 64
[1.33408][USAT] 0x41be4c7b 0b100: [../../../PSS/StackService/USAT/Code/Src/usat_ProactiveCmdHandler.c] - [USAT_0] usat_CurrentCmdDetails[0],[1],[2]  0,40,37
[1.33423][USAT] 0x41bdfb63 0b100: [../../../PSS/StackService/USAT/Code/Src/usat_UsimIntfManagement.c] - [USAT_0] CheckCmdSuppInTermProf: result :1
[1.33439][USAT] 0x41be3d0d 0b100: [../../../PSS/StackService/USAT/Code/Src/usat_TimerManagement.c] - [USAT_0] StartTimer: USAT_TIMER_PROACTIVECMD_TR, duratn 600000 ms
[1.33521][USAT] 0x41bdceeb 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_main.c] - [USAT_0] Get :FlagIndex 12 result 1
[1.33537][USAT] 0x41bf06cb 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_BipConnIntfManagement.c] - [USAT_0] [USAT BIP] usat_BipConnectionCmdHandler
[1.33565][USAT] 0x41bf04ed 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_BipConnIntfManagement.c] - [USAT_0] [USAT BIP] usat_OpenChannel
[1.33593][USAT] 0x41bf02a5 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_BipConnIntfManagement.c] - [USAT_0] [USAT BIP] usat_CheckAndUpdatePreOpenConnStateData
[1.33618][USAT] 0x41bf031b 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_BipConnIntfManagement.c] - [USAT_0] [USAT BIP]Bearer Type : 0 is not  supported
[1.33632][USAT] 0x41befbcf 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_BipConnIntfManagement.c] - [USAT_0] [USAT BIP] usat_HandleOpenChannelTr, result:32
[...]
[1.34049][USAT] 0x41bee621 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_BipConnIntfManagement.c] - [USAT_0] [USAT BIP] Deep Freed  [pSimAtkBipConnState] [4439c0a0]
[ERROR] firmwire.vendor.shannon.hooks: FATAL ERROR (USAT): from 0x40effd05 [pal_PlatformMisc.c:146 - Fatal error: PAL_MEM_GUARD_CORRUPTION
```

These crashes are false positives, and we could not reproduce them on real devices. We expect that these are due to missing initialization for BIP Connections, which would be present on a real modem.

## CVE-2023-50806

This CVE is based on a vulnerability in the `SEND_SS` proactive command.
Typically, this vulnerability shows as a hang, rather than a crash, due to FirmWire not recognizing the fault state (stack overflow) as crashing condition.
An example log indicating this vulnerability looks as follows:

```
[1.40531][AFL_USAT] 0x4580024f pal_MsgSendTo(USAT (188)) - PALMsg<0x1f01, USAT (bc) -> USAT_SYNC (bf), 8 bytes>
[1.40581][USAT] 0x41bdd731 0b100: [../../../PSS/StackService/USAT/Code/Src/usat_main.c] - [USAT_0] ------------------------- USAT TASK ----------------------------
[1.40618][USAT] 0x41bdcb71 0b11: [../../../PSS/StackService/USAT/Code/Src/usat_main.c] - [USAT_0] 7. USAT <== SIM_PROACTIVE_CMD_IND [USAT]
[1.40634][USAT] 0x41bdca53 0b100: [../../../PSS/StackService/USAT/Code/Src/usat_main.c] - [USAT_0] usat_State -> USAT_ACTIVE
[1.40651][USAT] 0x41bdcd97 0b10: [../../../PSS/StackService/USAT/Code/Src/usat_main.c] - [USAT_0] Displaying Received Message: MsgLen = 16
[1.40673][USAT] 0x41bdfcd7 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_UsimIntfManagement.c] - [USAT_0] ProcessProactiveCmdReq: Entry
[1.40693][USAT] 0x41bd8923 0b100: [../../../PSS/StackService/USAT/Code/Src/usat_ProactiveCmds.c] - [USAT_0] DisplayProactiveCmdType
[1.40717][USAT] 0x41bd89dd 0b100: [../../../PSS/StackService/USAT/Code/Src/usat_ProactiveCmds.c] - [USAT_0] ProactiveCmdType: PROACTIVE_CMD_SEND_SS
[1.40736][USAT] 0x41be8927 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_ProactiveCmdHandler.c] - [USAT_0] usat_CheckSafetyMode: CmdType = 0x11
[1.40760][USAT] 0x41bdceeb 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_main.c] - [USAT_0] Get :FlagIndex 3 result 1
[1.40776][USAT] 0x41bded19 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_UsimIntfManagement.c] - [USAT_0] DecodeProactiveCmdInd: len = 32
[1.40805][USAT] 0x41bde849 0b1: [../../../PSS/StackService/USAT/Code/Src/usat_pducodec.c] - [USAT_0] CD_CODER:usat_ErrorDecoder = 0x0
[1.40827][USAT] 0x41bdefeb 0b100: [../../../PSS/StackService/USAT/Code/Src/usat_UsimIntfManagement.c] - [USAT_0] In usat_CheckCmdSuppInTermProf - Curr Rat - 255, cmd type - 17
[1.40855][USAT] 0x41be4c7b 0b100: [../../../PSS/StackService/USAT/Code/Src/usat_ProactiveCmdHandler.c] - [USAT_0] usat_CurrentCmdDetails[0],[1],[2]  e4,11,6
[1.40880][USAT] 0x41bdfb63 0b100: [../../../PSS/StackService/USAT/Code/Src/usat_UsimIntfManagement.c] - [USAT_0] CheckCmdSuppInTermProf: result :1
[1.40898][USAT] 0x41be3d0d 0b100: [../../../PSS/StackService/USAT/Code/Src/usat_TimerManagement.c] - [USAT_0] StartTimer: USAT_TIMER_PROACTIVECMD_TR, duratn 600000 ms
[1.40965][USAT] 0x41beab9d 0b100: [../../../PSS/StackService/USAT/Code/Src/usat_ProactiveCmdHandler.c] - [USAT_0] [STK_CP]usat_HandleSendSSCmdReqLocal
[1.41023][USAT] 0x41beaa21 0b100: [../../../PSS/StackService/USAT/Code/Src/usat_ProactiveCmdHandler.c] - [USAT_0] [SEND SS]usat_DecodeSSString
[1.71454][HISR2] 0x400361d pal_MsgSendTo(RLC (47)) - TIMER 0x5
[...]
iLine   : 0 
szFile  : N/A 
szError : STACK OVERFLOW 
r0      : 0x41CA6F10 
r1      : 0x43A7F744 
r2      : 0x00000000 
r3      : 0xDEADBEEF 
r4      : 0x00000060 
r5      : 0x00000038 
r6      : 0x00000038 
r7      : 0x43ABBEE4 
r8      : 0x00000001 
r9      : 0x41C9D330 
r10     : 0x00000000 
r11     : 0xFFFFF406 
r12     : 0x00000080 
r15     : 0x40F91F1C 
cpsr    : 0x80000013 
r13_svc : 0x43ABBE74 
r14_svc : 0x41C43C80 

r13_usr : 0x04800100 
r14_usr : 0x00000000 

spsr_abt: 0x00000000 
r13_abt : 0x04800200 
r14_abt : 0x00000000 

spsr_und: 0x00000000 
r13_und : 0x04800300 
r14_und : 0x00000000 

spsr_irq: 0x00000033 
r13_irq : 0x04800420 
r14_irq : 0x400100EC 

 
0x00000038 0x00000001 0x43ABBEE4 0x00000001 0x40F91E40 0x80000093 0x41CA731C 0x00000038  
0x00000001 0x43ABBEE4 0x00000001 0x41C9D330 0x00000000 0xFFFFF406 0x00000080 0x41C44A44  
0x4439C1A0 0x00000001 0x00000080 0x41CA21F0 0x00000001 0x406231F3 0x00000001 0x4439C1A0  
0x00000001 0x0400422B 0x00000001 0x04003E05 0x000FF000 0x00000000 0x000FF000 0x41024B39  
0x000FF000 0x4439C1A0 0x41CA72E0 0x41C93A28 0x41CA72E0 0x4580400F 0x41024D59 0x00000038  
0x00000002 0x00000080 0x40F91E40 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000  
0x00000000 0x00000000 0xDEADBEEF 0xDEADBEEF 0x00000000 0x00000000 0x00000000 0x00000000  
0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000  
0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000  
0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000  
0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000  
0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000  
0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000  
0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000  
0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000  
0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 
```

## CVE-2024-27209

This CVE is based on a vulnerability for the `SEND_SMS` proactive command parser.
An example log indicating this vulnerability looks as follows:

```
1.13941][AFL_USAT] 0x4580024f pal_MsgSendTo(USAT (188)) - PALMsg<0x1f01, USAT (bc) -> USAT_SYNC (bf), 8 bytes>
[1.13997][USAT] 0x41bdd731 0b100: [../../../PSS/StackService/USAT/Code/Src/usat_main.c] - [USAT_0] ------------------------- USAT TASK ----------------------------
[1.14035][USAT] 0x41bdcb71 0b11: [../../../PSS/StackService/USAT/Code/Src/usat_main.c] - [USAT_0] 7. USAT <== SIM_PROACTIVE_CMD_IND [USAT]
[1.14051][USAT] 0x41bdca53 0b100: [../../../PSS/StackService/USAT/Code/Src/usat_main.c] - [USAT_0] usat_State -> USAT_ACTIVE
[1.14069][USAT] 0x41bdcd97 0b10: [../../../PSS/StackService/USAT/Code/Src/usat_main.c] - [USAT_0] Displaying Received Message: MsgLen = 16
[1.14090][USAT] 0x41bdfcd7 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_UsimIntfManagement.c] - [USAT_0] ProcessProactiveCmdReq: Entry
[1.14108][USAT] 0x41bd8923 0b100: [../../../PSS/StackService/USAT/Code/Src/usat_ProactiveCmds.c] - [USAT_0] DisplayProactiveCmdType
[1.14120][USAT] 0x41bd89dd 0b100: [../../../PSS/StackService/USAT/Code/Src/usat_ProactiveCmds.c] - [USAT_0] ProactiveCmdType: PROACTIVE_CMD_SEND_SMS
[1.14136][USAT] 0x41be8927 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_ProactiveCmdHandler.c] - [USAT_0] usat_CheckSafetyMode: CmdType = 0x13
[...]
[1.14725][USAT] 0x41be9f37 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_ProactiveCmdHandler.c] - [USAT_0] [SEND SMS] EF_SMSP successfully read DataLen: 0x0
[1.14736][USAT] 0x41be9fc7 0b1: [../../../PSS/StackService/USAT/Code/Src/usat_ProactiveCmdHandler.c] - [USAT_0] [SEND SMS]EF_SMSP Data len is less than 28
[1.14751][USAT] 0x41bea0dd 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_ProactiveCmdHandler.c] - [USAT_0] Sms packing required messageCoding: 0x0,messageCodingIndex:5
[1.14770][USAT] 0x41bea137 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_ProactiveCmdHandler.c] - [USAT_0] VFpresent(0x) : 0
[1.14783][USAT] 0x41bea197 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_ProactiveCmdHandler.c] - [USAT_0] Len8bit : 7f
[1.14813][USAT] 0x41be9e3b 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_ProactiveCmdHandler.c] - [USAT_0] usat_Pack8BitTo7Bit
[1.14880][USAT] 0x41bea1cd 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_ProactiveCmdHandler.c] - [USAT_0] Len7bit : 70
[1.14927][USAT] 0x41bea227 0b101: [../../../PSS/StackService/USAT/Code/Src/usat_ProactiveCmdHandler.c] - [USAT_0] Final TPDU len Len8bit : f9
[ERROR] firmwire.vendor.shannon.hooks: EXCEPTION: DATA ABORT (USAT) - Faulting PC: 0x41bea24c
```

# Deinstallation

To deinstall, run:
```bash
$ ./4__uninstall.sh
```

Note that this will not remove the result directory, and also keeps the docker image for setup3.
Furthermore, to unroll the changes of afl-system-config, the host system needs to be rebooted.