#/bin/bash

openssl pkcs12 -export \
-in '/root/.acme.sh/searchserver.domain.com/fullchain.cer' \
-inkey '/root/.acme.sh/searchserver.domain.com/searchserver.domain.com.key' \
-out '/tmp/enforme-fusion.enforme.p12' -CAfile '/root/.acme.sh/searchserver.domain.com/ca.cer' \
-caname "Let's Encrypt Authority X3" \
-password 'pass:SuperStrongPassword'

keytool -importkeystore -srcstorepass 'SuperStrongPassword' \
-noprompt \
-srckeystore  /tmp/enforme-fusion.enforme.p12 \
-srcstoretype pkcs12 -deststorepass 'SuperStrongPassword' \
-destkeystore /opt/lucidworks/fusion/latest/apps/jetty/proxy/etc/keystore \
-deststoretype JKS