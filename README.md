# Домашнее задание 8. Systemd
Выполнить следующие задания и подготовить развёртывание результата выполнения с использованием Vagrant и Vagrant shell provisioner (или Ansible, на Ваше усмотрение):

1. Написать service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова (файл лога и ключевое слово должны задаваться в /etc/sysconfig).
2. Из репозитория epel установить spawn-fcgi и переписать init-скрипт на unit-файл (имя service должно называться так же: spawn-fcgi).
3. Дополнить unit-файл httpd (он же apache) возможностью запустить несколько инстансов сервера с разными конфигурационными файлами.
4. *Скачать демо-версию Atlassian Jira и переписать основной скрипт запуска на unit-файл.

## Проверка
Все 4 задачи выполнены в одной машине с использованием Vagrant и Vagrant shell provisioner.
### 1. Склонировать репозиторий
   - `git clone https://github.com/linuxprolab/hw8.git`
### 2. Запустить vagrant
   - `cd hw8/`
   - `vagrant up`
   - `vagrant ssh -- -t "export TERM=xterm; sudo -i"`
### 3.1. Задание 1
   - `systemctl status watchlog.timer` 
   - `grep Master /var/log/messages`
### 3.2. Задание 2
   - `systemctl status spawn-fcgi.service`
### 3.3. Задание 3
   - `systemctl status httpd@first.service`
   - `systemctl status httpd@second.service`
   - `ss -tlpn | grep 80`
   - `ss -tlpn | grep 8080` 
### 3.4. Задание 4
   - `systemctl status jira.service`
   - `ss -tlpn | grep 8888`
  