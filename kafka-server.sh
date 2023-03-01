#!/bin/bash

# INSTALL DOCKER
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# INSTALL DOCKER COMPOSE
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# SETUP SSL
    sudo apt update
    sudo apt install nginx -yqq

    sudo mkdir -p /var/www/"${var.domain}"/html
    sudo chown -R $USER:$USER /var/www/"${var.domain}"/html
    sudo chmod -R 755 /var/www/"${var.domain}"
    sudo rm -f /var/www/"${var.domain}"/html/index.html
    sudo echo "
      <html>
          <head>
              <title>Welcome to Your Website!</title>
          </head>
          <body>
              <h1>Success!  The Your Website server block is working!</h1>
          </body>
      </html>" >> /var/www/"${var.domain}"/html/index.html

    sudo su

    echo "server {
        listen 81;
        listen [::]:81;

        root /var/www/"${var.domain}"/html;
        index index.html index.htm index.nginx-debian.html;

        server_name "${var.domain}";

        location / {
                try_files $uri $uri/ =404;
        }
    }" >> /etc/nginx/sites-available/"${var.domain}"

    nginx -t
    ln -s /etc/nginx/sites-available/"${var.domain}" /etc/nginx/sites-enabled/
    systemctl reload nginx

# INSTALL KAFKA, ZOOKEEPER, KAFKA-UI
mkdir -p ~/kafka
cd ~/kafka

echo "
version: '3'
services:
  zookeeper:
    image: confluentinc/cp-zookeeper:7.3.0
    container_name: zookeeper
    ports:
      - 2181:2181
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      ZOOKEEPER_TICK_TIME: 2000
    networks:
      - kafka-network
  broker:
    image: confluentinc/cp-kafka:5.3.1
    hostname: localhost
    container_name: broker
    ports:
      - 9092:9092
      - 29092:29092
      - 19092:19092
    depends_on:
      - zookeeper
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT,PLAINTEXT_INTERNAL:PLAINTEXT,PLAINTEXT_EXTERNAL:PLAINTEXT
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://broker:9092,PLAINTEXT_INTERNAL://broker:29092,PLAINTEXT_EXTERNAL://localhost:19092
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
      KAFKA_TRANSACTION_STATE_LOG_MIN_ISR: 1
      KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR: 1
      ALLOW_PLAINTEXT_LISTENER: 'yes'
    networks:
      - kafka-network
  kafka-ui:
    image: provectuslabs/kafka-ui
    container_name: kafka-ui
    ports:
      - 8080:8080
      - 82:8080
    restart: always
    environment:
      KAFKA_CLUSTERS_0_NAME: local
      KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS: broker:9092
      KAFKA_CLUSTERS_0_ZOOKEEPER: zookeeper:2181
    depends_on:
      - broker
      - zookeeper
    networks:
      - kafka-network
  
networks:
  kafka-network:
    driver: bridge
" >>~/kafka/docker-compose.yml

docker-compose up -d