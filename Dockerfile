# Use a specific version of Alpine to ensure consistent builds and avoid breaking changes
FROM alpine:3.18

# Install necessary packages: unzip for extracting PocketBase, ca-certificates for SSL
RUN apk add --no-cache \
    unzip \
    ca-certificates && \
    # Create a directory for PocketBase
    mkdir -p /pb

# Use an environment variable for PocketBase version
# Default to a specific version if the variable is not set
ENV PB_VERSION=${PB_VERSION:-0.22.18}

# Download PocketBase zip file using wget
# We use wget here for better control over the download process, like suppressing output
RUN wget -qO /tmp/pb.zip https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip && \
    # Unzip the downloaded file into the /pb directory
    unzip /tmp/pb.zip -d /pb/ && \
    # Remove the zip file to reduce image size
    rm /tmp/pb.zip

# Expose the default PocketBase port
EXPOSE 8080

# Start PocketBase server on all network interfaces
CMD ["/pb/pocketbase", "serve", "--http=0.0.0.0:8080"]

