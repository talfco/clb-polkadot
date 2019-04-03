FROM ubuntu:16.04
LABEL maintainer "felix@cloudburo.net"

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y cmake pkg-config libssl1.0.0  libssl-dev git curl clang libclang-dev

# Install polkadot
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
	export PATH=$PATH:$HOME/.cargo/bin && \
	cargo install --git https://github.com/paritytech/polkadot.git --tag v0.4.1 polkadot
#RUN	mkdir -p /root/.local/share/Polkadot
RUN cp /root/.cargo/bin/polkadot /usr/local/bin/

RUN rm -rf /root/.cargo/ && \
    rm -rf /root/.rustup

# Add artefact
ADD monitorValidator.sh /root
RUN chmod 0644 /root/monitorValidator.sh
RUN chmod u+x /root/monitorValidator.sh

# Install the monitor cron
RUN apt-get update && \
    apt-get install cron
RUN (/usr/bin/crontab -l ; echo " * * * * *  bash -l -c '/root/monitorValidator.sh  > /dev/null 2>&1'") | /usr/bin/crontab


# Install SSHGuard
RUN apt-get update && \
    apt-get install -y sshguard

RUN apt-get update && \
    apt-get install -y python3.5 && \
    apt-get install -y vim-tiny

# SSHGuard
#RUN apt-get update && \
#    apt-get install -y sshguard  && \
#    iptables -N sshguard  && \
#    ip6tables -N sshguard  && \
#    iptables -A INPUT -j sshguard  && \
#    ip6tables -A INPUT -j sshguard  && \
#    service sshguard restart

RUN mkdir /data