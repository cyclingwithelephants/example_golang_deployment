############################
# STEP 1 build executable binary
############################

# This is the first stage, for building things that will be required by the
# final stage (notably the binary)
FROM golang AS builder

# COMMENTED OUT FOR NOW AS THESE FILES DON'T EXIST
# # Copy in just the go.mod and go.sum files, and download the dependencies. By
# # doing this before copying in the other dependencies, the Docker build cache
# # can skip these steps so long as neither of these two files change.
# COPY go.mod go.sum ./
# RUN go mod download

COPY ./src/* .

# Build the Go app with CGO_ENABLED=0 so we use the pure-Go implementations for
# things like DNS resolution (so we don't build a binary that depends on system
# libraries)
RUN CGO_ENABLED=0 \
    GOOS=linux \
    go build -o /app

# Create a "nobody" non-root user for the next image by crafting an /etc/passwd
# file that the next image can copy in. This is necessary since the next image
# is based on scratch, which doesn't have adduser, cat, echo, or even sh.
RUN echo "nobody:x:65534:65534:Nobody:/:" > /etc_passwd

############################
# STEP 2 build a small image :)
############################

FROM scratch

# Copy the binary from the builder stage
COPY --from=builder /app /app

# Copy the certs from the builder stage
# Currently doesn't exist
# COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Copy the /etc_passwd file we created in the builder stage into /etc/passwd in
# the target stage. This creates a new non-root user.
COPY --from=builder /etc_passwd /etc/passwd

# Run as the new non-root by default
USER nobody

ENTRYPOINT ["/app"]
