FROM docker.io/library/fedora:latest

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN dnf install -y zsh sudo git nano openssl curl && \
  dnf clean all && \
  useradd ${USERNAME} -G wheel -s /usr/bin/zsh && \
  echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER $USERNAME
