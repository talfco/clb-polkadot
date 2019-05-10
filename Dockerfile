FROM ubuntu:16.04
LABEL maintainer "felix@cloudburo.net"

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y cmake pkg-config libssl1.0.0  libssl-dev git curl clang libclang-dev

# Install polkadot
#RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
#	export PATH=$PATH:$HOME/.cargo/bin && \
#	cargo install --git https://github.com/paritytech/polkadot.git --tag v0.4.3 polkadot

#RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
#	export PATH=$PATH:$HOME/.cargo/bin && \
#	rustup default nightly && \
#    rustup target add wasm32-unknown-unknown --toolchain nightly && \
#    cargo +nightly install --git https://github.com/alexcrichton/wasm-gc && \
#    rustup default stable && \
#    rustup update && \
#	cargo install --git https://github.com/paritytech/polkadot.git --tag v0.4.3 polkadot

# https://wiki.polkadot.network/en/latest/polkadot/node/guides/how-to-validate/
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
	export PATH=$PATH:$HOME/.cargo/bin && \
    rustup update && \
    git clone https://github.com/paritytech/polkadot.git  && \
    cd polkadot  && \
    git checkout v0.4.3 && \
    git pull origin v0.4.4 && \
    ./scripts/init.sh && \
    ./scripts/build.sh && \
    cargo install --path ./ --force


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

EXPOSE 30333 9933 9944
VOLUME ["/root/.local/share/Polkadot"]

CMD ["/usr/local/bin/polkadot"]