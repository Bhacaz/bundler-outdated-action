
ARG RUBY_IMAGE

FROM $RUBY_IMAGE

COPY src/* ./
COPY entrypoint.sh ./entrypoint.sh
RUN apk add --no-cache git

ENTRYPOINT ["./entrypoint.sh"]
