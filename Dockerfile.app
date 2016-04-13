FROM ruby:alpine
#RUN apt-get update -qq && \
#    apt-get install -y build-essential libpq-dev && \
#    apt-get install -y nginx && \
#    rm -rf /var/lib/apt/lists/* && \
#    mkdir -p /myapp/tmp/pids /myapp/logs
RUN apk add --no-cache --virtual .ruby-builddeps \
    autoconf \
    bison \
    bzip2 \
    bzip2-dev \
    ca-certificates \
    coreutils \
    curl \
    gcc \
    g++ \
    make \
    gdbm-dev \
    glib-dev \
    libc-dev \
    libedit-dev \
    libffi-dev \
    libxml2-dev \
    libxslt-dev \
    linux-headers \
    cyrus-sasl-dev \
    ncurses-dev \
    openssl-dev \
    procps \
    tcl-dev \
    yaml-dev \
    zlib-dev \
    tar
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
ADD . /myapp
RUN chmod 755 run-app.sh && mkdir log && mkdir -p tmp/pids
RUN apk del .ruby-builddeps
#
CMD ["sh", "run-app.sh"]
