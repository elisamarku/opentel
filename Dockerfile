FROM golang:1.16-alpine AS builder

WORKDIR /src

# Leverage go modules cache to speed up builds
COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . ./

RUN go build ./cmd/formatter
RUN go build ./cmd/publisher

# ---

FROM alpine

COPY --from=builder /src/formatter /bin/formatter
COPY --from=builder /src/publisher /bin/publisher
