FROM python:alpine

LABEL name="Shadowsocks"

RUN pip install --no-cache-dir shadowsocks
COPY sysctl.conf /etc/sysctl.d/shadowsocks.conf
WORKDIR /shadowsocks

ENTRYPOINT ["ssserver"]
CMD ["-c", "config.json", "-q"]
