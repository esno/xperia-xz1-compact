#!/bin/bash -e

NAMESERVER="8.8.8.8"

die() {
  echo "${1}" && exit 1
}

lxccfg() {
  echo "lxc.network.type = none" >> ${1}
  echo "lxc.mount.entry=${DEVDIR} usr/local/development none bind,create=dir 0 0" >> ${1}
}

lxcrun() {
  lxc-attach -n "${INSTANCE}" -v "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" -- /bin/bash -c "${1}"
}

if [ "${EUID}" -ne 0 ]; then
  if which sudo &> /dev/null; then
    sudo ${0} ${@}
    exit
  else
    die "you must be root!"
  fi
fi

if [ "${1}" = "" ]; then
  die "USAGE: ${0} <instance> [<devdir>]"
else
  INSTANCE=${1}
fi

if [ "${2}" = "" ]; then
  DEVDIR=$(dirname $(dirname $(realpath ${0})))
else
  DEVDIR=${2}
fi

if ! lxc-info -n "${INSTANCE}" &> /dev/null; then
  export LXCCONFIG=$(mktemp)
  export DEBIAN_FRONTEND=noninteractive

  lxccfg ${LXCCONFIG}
  lxc-create -n "${INSTANCE}" -f ${LXCCONFIG} -t ubuntu -- -r xenial
  rm ${LXCCONFIG}
  lxc-start -n "${INSTANCE}"

  lxcrun 'rm /etc/resolv.conf'
  lxcrun "echo nameserver ${NAMESERVER} | tee /etc/resolv.conf"

  # create user
  lxcrun 'userdel ubuntu'
  LXCUID=$(ls -an ${DEVDIR} | sed -n 2p | awk '{ print $3 }')
  LXCGID=$(ls -an ${DEVDIR} | sed -n 2p | awk '{ print $4 }')
  lxcrun "groupadd -g ${LXCGID} user"
  lxcrun "useradd -m -g ${LXCGID} -u ${LXCUID} user"

  lxcrun 'apt-get update'
  lxcrun 'apt-get install -y ansible aptitude'
fi

ANSIBLEDIR="/usr/local/development/$(basename $(dirname $(realpath ${0})))/.env"
lxcrun "/bin/su -l -c 'cd ${ANSIBLEDIR} && ansible-playbook -i inventory/hosts.ini prepare.yml'"
