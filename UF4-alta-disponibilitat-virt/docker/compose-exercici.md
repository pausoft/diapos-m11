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

- Crear Dockerfile al directori (si hi ha més d'un, posarem la ruta diferenciada a cada deirectiva "build").
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
## Exercicis

- Construeix el projecte docker compose d'exemple de https://docs.docker.com/compose/gettingstarted/

- Construeix un sistema Wordpress a partir de dos contenidors Docker
  https://docs.docker.com/compose/wordpress/

- Fes el mateix amb un sistema Moodle. Ho farem a partir del projecte a github: https://github.com/jda/docker-moodle.git

1. Executa en una carpeta de projectes:

~~~
git clone https://github.com/jda/docker-moodle.git
~~~

2. Modifica les variables d'entorn i afegeix les dades necessàries per a tenir el moodle executant-se en local, si cal (analitza el fitxer docker-compose.yml).

3. Modifica el docker-compose.yml per a que faci servir una imatge creada per tu en el servei moodle en lloc de baixar la imatge del repositori.

**Exemple:**

~~~
version: '3'
services:
  webapp:
    // Es pot indicar on es troba el fitxer per a construir la imatge, que per defecte es diu Dockerfile
    build:
      context: ./dir
      dockerfile: Dockerfile-alternate
      // Aquests serien les variables d'entorn que li passariem al docker build en executar-lo
      args:
        buildno: 1

    // O bé indicar el nom de la imatge indicant el directori on es troba el Dockerfile
    build: ./dir
    image: webapp:tag

~~~

4. Executa: docker-compose up

5. Comprova si funciona el Moodle.

**NOTA:** Si en algun moment no ho veus clar, atura docker-compose (i esborra contenidors i volums: penseu que els volums són persistents, i la BD queda amb les dades que es posin en instal·lar).
