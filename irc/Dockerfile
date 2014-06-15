FROM piratenbpt/base
RUN apt-get install -y charybdis stunnel
ADD startup.sh /startup.sh
ADD ircd.motd /etc/charybdis/ircd.motd
ADD ircd.conf.sample /etc/charybdis/ircd.conf.sample
EXPOSE 6665 6666 6667 6668 6669 6697
CMD /startup.sh
