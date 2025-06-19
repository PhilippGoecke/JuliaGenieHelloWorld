FROM debian:bookworm-slim as build-env

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y \
  # install tools
  && apt install -y --no-install-recommends ca-certificates curl gnupg \
  # make image smaller
  && apt purge -y --auto-remove curl unzip \
  && rm -rf "/var/lib/apt/lists/*" \
  && rm -rf /var/cache/apt/archives

ENV JULIA_PATH /usr/local/julia
ENV PATH $JULIA_PATH/bin:$PATH

# https://julialang.org/juliareleases.asc
# Julia (Binary signing key) <buildbot@julialang.org>
ENV JULIA_GPG 3673DF529D9049477F76B37566E3C7DC03D6E495

# https://julialang.org/downloads/
ENV JULIA_VERSION 1.11.5

RUN set -eux; \
# https://julialang.org/downloads/#julia-command-line-version
# https://julialang-s3.julialang.org/bin/checksums/julia-1.11.5.sha256
  url='https://julialang-s3.julialang.org/bin/linux/x64/1.11/julia-1.11.5-linux-x86_64.tar.gz'; \
  sha256='723e878c642220cc0251a0e13758c059a389cadc7f01376feaf1ea7388fe8f9c'; \
  curl -fL -o julia.tar.gz.asc "$url.asc"; \
  curl -fL -o julia.tar.gz "$url"; \
  echo "$sha256 *julia.tar.gz" | sha256sum --strict --check -; \
  export GNUPGHOME="$(mktemp -d)"; \
  gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$JULIA_GPG"; \
  gpg --batch --verify julia.tar.gz.asc julia.tar.gz; \
  gpgconf --kill all; \
  rm -rf "$GNUPGHOME" julia.tar.gz.asc; \
  mkdir "$JULIA_PATH"; \
  tar -xzf julia.tar.gz -C "$JULIA_PATH" --strip-components 1; \
  rm julia.tar.gz; \
  julia --version

WORKDIR /genie

COPY hello.js .

CMD ["julia", "hello.js"]
