FROM ubuntu:18.04
MAINTAINER savanni@luminescent-dreams.com

RUN apt-get update
RUN apt-get install -y curl make gcc libc-dev bash ruby ruby-dev gem awscli git

RUN curl https://static.rust-lang.org/dist/rust-1.33.0-x86_64-unknown-linux-gnu.tar.gz > /tmp/rust-1.33-0-x86_64-unknown-linux-gnu.tar.gz
RUN cd /tmp && tar -xf rust-1.33-0-x86_64-unknown-linux-gnu.tar.gz
RUN /tmp/rust-1.33.0-x86_64-unknown-linux-gnu/install.sh --prefix=/opt/rust
RUN curl https://nodejs.org/download/release/v10.15.3/node-v10.15.3-linux-x64.tar.gz > /tmp/node-v10.15.3-linux-x64.tar.gz
RUN cd /opt && tar -xf /tmp/node-v10.15.3-linux-x64.tar.gz
RUN gem install fpm

ENV PATH=/opt/rust/bin:/opt/node-v10.15.3-linux-x64/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
