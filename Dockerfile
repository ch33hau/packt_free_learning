FROM fedora:23

RUN mkdir /data

COPY ./packtpub-free-learning.sh  /opt/packtpub-free-learning.sh

CMD /opt/packtpub-free-learning.sh
