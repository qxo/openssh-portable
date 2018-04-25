cd $(dirname $0)
dir=$(pwd)
tag=hpn-openssh
tag1=${tag}_builder
target=/usr/local/hpn-ssh

if [ -z "${alpine_mirror}" -a "$TZ" = "CST-8" ] ; then
 alpine_mirror=mirrors.ustc.edu.cn
fi

if [ -z "${build_args}" ] ; then
 build_args=""
fi

test -n "${alpine_mirror}" &&  build_args="${build_arg}  --build-arg alpine_mirror=$alpine_mirror"

if [ -z "${ignore_build}" ] ; then
 docker build -t $tag1 ${build_args}  - < ./Dockerfile4builder
 docker rm -f hpn-ssh-builder
 ssh_build_args="--disable-strip --disable-lastlog --disable-wtmp --with-privsep-user=sshd --with-privsep-path=/var/empty  --with-md5-passwords     --with-ssl-engine --without-pam"
 docker run -it --name hpn-ssh-builder  --privileged -w $dir  -v /dev/random:/dev/random  -v $dir:$dir $tag1 \
   sh -c "make clean &&  mkdir -p $target && autoreconf -vif && ./configure $ssh_build_args  --prefix=$target --sysconfdir=${target}/etc && make && make  install "
fi
  
  test -d ${dir}/hpn-ssh && rm -rf ${dir}/hpn-ssh
  #mkdir -p ${dir}/hpn-ssh
  docker cp hpn-ssh-builder:${target} ./
  ls -l ${dir}/hpn-ssh
docker build -t  $tag ${build_args} . 
