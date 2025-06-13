<a name="top"/>

# Notes
Big repo o' notes

- [Table of Contents](#top)
  - [Docker](#docker)
  - [OpenSSL](#openssl)

[top](#top)

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
 - `echo -e '{\n"data-root": "/new/storage/location"'}' > /etc/docker/daemon.json` 

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

[top](#top)

## OpenSSL

### Install OpenSSL
 - `apt install openssl`

### Make private key

 - `openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out itsa.key`
 - `openssl genrsa -out itsa.key 2048`

### Extract private key from public key
 - `openssl pkey -in itsa.key -pubout -out itsa.pub`
 - `openssl rsa -in itsa.key -pubout -out itsa.pub`

### Generate signing request from private key
 - `openssl req -new -key itsa.key -out itsa.csr`

### Generate private key and signing request
 - `openssl req -newkey rsa:2048 -keyout itsa.key -out itsa.csr`

### Generate self signed certificate from public key
 - `openssl req -x509 -key itsa.key -out itsa.crt`

### Generate private key and self signed certificate
 - `openssl req -x509 -newkey rsa:2048 -keyout itsa.key -out itsa.crt`

### Sign a certificate request
 - `openssl x509 -req -in itsa.csr -out itsa.crt -CA ca.crt -CAkey ca.key`

### Sign a certificate request with extensions
 - `openssl x509 -req -in itsa.csr -out itsa.crt -CA ca.crt -CAkey ca.key -extfile ssl.cnf -extensions exts`

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

### Put it together
 - Generate a CA key and a self-signed certificate
   - `openssl req -x509 -newkey rsa:2048 -keyout ca.key -out ca.crt -config ssl.cnf`
 - Generate a key and a certificate signed by the CA
   - `openssl req -x509 -newkey rsa:2048 -keyout itsa.key -out itsa.crt -CA ca.crt -CAkey ca.key -config ssl.cnf`

### Resources
 - https://docs.openssl.org/master/man1/

[top](#top)

