FROM golang:1.22-alpine AS builder

WORKDIR /app
COPY go.mod ./
COPY main.go ./
RUN go mod download && \
    CGO_ENABLED=0 GOOS=linux go build -o proxy main.go

FROM alpine:latest
RUN apk add --no-cache ca-certificates wget tar bash curl
WORKDIR /app
COPY --from=builder /app/proxy .
RUN mkdir -p /app/data /app/x
EXPOSE 2053
CMD ["./proxy"]
