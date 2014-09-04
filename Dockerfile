FROM dockerfile/nodejs 
#Node App
COPY . /src
RUN cd /src; npm install
#CMD node /src/app.js

# Consul
RUN apt-get update
RUN apt-get install -y unzip wget
WORKDIR /tmp
RUN wget https://dl.bintray.com/mitchellh/consul/0.3.1_linux_amd64.zip
RUN unzip 0.3.1_linux_amd64.zip
RUN chmod +x consul
RUN cp consul /usr/local/bin/.
RUN mkdir /etc/consul.d
RUN echo '{"service": {"name": "web", "tags": ["nodejs"], "port": 3000}}' > /etc/consul.d/web.json

# envconsul
RUN apt-get install -y golang
RUN apt-get install -y git
ENV GOPATH /.go
RUN go get -u github.com/armon/consul-kv
RUN go get -u github.com/hashicorp/envconsul
WORKDIR /.go/src/github.com/hashicorp/envconsul
RUN go build

# Supervisor
RUN apt-get install -y supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"]
