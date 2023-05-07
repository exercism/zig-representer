FROM alpine:3.17

# TODO: install packages required to run the representer
RUN apk add --no-cache bash jq

WORKDIR /opt/representer
COPY . .
ENTRYPOINT ["/opt/representer/bin/run.sh"]
