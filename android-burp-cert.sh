# https://securitychops.com/2019/08/31/dev/random/one-liner-to-install-burp-cacert-into-android.html
#
curl --proxy http://127.0.0.1:8080 -o cacert.der http://burp/cert  \
&& openssl x509 -inform DER -in cacert.der -out cacert.pem \
&& cp cacert.der $(openssl x509 -inform PEM -subject_hash_old -in cacert.pem |head -1).0 \
&& adb root \
&& adb remount \
&& adb push $(openssl x509 -inform PEM -subject_hash_old -in cacert.pem |head -1).0 /sdcard/ \
&& echo -n "mv /sdcard/$(openssl x509 -inform PEM -subject_hash_old -in cacert.pem |head -1).0 /system/etc/security/cacerts/" | adb shell \
&& echo -n "chmod 644 /system/etc/security/cacerts/$(openssl x509 -inform PEM -subject_hash_old -in cacert.pem |head -1).0" | adb shell \
&& echo -n "reboot" | adb shell \
&& rm $(openssl x509 -inform PEM -subject_hash_old -in cacert.pem |head -1).0 \
&& rm cacert.pem \
&& rm cacert.der