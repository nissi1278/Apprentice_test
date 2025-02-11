FROM ubuntu:latest

# https://qiita.com/ssc-ynakamura/items/d69307a3d94bf81c363d
RUN apt-get update -y
RUN apt-get install -y sudo git make curl ssh vim emacs man-db unminimize
RUN yes | unminimize

RUN useradd -m -s /bin/bash nissi
RUN echo "nissi:nissi1278" | chpasswd
RUN gpasswd -a nissi sudo

USER nissi

WORKDIR /home9