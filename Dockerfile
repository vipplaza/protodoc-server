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
RUN npm i

RUN protoc --doc_out=./doc --doc_opt=html,index.html proto/*.proto --plugin=protoc-gen-doc=./bin/protoc-gen-doc
#RUN protoc --js_out=library=myproto_libs,binary:. /proto
#RUN protoc --php_out=out_dir /proto

CMD nodemon server.js
#ENTRYPOINT ["tail", "-f", "/dev/null"]
