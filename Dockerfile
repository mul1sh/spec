# vault org api docker file
FROM ubuntu:18.04

ADD . /speculos
WORKDIR /speculos
# Single RUN for Single stage without multistage without squash
RUN /speculos/scripts/docker_install.sh
# default port for dev env
EXPOSE 1234
EXPOSE 1236
EXPOSE 9999
EXPOSE 40000
EXPOSE 41000
EXPOSE 42000

ENTRYPOINT [ "python3", "./speculos.py" ]
