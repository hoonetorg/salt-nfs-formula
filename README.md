# salt-nfs-formula
Install and configure nfs 
(currently only tested and probably only working on CentOS 7.1)

available formulas:
 - server
 - client


The file pillar.example shows an example for creating a /etc/exports
file for a nfs server.

The file pillar.example.outcome shows the resulting /etc/exports file
on the minion after a successful run of the nfs-formula nfs.server
with the pillar data.



### Remarks(WIP):

Against all internet howtos, configuring nfs on CentOS 7.1 is easy.
There is no need to !enable! nfs or rpcbind or nfs-server (systemd)-service.

It must be !started! only direct after installation without reboot.

What's the difference?

When you install nfs-utils freshly you need to 
 - edit /etc/exports
 - start rpcbind.service and nfs.service 
   - nfs.service  starts all subservices
     - rpcbind.service (portmapper)
     - nfs-server.service
     - ...
, but

you !do not need! to enable rpcbind and nfs.service

, because

on reboot 

if /etc/exports exists and has valid exports

rpcbind and nfs and subservices will be started automatically

(I don't know exactly why)


That is why the service-states only are started, and

!not enabled!.


