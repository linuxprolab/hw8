# Домашнее задание 8. Systemd
Выполнить следующие задания и подготовить развёртывание результата выполнения с использованием Vagrant и Vagrant shell provisioner (или Ansible, на Ваше усмотрение):

1. Написать service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова (файл лога и ключевое слово должны задаваться в /etc/sysconfig).
2. Из репозитория epel установить spawn-fcgi и переписать init-скрипт на unit-файл (имя service должно называться так же: spawn-fcgi).
3. Дополнить unit-файл httpd (он же apache) возможностью запустить несколько инстансов сервера с разными конфигурационными файлами.
4. *Скачать демо-версию Atlassian Jira и переписать основной скрипт запуска на unit-файл.

## Проверка
Все 4 задачи выполнены в одной машине с использованием Vagrant и Vagrant shell provisioner.
- Склонировать репозиторий
```
git clone https://github.com/linuxprolab/hw8.git
cd hw8/
```
- Запустить vagrant
```
vagrant up
vagrant ssh -- -t "export TERM=xterm; sudo -i"
```
- Задание 1
```
systemctl status watchlog.timer
grep Master /var/log/messages
```
- Задание 2
```
systemctl status spawn-fcgi.service
```
- Задание 3
```
systemctl status httpd@first.service
systemctl status httpd@second.service
ss -tlpn | grep 80
ss -tlpn | grep 8080
```
- Задание 4
```
systemctl status jira.service
ss -tlpn | grep 8888
```

## Ссылки
- Документация Jira
  - https://confluence.atlassian.com/adminjiraserver/installing-jira-applications-on-linux-from-archive-file-938846844.html
  - https://confluence.atlassian.com/jirakb/run-jira-as-a-systemd-service-on-linux-979411854.html
  - https://confluence.atlassian.com/adminjiraserver/unattended-installation-938846846.html
- Документация Vagrant
  - https://www.vagrantup.com/docs/synced-folders/rsync
  - https://www.vagrantup.com/docs/provisioning/file
  - https://www.vagrantup.com/docs/provisioning/shell#privileged
- Misc
  - https://serverfault.com/questions/775246/systemd-timer-not-starting-its-service-unit
  - https://stackoverflow.com/questions/54067192/vagrant-config-vm-provision-does-not-allow-me-to-copy-a-file-to-etc-nginx-conf
  - https://stackoverflow.com/questions/14295771/how-do-i-extract-files-without-folder-structure-using-tar
  - https://access.redhat.com/solutions/61334