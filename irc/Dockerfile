FROM piratenbpt/base
RUN apt-get install -y charybdis stunnel
ADD startup.sh /startup.sh
ADD ircd.motd /etc/charybdis/ircd.motd
ADD ircd.conf.sample /etc/charybdis/ircd.conf.sample
EXPOSE 6665 6666 6667 6668 6669 6697
ENV SERVERID 002
ENV SERVERNAME local.piraten-bpt.de
ENV SERVERDESC PiratenBPT local Server
ENV NETWORKNAME PiratenBPT
ENV NETWORKDESC Orga-network to coordinate BPT
ENV ADMINNAME PiratenBPT NOC
ENV ADMINDESC NOC des PiratenBPT
ENV ADMINMAIL noc@piraten-bpt.de
ENV PASSWORD_CONNECT secret
ENV PASSWORD_OPER secret
ENV PASSWORD_WEBCHAT passwordhere
CMD /startup.sh
