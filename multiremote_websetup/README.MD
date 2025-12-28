# ini hanyalah dokumentasi belajar vagrant saya untuk memperdalam pengetahuan tentang cloud computing dan devops\

### setup step

`$ vagrant up`
`$ vagrant ssh scriptbox`
`[vagrant@scriptbox ~] $ sudo -i`
`[root@scriptbox ~]  $ vim /etc/hosts`

#### tambahkan

`web01 192.168.10.13`
`web02 192.168.10.14`
`web03 192.168.10.15`

#### VM web01

`[root@web01 ~] $ useradd devops`
`[root@web01 ~] $ passwd devops`

#### VM web02

`[root@web02 ~] $ useradd devops`
`[root@web02 ~] $ passwd devops`

#### VM web03

`[root@web03 ~] $ adduser devops`
`[root@web03 ~] $ passwd devops`

#### VM scriptbox

`[root@scriptbox ~] $ ssh-keygen`
`[root@scriptbox ~] $ ssh-copy-id devops@web01`
`[root@scriptbox ~] $ ssh-copy-id devops@web02`
`[root@scriptbox ~] $ ssh-copy-id devops@web03`

`[root@scriptbox ~] $ mkdir /opt/scripts/remote_websetup`

pembuatan script dilakukan di host dengan tujuan mempermudah.\
sehingga tahapannya setiap ada perubahan file:\
scriptFile (host) -> upload/copypaste ke VM (scriptbox) -> scriptbox distribusi setup.sh ke VM lainnya
`[root@scriptbox ~] $ vagrant ssh-config`
`[root@scriptbox ~] $ scp -F vagrant_ssh_config setup.sh scriptbox:/opt/scripts/remote_websetup`
`[root@scriptbox ~] $ scp -F vagrant_ssh_config deploy.sh scriptbox:/opt/scripts/remote_websetup`
`[root@scriptbox ~] $ scp -F vagrant_ssh_config remhosts scriptbox:/opt/scripts/remote_websetup`

#### jalankan script

`[root@scriptbox ~] $ ./opt/scripts/remote_websetup/deploy.sh`
