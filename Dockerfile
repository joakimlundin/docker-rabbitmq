# From debian base image
FROM debian:stretch-slim

# Install RabbitMQ
RUN apt-get update && \
   apt-get install -y apt-transport-https gnupg wget && \
   echo "deb https://packages.erlang-solutions.com/debian stretch contrib" | tee -a /etc/apt/sources.list && \
   echo "deb https://dl.bintray.com/rabbitmq/debian stretch main" | tee /etc/apt/sources.list.d/bintray.rabbitmq.list && \
   wget -O- https://packages.erlang-solutions.com/debian/erlang_solutions.asc | apt-key add - && \
   wget -O- https://dl.bintray.com/rabbitmq/Keys/rabbitmq-release-signing-key.asc | apt-key add - && \
   apt-get update -y && \
   apt-get install -y procps && \
   apt-get install -y esl-erlang && \
   apt-get install -y rabbitmq-server && \
   apt-get clean

# Enable AMQP 1.0 plugin and management plugin
RUN rabbitmq-plugins enable rabbitmq_amqp1_0 && \
   rabbitmq-plugins enable rabbitmq_management && \
   chown rabbitmq:rabbitmq -R /var/lib/rabbitmq 

# Mount data directory
VOLUME /var/lib/rabbitmq

# Expose standard ports
EXPOSE 5672

#...and go!
CMD rabbitmq-server
