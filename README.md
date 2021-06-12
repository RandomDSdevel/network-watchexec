# '`network-watchexec`'

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'`network-watchexec`' is a scriptable OS X/macOS '`launchd(8)`' network-connection change notification watchdog daemon in the form of a simple, makeshift command-line utility.  It listens for notifications of Wi-Fi network connection and disconnection events and runs scripts when it receives them.  

## Getting the Source Code

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Just clone the repository:  

```
git clone -v --progress https://github.com/RandomDSdevel/network-watchexec.git "$FILESYSTEM_LOCATION_OF_YOUR_CHOICE"
```

## Build Instructions

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To build '`network-watchexec`:'  

 1. (**TO-DO/FIX ME:**  Fill this in later once I've got the project up, running, and building.)  

## Usage

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(**TO-DO/FIX ME:**  Provide usage instructions!)  

## Caveats

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Currently, the connection and disconnection event hook scripts this utility uses must exist and are hard-coded:  

 - The connection hook script must be '`/usr/local/etc/network-watchexec/post-connection`.'  
 - The disconnection hook script must be '`/usr/local/etc/network-watchexec/post-disconnection`.'  

## Inspirations

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'`network-watchexec`' was inspired by:  

 - The following answers to ['Ask Different'](https://apple.stackexchange.com/) question ['Run program if connected to specific wifi?'](https://apple.stackexchange.com/questions/139267/run-program-if-connected-to-specific-wifi) ('sic') and comment on one of them:  
   - [Mateusz Szlosek's answer](https://apple.stackexchange.com/a/164001/70614) and:  
     - [Pascal's comment on it](https://apple.stackexchange.com/questions/139267/run-program-if-connected-to-specific-wifi#comment328725_164001)
   - [js.'s answer](https://apple.stackexchange.com/a/381282/70614)
 - The following GitHub repositories:  
   - ['slozo/Network-listener'](https://github.com/slozo/Network-listener)
   - ['p2/WifiWatch'](https://github.com/p2/WifiWatch)
   - ['rimar/wifi-location-changer'](https://github.com/rimar/wifi-location-changer)
