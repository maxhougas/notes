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

### Put it together
 - Generate a CA key and a self-signed certificate
   - `openssl req -x509 -newkey rsa:2048 -keyout ca.key -out ca.crt -config ssl.cnf`
 - Generate a key and a certificate signed by the CA
   - `openssl req -x509 -newkey rsa:2048 -keyout itsa.key -out itsa.crt -CA ca.crt -CAkey ca.key -config ssl.cnf`

### Resources
 - https://docs.openssl.org/master/man1/
