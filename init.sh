#!/bin/sh

# Start the SSH server
service ssh start

# Execute the CMD from the Dockerfile
exec "$@"
