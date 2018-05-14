# Pràctica per recuperar UF3 de M11 (seguretat i alta disponibilitat)

## Plantejament

Es tracta de construir una xarxa d'empresa amb un firewall implementat amb **IPTABLES** que tindrà 3 interfícies:

1. La primera externa, dona accés a Internet i fa NAT, de manera que les adreces privades, tant de la DMZ com la xarxa interna no es poden veure des de fora.

1. La segona interna, cap a la xarxa local de l'empresa.

1. La tercera interna, cap a la xarxa DMZ de l'empresa, on residiran els servidors públics de l'empresa.

També caldrà configurar 3 màquines virtuals:

1. El firewall de 3 potes. Un Ubuntu Server, per exemple.
1. El servidor públic de la DMZ i el seu firewall de host. Un Ubuntu Server, per exemple.
1. El client amb interfície gràfica de la xarxa local i el seu firewall de host (amb un tindrem prou). Un Ubuntu Desktop, per exemple.

## Requisits

1. A la DMZ tindrem els serveis Web, FTP, Proxy Squid i ssh (al mateix servidor). La resta de ports del servidor han d'estar tancats.

1. Totes les màquines de la xarxa local podran accedir als serveis web d'internet (estàndar i segur) NOMÉS via el servidor Proxy. Qualsevol accés directe a Internet s'ha de blocar.

1. El servidor Proxy ha de demanar l'autenticació d'usuaris i no permetre l'accés a pàgines web de comerç electrònic, publicitat i pornografia (caldrà configurar squidGuard o fer una configuració de Squid amb fitxers de filtrat).

1. Totes les màquines de la xarxa local podran accedir als serveis web i ftp de les màquines de la DMZ, però la resta s'ha de blocar.

1. El firewall de les màquines de la xarxa local no ha de permetre rebre cap petició de serveis. Només li arribarà el tràfic com a resposta a les peticions que la màquina hagi generat. Es pot provar des de la màquina firewall.

1. Només es podrà accedir des de internet als serveis web i ftp de les màquines de la DMZ. Caldrà configurar la redirecció de ports cap als servidors de la DMZ.

1. Cal poder accedir al servei ssh del servidor de la DMZ des d'Internet, al port 2222 (caldrà configurar la redirecció de ports al firewall).

1. La resta de tràfic ha d'estar blocat: si es fa un scanneig de ports del firewall des de màquines situades a les xarxes connectades a qualsevol de les interfícies, han d'aparèixer oberts només els ports dels serveis habilitats.
