# Start with a minimal Go image
FROM golang:1.24-alpine AS builder

ARG VERSION="local"
ARG GIT_BRANCH="main"
ARG GIT_COMMIT="unknown"
ARG BUILD_TIMESTAMP="0000"

# Set the working directory
WORKDIR /app

# Copy and build the application
COPY . .
RUN GOAMD64=v3 CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="\
    -s \
    -X github.com/prometheus/common/version.Revision=${GIT_COMMIT} \
    -X github.com/prometheus/common/version.BuildUser=buildAgent \
    -X github.com/prometheus/common/version.BuildDate=${BUILD_TIMESTAMP} \
    -X github.com/prometheus/common/version.Branch=${GIT_BRANCH} \
    -X github.com/prometheus/common/version.Version=${VERSION}" -o locust_exporter .

# Create a smaller runtime image
FROM scratch

EXPOSE 9646

USER 1000

# Set the working directory
WORKDIR /

# Copy the built binary from the builder
COPY --from=builder /app/locust_exporter .

# Expose the metrics port
EXPOSE 8081

# Run the application
ENTRYPOINT ["/locust_exporter"]
