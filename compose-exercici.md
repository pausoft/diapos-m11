# Docker Compose
https://www.slant.co/topics/3929/~docker-orchestration-tools

https://robertoorayen.eu/2017/05/14/como-crear-un-sitio-web-con-docker/

## Instal·lar Docker Compose

- Docker Compose és una eina d'**Orquestració**. Ens permet automatitzar l'execució de  contenidors que utilitzem en un sistema que necessiti diversos contenidors (per exemple el grup LAMP que requereix al menys un servidor Apache i un servidor de bases de dades). Com que la filosofia de Docker és tenir un contenidor per a cada servei, serà interessant engegar-los tots en seqüència sense haver de fer-ho a mà.

- Hem de pensar en Compose com una seqüència d'instruccions "docker run", que te en compte les dependencies entre contenidors.

- Instal·lar Compose  seguint instruccions a la web (cal tenir Docker). https://docs.docker.com/compose/install/

## Crear projecte 
- Exemple de projecte.

~~~
$ mkdir composetest
$ cd composetest
~~~

- Crear Dockerfile al directori (si hi ha més d'un, posarem la ruta diferenciada a cada directiva "build").
- Als dockerfiles posar la configuració de cada imatge que volem.
- ATENCIÓ: No posar res que no calgui al directori, ja que el constructor mou tot al directori /var/lib/docker/tmp i pot omplir el volum / del sistema!!! 

- Crear fitxer docker-compose.yml i escriure dintre (no fer servir TAB, comentaris amb # a  la primera columna de la línia):

~~~
version: '3'
services:    // Definim dos serveis o contenidors, anomenats web i redis
  web:        // Nom del servei
    build: .    // Construir imatge des del directori actual (busca el Dockerfile al directori indicat)
    ports:    // Ports exposats del contenidor i en quin port es veuran en l’equip físic 
     - "5000:5000" 
    volumes:    // Muntar volums. En aquest cas, directori actual al directori /code del contenidor. Això permet canviar el codi sense fer rebuild
     - .:/code
  redis:        // La imatge s’obté directament del repositori
  		   // En aquest cas no es fa servir Dockerfile
    image: "redis:alpine"
~~~

Arrencar els serveis:

- Arrencar/aturar. Posar -d si volem iniciar desconnectat del compose, si no, surt el debug i bloca la consola

~~~
$ docker-compose up 
$ docker-compose stop 
// Aturar, també amb CTRL+C si està connectat el compose 
~~~

- Altres comandes:

~~~
$ docker-compose ps        // veure serveis en marxa
$ docker-compose run web env    // per còrrer només un servei dels que hi ha al compose
$ docker-compose down --volumes    // Aturar i esborrar contenidors (i volums amb --volumes)
~~~

## Configuració de xarxa estàtica

~~~
services:
  app:
    image: busybox
    command: ifconfig
    networks:
      app_net:
        ipv4_address: 172.16.238.10
        ipv6_address: 2001:3984:3989::10
networks:
  app_net:
    driver: bridge
    enable_ipv6: true
    ipam:
      driver: default
      config:
      - subnet: 172.16.238.0/24
      gateway: 172.16.238.1
     - subnet: 2001:3984:3989::/64
     gateway: 2001:3984:3989::1
~~~

