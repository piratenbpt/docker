FROM piratenbpt/base
RUN apt-get install -y cups cups-pdf
RUN apt-get install -y cups-driver-gutenprint
EXPOSE 80 631
CMD cupsd -f
