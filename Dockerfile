FROM node:9.1.0
LABEL maintainer="shogochiai <shogo1104@gmail.com>" protoc_version="3.3.0"

####################
# download
WORKDIR /
ADD https://github.com/google/protobuf/releases/download/v3.3.0/protoc-3.3.0-linux-x86_64.zip /
# send from "host" dir
ADD . /app
WORKDIR /app
RUN apt-get -q -y update
RUN apt-get -q -y install unzip curl sudo git vim golang

####################
# protoc
RUN unzip /protoc-3.3.0-linux-x86_64.zip -d /usr/local
RUN rm /protoc-3.3.0-linux-x86_64.zip
RUN apt-get remove --purge -y unzip
RUN apt-get autoremove
RUN rm -rf /var/lib/apt/lists/*

####################
# protoc-plugin
RUN apt-get -q -y install sudo git vim golang
RUN git clone https://github.com/pseudomuto/protoc-gen-doc.git
WORKDIR /app/protoc-gen-doc
RUN mkdir -p ../bin src
#RUN export GOPATH=/app/protoc-gen-doc && curl https://glide.sh/get | sh
ENV GOPATH=/app/protoc-gen-doc
RUN go get -u github.com/pseudomuto/protoc-gen-doc/cmd/...
RUN bash script/dist.sh
RUN tar -xvzf dist/protoc-gen-doc-1.0.0.linux-amd64.go1.3.3.tar.gz
RUN cp protoc-gen-doc-1.0.0.linux-amd64.go1.3.3/protoc-gen-doc ../bin/protoc-gen-doc

####################
# build
WORKDIR /app
RUN mkdir -p doc
RUN [ ! -f .server.js.remote ] || rm server.js && cp .server.js.remote server.js
RUN [ ! -f .package.json.remote ] || rm package.json && cp .package.json.remote package.json

RUN npm i
RUN npm run build:doc
#RUN npm run build:js
#RUN npm run build:php

CMD npm start
#ENTRYPOINT ["tail", "-f", "/dev/null"]
