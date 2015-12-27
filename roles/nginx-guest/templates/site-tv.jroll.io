server {
  listen         80;
  server_name    tv.jroll.io;
  return         301 https://$server_name$request_uri;
}

server {
  listen 443 ssl;
  server_name tv.jroll.io;

  access_log /var/log/nginx/tv.jroll.io.access.log;
  error_log /var/log/nginx/tv.jroll.io.error.log;

  #ssl_certificate /etc/nginx/ssl/tv.jroll.io/cert.pem;
  #ssl_certificate_key /etc/nginx/ssl/tv.jroll.io/key.pem;
  ssl_certificate /etc/nginx/ssl/jroll.io/cert.pem;
  ssl_certificate_key /etc/nginx/ssl/jroll.io/key.pem;

  ssl_stapling on;
  ssl_stapling_verify on;
  #ssl_trusted_certificate /etc/nginx/ssl/tv.jroll.io/fullchain.pem;
  ssl_trusted_certificate /etc/nginx/ssl/jroll.io/fullchain.pem;

  ssl_session_cache shared:SSL:1m;
  ssl_session_timeout 1440m;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_prefer_server_ciphers on;
  # from https://weakdh.org/sysadmin.html
  ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
  ssl_dhparam /etc/ssl/certs/dhparam.pem;

  location / {
    proxy_pass              http://sonarr.jroll.io:8989;
    proxy_redirect          off;
    proxy_set_header        Host            $host;
    proxy_set_header        X-Real-IP       $remote_addr;
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
  }

}