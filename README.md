# PRTG hdd, SSD and NVME SMART monitoring 
PRTG Script to monitor Smart status of all drives
Script will find all openend devices check for smart errors


![PRTG Probes](https://i.ibb.co/VQ17W6p/Capture-d-cran-2020-10-08-114901.png)

## USE:
# On the server side:
Place oid.smart.test.ovl in PRTG installation folder in \lookups\custom
Reboot PRTG Core Service
# On the device side:
Put script in /var/prtg/scriptsxml/ - if folder does not exist, create it
Edit the script if you want to have all smart values - uncomment "ALL SMART VALUES"
Add advanced ssh script sensor
Name sensor and select the script - adjust Scan interval in case of need
Add sensor
Once script has run, edit SMART Channels "Value Lookup" to use oid.smart.test
