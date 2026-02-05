<a name="top"/>

# Notes
Big repo o' notes

## Table of Contents
- [Arch](#arch)
- [Docker](#docker)
- [Drivers](#drivers)
- [GPM](#gpm)
- [OpenSSL](#openssl)

###### [Go to Top](#top)

## Arch

### systemd-networkd
- Get the name of your device(s) with `ip link` or `ip a`. Call it DEVICE.
- Put the following in /etc/systemd/network/
```
[Match]
Name=DEVICE

[Network]
DCHP=yes
``` 
- Static IP set-ups will need something more like
```
[Match]
Name=DEVICE

[Network]
Address=VALID.STATIC.IP.ADDRESS
Gateway=ASK.YOUR.NETWORK.ADMIN
DNS=9.9.9.9
```
- There's also another DNS config file @ /etc/resolv.conf
```
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 9.9.9.9
nameserver 149.112.112.112
nameserver 2620:fe::9
nameserver 2001:4860:4860::8888
nameserver 2001:4860:4860::8844
nameserver 2620:fe::fe
nameserver 2620:fe::9
```
- You may need to
```
systemctl enable systemd-networkd
systemctl start systemd-networkd
systemctl enable systemd-resolved
systemctl start systemd-resolved
ip link set DEVICE up
```
- Wireless units can be controlled through `iwctl` which will probably require
```
systemctl enable iwd
systemctl start iwd
```
- Good luck if you're on Parabola

#### Resources
- [Debian Wiki: SystemdNetworkd](https://wiki.debian.org/SystemdNetworkd)
- [Arch Man Pages: ip-link(8)](https://man.archlinux.org/man/ip-link.8)
- [Arch Wiki: iwd](https://wiki.archlinux.org/title/Iwd)

###### [Go to Top](#top)

## Docker

### Install Docker
- `apt install docker.io`

### Install Docker Engine
- https://docs.docker.com/engine/install/debian/ is pretty good
- You may need to change https://unix.stackexchange.com/questions/630643/how-to-install-docker-ce-in-kali-linux
```
echo \
 "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
 $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
- to
```
echo \
 "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
 buster stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

### Change Storage Location
- `echo -e '{\n"data-root": "/new/storage/location"\n}' > /etc/docker/daemon.json` 

### Commands
- `docker build -t [tag] .`
- `docker exec -it [mycontainer] [shell]` https://stackoverflow.com/questions/30172605/how-do-i-get-into-a-docker-containers-shell
- `docker run -dp [external]:[internal] [image]`
- `docker rename [old name] [new name]` https://www.tecmint.com/name-docker-containers/
- `docker run -d --name [name] [image]`
- `docker create -dp [external]:[internal] --network [network] --ip=[ipaddr] --name [name] [image]`

### Resources
- https://docs.docker.com/get-started/
- https://labs.play-with-docker.com/#
- https://www.geeksforgeeks.org/docker-docker-container-for-node-js/
- https://stackoverflow.com/questions/30172605/how-do-i-get-into-a-docker-containers-shell
- https://jpetazzo.github.io/2020/02/01/quest-minimal-docker-images-part-1/
- https://evodify.com/change-docker-storage-location/

###### [Go to Top](#top)

## Drivers
- Firmware blobs can be found at [git.kernel.org](https://git.kernel.org/pub/scm/linux/kernel/git/ath/linux-firmware.git/tree)
- Some drivers are at [git.kernel.org](https://git.kernel.org)
- Drop the firmware in `/lib/firmware`
- Driver Makefile is usually fine
- There is usually some kind of make config or make menuconfig
```
make uninstall
make menuconfig
make install
```

###### [Go to Top](#top)

## GPM
- Use the maus in your terminal!
  - Has problems in VirtualBox
  1. `systemctl disable gpm` if necessary
  2. `service gpm stop` if necessary
  3. Disable maus integration
  4. Capture maus
  5. `service gpm start`
  6. Maus may now be captured and uncaptured as desired
  7. If you ran steps 1 or 2, shut down and reboot virtual machine
- Attempting to capture maus (for the first time since virtual system start) while GPM is running does weird things

###### [Go to Top](#top)

## OpenSSL

### Install OpenSSL
- `apt install openssl`

### Make private key
- `openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out itsa.key`
- `openssl genrsa -out itsa.key 2048`

### Extract public key from private key
- `openssl pkey -in itsa.key -pubout -out itsa.pub`
- `openssl rsa -in itsa.key -pubout -out itsa.pub`

### Generate signing request from private key
- `openssl req -new -key itsa.key -out itsa.csr`

### Generate private key and signing request
- `openssl req -newkey rsa:2048 -keyout itsa.key -out itsa.csr`

### Generate self signed certificate from private key
- `openssl req -x509 -key itsa.key -out itsa.crt`

### Generate private key and self signed certificate
- `openssl req -x509 -newkey rsa:2048 -keyout itsa.key -out itsa.crt`

### Sign a certificate request
- `openssl x509 -req -in itsa.csr -out itsa.crt -CA ca.crt -CAkey ca.key`
- `openssl req -x509 -in itsa.csr -out itsa.crt -CA ca.crt -CAkey ca.key`

### Sign a certificate request with extensions
- `openssl x509 -req -in itsa.csr -out itsa.crt -CA ca.crt -CAkey ca.key -extfile ssl.cnf -extensions exts`
- `openssl req -addext 'basicConstraints=critical,CA:FALSE' -x509 -in itsa.csr -out itsa.crt -CA ca.crt -CAkey ca.key`

### Generate a private key and a signed certificate
- `openssl req -x509 -newkey rsa:2048 -keyout itsa.key -out itsa.crt -CA ca.crt -CAkey ca.key`

### Generate a private key and a signed certificate with extensions
- `openssl req -x509 -newkey rsa:2048 -keyout itsa.key -out itsa.crt -CA ca.crt -CAkey ca.key -config ssl.cnf -extensions exts`
```
openssl req\
 -addext 'basicConstraints:critical,CA:FALSE'\
 -addext 'keyUsage:keyEncipherment'\
 -addext 'extendedKeyUsage:serverAuth'\
 -subj '/C=US/ST=WI/L=town/O=coolOrg/OU=pwnz0rClub/CN=pwnz0rSrv'\
 -x509 -newkey rsa:2048 -keyout itsa.key -out itsa.crt -CA ca.crt -CAkey ca.key
```

### Dump certificate info
- `openssl x509 -text -noout -in itsa.crt`

### Generate CA key, CA cert, private key, and certificate
- Generate a CA key and a self-signed certificate
  - `openssl req -x509 -newkey rsa:2048 -keyout ca.key -out ca.crt -config ssl.cnf`
- Generate a key and a certificate signed by the CA
  - `openssl req -x509 -newkey rsa:2048 -keyout itsa.key -out itsa.crt -CA ca.crt -CAkey ca.key -config ssl.cnf`

### Generate symmetric key
- `openssl rand 16 -out sym.key`

### Public key encrypt
- `openssl pkeyutl -encrypt -pubin -inkey pub.key -in toencrypt.txt | base64`

### Private key decrypt
- `base64 -d todecrypt.txt | openssl pkeyutl -decrypt -inkey pri.key -in -`

### Symmetric key encrypt
- `openssl enc -aes-128-ecb -in toencrypt.txt -K $(cat sym.key) -a`

### Resources
- https://docs.openssl.org/master/man1/

###### [Go to Top](#top)


