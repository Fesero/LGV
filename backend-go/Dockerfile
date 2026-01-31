FROM golang:1.22-alpine

RUN apk add --no-cache git curl

WORKDIR /app

COPY go.mod ./

EXPOSE 8080

CMD ["go", "run", "./cmd/server"]