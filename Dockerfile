FROM almalinux:9

RUN <<EOT
  set -ex
  umask 0077
  mkdir -p ~/.ssh
  printf 'Host github.com\n  StrictHostKeyChecking accept-new\n' >> ~/.ssh/config
EOT

RUN <<EOT
  set -ex
  dnf upgrade -y
  dnf install -y git
  dnf clean all
EOT

WORKDIR /code
COPY requirements.* .
RUN <<EOT
  set -ex
  python3 -m ensurepip
  pip3 install -r requirements.devel.txt
  rm requirements.*
EOT

ADD --chmod=755 https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /
