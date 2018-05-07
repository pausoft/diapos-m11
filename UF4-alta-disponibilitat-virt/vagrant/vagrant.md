# Vagrant
## Inici
 
// Crear dir de projecte i fitxer Vagrantfile
~~~
$ mkdir projecte 
$ cd projecte 
$ vagrant init  hashicorp/precise64
~~~
 
// aixecar màquina i connectar via ssh
~~~
$ vagrant up
$ vagrant ssh
~~~

// destruir màquina virtual
~~~
$ vagrant destroy 
~~~

## Continuar amb Vagrant
Un cop creada, es pot anar al directori i posar en marxa la màquina virtual ja creada:
~~~
$ vagrant init
~~~

## Clonar màquines
Per clonar una màquina virtual (d’una imatge creada o box), baixar-la del repositori hashicorp (usuari/nomimatge) [https://app.vagrantup.com/boxes/search](https://app.vagrantup.com/boxes/search))
~~~
$ vagrant box add hashicorp/precise64
~~~
## Afegir imatge a una màquina
~~~
Vagrant.configure("2") do |config|  
config.vm.box = "hashicorp/precise64"  
config.vm.box_version = "1.1.0"
config.vm.box_url = "http://files.vagrantup.com/precise64.box"
end  
~~~
  

box_version i box_url són opcionals

##Carpeta compartida
Per defecte Vagrant comparteix la carpeta del projecte (amb el Vagrantfile) a la carpeta /vagrant de la màquina virtual. 

## Provisionament automàtic
Fitxer bootstrap.sh:
~~~
#!/usr/bin/env bash
apt-get update
apt-get install -y apache2
if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi
~~~
Afegir al Vagrantfile:
~~~
Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/precise64"
  config.vm.provision :shell, path: "bootstrap.sh"
end
~~~
## Arrencar màquina provisionant

Si ja funcionava:
~~~
$ vagrant reload --provision
~~~
Si es nova (la provisió només es fa la primera vegada):
~~~
$ vagrant up
~~~
Comprovar:
~~~
$ vagrant ssh
...
vagrant@precise64:~$ wget -qO- 127.0.0.1
~~~
## Xarxa
Al Vagrantfile
~~~
config.vm.network :forwarded_port, guest: 80, host: 4567
~~~
Provar
~~~
$ vagrant reload 
~~~

Provar al navegador: http://127.0.0.1:4567

## Crear compartició a internet
~~~
$ vagrant share
...
==> default: Creating Vagrant Share session...
==> default: HTTP URL: http://b1fb1f3f.ngrok.io
...
~~~

## Suspendre, aturar, destruir VM
Suspendre i aturar VM. Tot queda al disc i NO triga en arrencar. 
~~~
$ vagrant suspend
~~~
Apagar ordenadament. Tot queda al disc i triga en arrencar.
~~~
$ vagrant halt
~~~
Esborrar màquina. Tot l’espai de disc s’allibera. La imatge no.
~~~
$ vagrant destroy
$ vagrant up (torna a crear la màquina, a partir de Vagrantfile)
~~~

##
