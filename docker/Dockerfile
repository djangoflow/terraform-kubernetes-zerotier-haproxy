FROM zerotier/zerotier
RUN apt-get update --fix-missing \
  && apt-get install -y iptables \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
COPY entrypoint-iptables.sh /entrypoint-iptables.sh
ENTRYPOINT ["/entrypoint-iptables.sh"]
