# Vagrant

- Sistema per a crear màquines virtuals VirtualBox, VMWare, AWS o d'altres proveïdors de forma automàtica i ja configurades.

## Inici: Crear un projecte nou

- Per començar a treballar, es crea un directori de projecte i a dintre es crearà el fitxer Vagrantfile (ho fa vagrant init). Cal indicar la imatge (Vagrant li diu "Box") que volem iniciar. Si no la troba localment, fa un pull del repositori (en aquest cas "hashicorp").

~~~
$ mkdir projecte
$ cd projecte
$ vagrant init  hashicorp/precise64
~~~

- Fitxer per defecte Vagrantfile (porta comentaris per indicar els paràmetres).
~~~
# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "hashicorp/precise64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end

~~~

## Arrencar, connectar, destruir la màquina virtual

- Per posar la màquina virtual en marxa i connectar via ssh:

~~~
$ vagrant up
$ vagrant ssh
~~~

- Per destruir la màquina virtual

~~~
$ vagrant destroy
~~~

## Continuar amb Vagrant

Un cop creada, es pot anar al directori i posar en marxa la màquina virtual ja creada:

~~~
$ vagrant init
~~~

## Clonar màquines

Per clonar una màquina virtual (d’una imatge creada o Box), baixar-la del repositori hashicorp (usuari/nomimatge) [https://app.vagrantup.com/boxes/search](https://app.vagrantup.com/boxes/search))

~~~
$ vagrant box add hashicorp/precise64
~~~

## Afegir imatge a una màquina

- Es pot afegir quina imatge (Box) fer servir al Vagrantfile.

~~~
Vagrant.configure("2") do |config|  
config.vm.box = "hashicorp/precise64"  
config.vm.box_version = "1.1.0"
config.vm.box_url = "http://files.vagrantup.com/precise64.box"
end  
~~~

- box_version i box_url són opcionals

##Carpeta compartida

Per defecte Vagrant comparteix la carpeta del projecte (amb el Vagrantfile) a la carpeta /vagrant de la màquina virtual.

## Provisionament automàtic

- Es fa el provisionament de la màquina virtual a partir de l'execució d'un script (per exemple bootstrap.sh), i es posa al Vagrantfile.

Fitxer bootstrap.sh (instal·la Apache i enllaça el directori de l'apache amb la carpeta compartida per defecte. Així es podran canviar els arxius de l'Apache des de l'equip físic):
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

## Arrencar màquina provisionant (només si es força o quan s'inicialitza la primera vegada)

Si ja funcionava:

~~~
$ vagrant reload --provision
~~~

Si es nova (la provisió només es fa la primera vegada):

~~~
$ vagrant up
~~~

Comprovar el funcionament (fer una petició web amb wget):

~~~
$ vagrant ssh
...
vagrant@precise64:~$ wget -qO- 127.0.0.1
~~~

## Configuració de Xarxa

- Al Vagrantfile, cal afegir l'opció de configuració de xarxa. Si es vol més d'un reenviament, es posen més línies.

~~~
config.vm.network :forwarded_port, guest: 80, host: 8080
config.vm.network :forwarded_port, guest: 443, host: 8443
~~~
- Es pot indicar "guest_ip:<ip>" i "host_ip:<ip>" (si no, es reenvien totes les ips). També "id:cadena" per posar nom a la regla NAT (es veu a VirtualBox).

- Més opcions de xarxa (si cal activar els dos protocols, ja que només es fa per defecte amb tcp).

~~~
Vagrant.configure("2") do |config|
  config.vm.network "forwarded_port", guest: 2003, host: 12003, protocol: "tcp"
  config.vm.network "forwarded_port", guest: 2003, host: 12003, protocol: "udp"
end

~~~

- Provar que funciona:

~~~
$ vagrant reload
~~~

Provar al navegador: http://127.0.0.1:4567

## Configurar xarxes internes

- Els apràmetres de les màquines virtuals es configuren automàticament en Vagrant. Si no es vol automàtic, cal indicar el paràmetre:

~~~
config.vm.network "private_network", ip: "192.168.50.4", auto_config: false
~~~

- DHCP

~~~
Vagrant.configure("2") do |config|
  config.vm.network "private_network", type: "dhcp"
end
~~~

- Estàtica

~~~
Vagrant.configure("2") do |config|
  config.vm.network "private_network", ip: "192.168.50.4"
end
~~~

- IPv6

~~~
Vagrant.configure("2") do |config|
  config.vm.network "private_network",
    ip: "fde4:8dba:82e1::c4",
    netmask: "96"
end
~~~

## Crear compartició a internet

- Permet accedir a la màquina virtual des d'una URL pròpia.

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
