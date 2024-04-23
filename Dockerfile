FROM almalinux/9-base:latest as cacher

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
COPY requirements.txt .
RUN <<EOT
  set -ex
  python3 -m ensurepip
  pip3 install -r requirements.txt
  rm -rf requirements.txt ~/.cache/pip
EOT

ADD --chmod=755 https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /


FROM cacher as cacher-tests

COPY requirements-tests.txt .
RUN <<EOT
  set -ex
  pip3 install -r requirements-tests.txt
  rm -rf requirements-tests.txt ~/.cache/pip
EOT
