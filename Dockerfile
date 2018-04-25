FROM alpine

ARG alpine_mirror=
ARG build_ver=
RUN if [ -n "${alpine_mirror}" ] ; then sed -i "s#dl-cdn.alpinelinux.org#${alpine_mirror}#g"  /etc/apk/repositories ; fi  && \
 apk add  --no-cache zlib openssl linux-pam && \
 mkdir -p /usr/local/hpn-ssh

ADD ./hpn-ssh /usr/local/hpn-ssh
ENV PATH=$PATH:/usr/local/hpn-ssh/bin
RUN cd  /usr/local/hpn-ssh && mkdir -p /usr/local/sbin && \
 ln -s $(pwd)/sbin/sshd /usr/local/sbin/sshd && \
 $(pwd)/sbin/sshd  -v | true 
CMD [  "/usr/local/hpn-ssh/sbin/sshd","-D" ] 
