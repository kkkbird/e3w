# FROM golang:1.10 as backend
# RUN mkdir -p /go/src/github.com/kkkbird/e3w
# ADD . /go/src/github.com/kkkbird/e3w
# ENV GOPATH=/golibs:/go
# WORKDIR /go/src/github.com/kkkbird/e3w
# RUN CGO_ENABLED=0 go build

FROM node:8 as frontend
RUN mkdir /app
ADD static /app
WORKDIR /app
RUN npm --registry=https://registry.npm.taobao.org \
--cache=$HOME/.npm/.cache/cnpm \
--disturl=https://npm.taobao.org/mirrors/node \
--userconfig=$HOME/.cnpmrc install && npm run publish

#FROM alpine:latest
FROM kaiserli/confd:v1
RUN mkdir -p /app/static/dist /app/conf
#COPY --from=backend /go/src/github.com/soyking/e3w/e3w /app
COPY ./e3w /app
COPY --from=frontend /app/dist /app/static/dist
ADD ./confd /etc/confd
EXPOSE 8080
WORKDIR /app
CMD ["./e3w"]
