

### Local Applet Uninstall

Verify that applet `f001935711` is uninstalled (this is done locally):

```
(.venv) merlin@parallels-dev:~/pysim$ export PYSIM_KIC="6959B952FAB80B81527F09374029E64E"
(.venv) merlin@parallels-dev:~/pysim$ export PYSIM_KID="B236CBBA0A196E41610D74428B0C0BCD"
(.venv) merlin@parallels-dev:~/pysim$ ./stk_applet_manager.py -p 8 --list-applets
INFO: Waiting for card…
Autodetected card type: sysmoISIM-SJA2
Card ICCID: 8988211000000448897
INFO: Getting list of installed applets…
###### 22 applets found ######
- AID: a0000000620001, State: 01, Privs: 00
- AID: 4a6176656c696e2e6a637265, State: 01, Privs: 00
- AID: a0000000620101, State: 01, Privs: 00
- AID: a0000000620102, State: 01, Privs: 00
- AID: a0000000620201, State: 01, Privs: 00
- AID: a000000062020801, State: 01, Privs: 00
- AID: a00000006202080101, State: 01, Privs: 00
- AID: a0000000620002, State: 01, Privs: 00
- AID: a0000000620003, State: 01, Privs: 00
- AID: a000000062010101, State: 01, Privs: 00
- AID: a00000015100, State: 01, Privs: 00
- AID: a0000000090005ffffffff8911000000, State: 01, Privs: 00
- AID: a0000000090005ffffffff8912000000, State: 01, Privs: 00
- AID: a0000000090005ffffffff8913000000, State: 01, Privs: 00
- AID: a0000000090005ffffffff8911010000, State: 01, Privs: 00
- AID: a0000000871005ffffffff8913100000, State: 01, Privs: 00
- AID: a0000000871005ffffffff8913200000, State: 01, Privs: 00
- AID: a0000000090003ffffffff8910710001, State: 01, Privs: 00
- AID: a0000000090003ffffffff8910710002, State: 01, Privs: 00
- AID: a0000000090005ffffffff8915000000, State: 01, Privs: 00
- AID: a00000015141434c, State: 01, Privs: 00
	- Instance AID: a00000015141434c00
- AID: f001935711, State: 01, Privs: 00
	- Instance AID: f001935711facade

(.venv) merlin@parallels-dev:~/pysim$ ./stk_applet_manager.py -p 8 --delete f001935711
INFO: Waiting for card…
Autodetected card type: sysmoISIM-SJA2
Card ICCID: 8988211000000448897
INFO: Getting list of installed applets…
INFO: Applet successfully deleted.

(.venv) merlin@parallels-dev:~/pysim$ ./stk_applet_manager.py -p 8 --list-applets
INFO: Waiting for card…
Autodetected card type: sysmoISIM-SJA2
Card ICCID: 8988211000000448897
INFO: Getting list of installed applets…
###### 21 applets found ######
- AID: a0000000620001, State: 01, Privs: 00
- AID: 4a6176656c696e2e6a637265, State: 01, Privs: 00
- AID: a0000000620101, State: 01, Privs: 00
- AID: a0000000620102, State: 01, Privs: 00
- AID: a0000000620201, State: 01, Privs: 00
- AID: a000000062020801, State: 01, Privs: 00
- AID: a00000006202080101, State: 01, Privs: 00
- AID: a0000000620002, State: 01, Privs: 00
- AID: a0000000620003, State: 01, Privs: 00
- AID: a000000062010101, State: 01, Privs: 00
- AID: a00000015100, State: 01, Privs: 00
- AID: a0000000090005ffffffff8911000000, State: 01, Privs: 00
- AID: a0000000090005ffffffff8912000000, State: 01, Privs: 00
- AID: a0000000090005ffffffff8913000000, State: 01, Privs: 00
- AID: a0000000090005ffffffff8911010000, State: 01, Privs: 00
- AID: a0000000871005ffffffff8913100000, State: 01, Privs: 00
- AID: a0000000871005ffffffff8913200000, State: 01, Privs: 00
- AID: a0000000090003ffffffff8910710001, State: 01, Privs: 00
- AID: a0000000090003ffffffff8910710002, State: 01, Privs: 00
- AID: a0000000090005ffffffff8915000000, State: 01, Privs: 00
- AID: a00000015141434c, State: 01, Privs: 00
	- Instance AID: a00000015141434c00
```