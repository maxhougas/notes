#!/bin/sh

cafile='DEFAULTCAFILENAME'
keyfile='DEFAUTLKEYFILENAME'
name='DEFAULTCOMMONNAME'
mkca=''
mkkey=''
ext='ext'

while getopts "c:k:m:n:t:h" arg; do
 case "$arg" in

  c) cafile="$OPTARG";;
  k) keyfile="$OPTARG";;
  m) if [ "$OPTARG" = 'ca' ]; then mkca='y'; fi; if [ "$OPTARG" = 'key' ]; then mkkey='y'; fi;;
  n) name="$OPTARG";;
  t) ext="$OPTARG";;
  h)
   echo '-c ca filename without extension'
   echo '-k key filename without extension'
   echo '-m what to make; takes either "ca" or "key"'
   echo '-n common name'
   echo '-x extensions section from ssl.cnf'
   echo '-h this';;

 esac
done

if [ -n "$mkca" ]; then
 sed -i "s:= _NAME$:= monkeys-ca:" ssl.cnf
 openssl req -x509 -newkey rsa -keyout "$cafile.key" -out "$cafile.crt" -config ssl.cnf -extensions caext
 sed -i "s:= monkeys-ca$:= _NAME:" ssl.cnf
fi

if [ -n "$mkkey" ]; then
 sed -i "s:= _NAME$:= $name:" ssl.cnf
 openssl req -x509 -newkey rsa -keyout "$keyfile.key" -out "$keyfile.crt" -CA "$cafile.crt" -CAkey "$cafile.key" -config ssl.cnf -extensions "$ext"
 sed -i "s:= $name$:= _NAME:" ssl.cnf
fi
