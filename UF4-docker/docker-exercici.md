#Exercicis Docker
Referències:
https://cacauet.org/wiki/index.php/Docker
https://docs.docker.com/
https://docs.docker.com/develop/develop-images/dockerfile_best-practices/

##Crear imatge de ubuntu amb Apache

- Recordeu que podeu posar l'ajuda de qualsevol comanda de docker si no ho teniu clar:

~~~
$ docker --help
$ docker run --help
$ docker pull --help
~~~

- Per poder pujar la imatge inicia sessió al DockerHub

~~~
$ docker login -u pautome
Password: 
Login Succeeded
~~~

- Crea la imatge Ubuntu, instal·la el paquet Apache i arrenca'l:

~~~
$ docker run -it ubuntu:latest
root@d23fba38dd8d:/# apt update
root@d23fba38dd8d:/# apt install apache2
root@d23fba38dd8d:/# cd /var/www/html
root@d23fba38dd8d:/var/www/html# mv index.html index.vell
root@d23fba38dd8d:/var/www/html# echo Aquest es el web del contenidor > index.html
root@d23fba38dd8d:/var/www/html# apache2ctl start
~~~

- En una altra consola, per comprovar que funciona apache, cal esbrinar quina adreça IP té el docker creat, obrir el navegador a la màquina local i apuntar a aquella adreça IP:

~~~
$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
4213ef40735c        ubuntu              "bash"              6 minutes ago       Up 6 minutes                            elated_shannon
$ docker inspect elated_shannon
...
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "fd432b5d984a54e47e0abda2682065a3a68a0c0f2ea6d9944650672093a4e186",
                    "EndpointID": "0d4236498dd85f351b5ea479088293f9ebff247e9a0a77d2504848a28861ef7a",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:02",
                    "DriverOpts": null
                }
            }
        }
    }
]
~~~

- Veiem al final, a l'apartat Network que l'adreça IP del contenidor és 172.17.0.2. 
- Al navegador: http://172.17.0.2
- Guardem els canvis al contenidor i el posem al nostre repositori. Ens **desconnectem** de la consola de docker amb CTRL+P+Q i executem:

~~~
// Crear una imatge nova amb els canvis fets a la imatge 
// posar-li nom "miapache" al nostre repositori (canviar pautome pel vostre):

$ docker commit -a "Pau Tomé <pau.tome@iescarlesvallbona.cat>" elated_shannon pautome/miapache
sha256:5a29593e662601aecb7258d5da96024531832013e97aaed83b05c937d544a22e

$ docker push pautome/miapache
The push refers to repository [docker.io/pautome/miapache]
6fe37c743b70: Pushing [============================>                      ]  84.48MB/146.7MB
~~~

- Comprova al teu compte de DockerHub que has pujat la imatge Docker (inicia sessió via web).

- Reconnecta al contenidor. Veuràs que la consola està blocada per l'Apache. Pots fer CTRL+C per que torni la consola (o picar ENTER):

~~~
$ docker attach elated_shannon 
^C
root@4213ef40735c:/# 
~~~

- Ara l'Apache no està funcionant. Pots provar amb una finestra d'incògnit nova.

- Sortim del contenidor amb "exit" i veurem que no hi ha cap contenidor funcionant (docker ps). 

- Iniciem de nou el contenidor creat i posem en marxa apache. Ara iniciem mapejant els ports del contenidor a la màquina física (paràmetre "-p iphost:porthost:portcontenidor", ip-host és opcional). Això permetrà accedir al web del contenidor des d'un altre equip fora del host:

~~~
$ docker run -it -p 8080:80 pautome/miapache
root@d23fba38dd8d:/# cd /var/www/html
root@d23fba38dd8d:/var/www/html# mv index.html index.vell
root@d23fba38dd8d:/var/www/html# echo Aquest es el web del contenidor > index.html
root@d23fba38dd8d:/var/www/html# apache2ctl start
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
~~~

- Observeu quins ports estan mapejats:

~~~
$ docker port <nomcontenidor>
~~~

- Podem accedir al lloc web via l'adreça del contenidor o bé via localhost:8080.
- Si obrim una nova finestra del navegador, veurem que la pàgina d'inici ja no és la que havíem posat. De fet, el fitxer nou creat abans ni existeix. NO HI HA PERSISTÊNCIA DE LES DADES!!

## Afegir persistència de dades

- Podem afegir volums al nostre contenidor en arrencar.
- Crearem un directori a la màquina real on posarem els volums de Docker.

~~~
$ mkdir volums
$ cd volums/
$ mkdir apachehtml
$ cd apachehtml/
$ echo Apache des de la màquina física > index.html
~~~

- Per connectar una carpeta de la màquina host, quan creem el contenidor (paràmetre volum "-v"):

~~~
$ docker run -it -v /home/pau/volums/apachehtml:/var/www/html pautome/miapache bash
~~~ 

- Prova a crear un nou fitxer des de la màquina host i mira des del contenidor que hi és.
- Edita el fitxer index.html des de l'equip host per canviar la pàgina inicial de l'apache. Comprova que en el navegador veus els canvis.
- Aquesta seria la manera d'intercanviar informació entre contenidors i la màquina host.

## Construir la imatge amb Docker Compose
- Si ja hem fet el procés manual amb docker run interactiu de preparar la imatge que volem, ara es pot automatitzar amb un Dockerfile.
- Caldrà crear un fitxer Dockerfile que contingui totes les dades que hauríem de passar al docker run i les operacions que hauríem de fer a dintre el contenidor per preparar la imatge (insta·lar paquets, copiar fitxers a la imatge, etc.).
- Crearem un directori pel projecte i a dintre un fitxer "Dockerfile" per a crear la nostra imatge. Ens mourem a dintre del directori en la consola:

~~~
FROM library/ubuntu:16.04
MAINTAINER Pau Tomé <pau.tome@iescarlesvallbona.cat>

RUN apt-get update && \
apt-get install -y apache2 && \
apt-get clean && apt-get autoclean

# Aquesta comanda en realitat no fa l'exportació del port, però ajuda a saber quins ports s'esportaran.
# Caldrà exportar amb -p al docker run
EXPOSE 80

# Infoma que el volum anirà a aquest punt de muntatge al contenidor, però caldrà al docker run indicar quin és el volum o directori del host
VOLUME ["/var/www/html/"]
~~~

- Un cop fet, executem:

~~~
$ docker build -t <tag_img> <ruta_dockerfile>

// Cas en concret
$ docker build -t pautome/miapache .
~~~
