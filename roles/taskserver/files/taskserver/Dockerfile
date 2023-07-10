FROM golang:1.20-alpine AS taskserver-builder

RUN go install github.com/szaffarano/gotas@latest

FROM alpine:latest AS taskserver
ENV TASKDDATA=/var/taskd
WORKDIR /app
COPY --from=taskserver-builder /go/bin/gotas /usr/local/bin/gotas
EXPOSE 53589
CMD ["gotas", "server"]
