podman build --no-cache --rm -f Containerfile -t genie:demo .
podman run --interactive --tty -p 8000:8000 genie:demo
echo "browse http://localhost:8000/"
