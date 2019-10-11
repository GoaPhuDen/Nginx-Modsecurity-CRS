# Alpine Nginx ModSecurity CSR

This build of Nginx on Alpine includes:

  * ModSecurity v3, OWASP Core Rule Set
  * And more cutumize features from Nexttech.asia

You can customize this build by changing the files in the "conf" directory.

  * conf/modsec: contains files that link to our owasp rules and contain general modsec settings
  * conf/nginx contains our nginx, http, and https config files.
  * conf/owasp contains our owasp core rule set config
  
Dockerhub:

	* Link : https://hub.docker.com/r/wisoez/nginx-modsecurity-crs
