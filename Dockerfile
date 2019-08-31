# Builder image downloads and extracts archive
FROM alpine:3.10 AS builder
ARG SYNCPLAY_VERSION

# install wget and ca-certs for https download
RUN apk add --no-cache wget ca-certificates

# make the dest din
RUN mkdir -p /srv
WORKDIR /srv

# Download and extract
RUN wget -q https://github.com/Syncplay/syncplay/archive/v$SYNCPLAY_VERSION.tar.gz -O /srv/syncplay.tar.gz
RUN tar -zxf syncplay.tar.gz
RUN mv syncplay-$SYNCPLAY_VERSION/ syncplay/



# Python 3.7 and Alpine 3.10 are most recent stable at time of build
FROM python:3.7.4-alpine3.10
RUN apk --update add build-base libffi-dev openssl-dev

# Copy the extracted tar from the builder
COPY --from=builder /srv/syncplay /srv
WORKDIR /srv

# Install dependencies
RUN pip3 install --upgrade -q --no-cache-dir pip
RUN pip3 install -q -r requirements.txt

# Create the run script
RUN echo "#!/bin/sh" > startScript.sh
RUN echo "python syncplayServer.py \$@" >> startScript.sh
RUN chmod +x startScript.sh

# Define the entrypoint
# You can add standard syncplay-server options
# by defining the cmd as those options
ENTRYPOINT ./startScript.sh

