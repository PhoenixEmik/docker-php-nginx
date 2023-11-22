## Dockerized PHP & Nginx

PHP(fpm): 7.4.33
Nginx: nginx/1.20.2

---

webroot: `/var/www/html/`  
nginx-conf: `/etc/nginx/conf.d/` default.conf

### Build Image

```bash
$ docker buildx build --platform=linux/arm64 -t php-fpm:7.4.33 . --no-cache
```

### docker-compose

```yaml
version: "3"

services:
  myweb:
    image: php-fpm:7.4.33
    container_name: myweb
    ports:
      - 8080:8080
    volumes:
      - ./www:/var/www/html
      - ./nginx-conf:/etc/nginx/conf.d
    restart: always
```
