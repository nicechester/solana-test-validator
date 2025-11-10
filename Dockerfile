# Build stage
FROM rust:1.75-slim AS builder

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    clang \
    cmake \
    curl \
    git \
    libssl-dev \
    libudev-dev \
    pkg-config \
    protobuf-compiler \
    && rm -rf /var/lib/apt/lists/*

# Clone Solana repository
WORKDIR /build
RUN git clone https://github.com/solana-labs/solana.git

# Build Solana CLI from source
WORKDIR /build/solana
RUN cargo build --release --bin solana-test-validator --bin solana --bin solana-keygen

# Runtime stage
FROM debian:bookworm-slim

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libssl3 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy compiled binaries from builder
COPY --from=builder /build/solana/target/release/solana-test-validator /usr/local/bin/
COPY --from=builder /build/solana/target/release/solana /usr/local/bin/
COPY --from=builder /build/solana/target/release/solana-keygen /usr/local/bin/

# Create ledger directory
RUN mkdir -p /solana/ledger

WORKDIR /solana

# Expose ports
EXPOSE 8899 8900 9900

# Run test validator
CMD ["solana-test-validator", \
     "--rpc-port", "8899", \
     "--bind-address", "0.0.0.0", \
     "--faucet-port", "9900", \
     "--faucet-sol", "1000", \
     "--ledger", "/solana/ledger", \
     "--reset"]