FROM python:alpine

LABEL name="Shadowsocks"

RUN apk add git
RUN pip install git+https://github.com/shadowsocks/shadowsocks.git@2.9.1
COPY sysctl.conf /etc/sysctl.d/shadowsocks.conf
WORKDIR /shadowsocks

ENTRYPOINT ["ssserver"]
CMD ["-c", "config.json", "-q"]
