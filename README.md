# Alpine Nginx ModSecurity CSR

This build of Nginx on Alpine includes:

  * ModSecurity v3: https://github.com/SpiderLabs/ModSecurity 
  * ModSecurity v3 Nginx Connector: https://github.com/SpiderLabs/ModSecurity-nginx 
  * OWASP Core Rule Set: https://github.com/SpiderLabs/owasp-modsecurity-crs
  * GeoIP2: https://github.com/leev/ngx_http_geoip2_module 
  * GeoLite2 databases: https://dev.maxmind.com/geoip/geoip2/geolite2
  * And more cutumize features from Nexttech.asia


You can customize this build by changing the files in the "conf" directory.

  * conf/modsec: contains files that link to our owasp rules and contain general modsec settings
  * conf/nginx contains our nginx, http, and https config files.
  * conf/owasp contains our owasp core rule set config
