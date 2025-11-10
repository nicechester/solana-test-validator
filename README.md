# Solana Test Validator Docker

Docker setup for running a Solana test validator with pre-funded test accounts. Built from source to support ARM64/AARCH64 architectures.

## Features

- 🚀 Solana test validator built from source
- 💰 Pre-configured faucet with 1000 SOL
- 🏗️ Multi-stage Docker build for optimized image size
- 🍎 ARM64/Apple Silicon support
- 🔄 Auto-reset on restart for clean testing environment

## Prerequisites

- Docker
- Docker Compose

## Quick Start

1. **Clone the repository:**
   ```bash
   git clone <your-repo-url>
   cd solana-test-validator-docker
   ```

2. **Build and start the validator:**
   ```bash
   docker-compose build
   docker-compose up -d
   ```

3. **Check the logs:**
   ```bash
   docker-compose logs -f
   ```

4. **Stop the validator:**
   ```bash
   docker-compose down
   ```

## Exposed Ports

| Port | Service |
|------|---------|
| 8899 | RPC endpoint |
| 8900 | RPC PubSub |
| 9900 | Faucet |

## Using the Test Validator

### Connect to Local Validator

```bash
solana config set --url http://localhost:8899
```

### Generate a Test Wallet

```bash
solana-keygen new --outfile ~/my-test-wallet.json
```

### Request an Airdrop

```bash
# Using Solana CLI
solana airdrop 1

# Or using curl
curl -X POST http://localhost:9900/airdrop/<YOUR_PUBKEY>/1000000000
```

### Check Balance

```bash
solana balance
```

### Get Cluster Info

```bash
solana cluster-version
solana validators
```

## Configuration

The validator is configured with the following default settings:

- **RPC Port:** 8899
- **Faucet Port:** 9900
- **Faucet SOL:** 1000 SOL per request
- **Reset:** Enabled (starts fresh on each restart)
- **Bind Address:** 0.0.0.0 (accessible from host)

To modify these settings, edit the `CMD` instruction in the `Dockerfile`.

## Architecture Support

This Docker image is built from source to support multiple architectures:

- ✅ ARM64 (Apple Silicon M1/M2/M3)
- ✅ AMD64 (Intel/AMD x86_64)

The pre-built Solana binaries don't support ARM64, so this repository builds Solana CLI from the official GitHub source.

## Build Details

The Dockerfile uses a multi-stage build:

1. **Builder stage:** Compiles Solana from source with all necessary dependencies
2. **Runtime stage:** Creates a minimal image with only the compiled binaries

This approach keeps the final image size small (~200-300 MB) compared to including all build tools (~2-3 GB).

## Troubleshooting

### Container exits immediately

Check the logs:
```bash
docker-compose logs
```

### Cannot connect to validator

Ensure the container is running:
```bash
docker-compose ps
```

Wait for the healthcheck to pass:
```bash
docker inspect solana-test-validator | grep Health
```

### Build takes too long

The initial build compiles Solana from source, which can take 15-30 minutes depending on your system. Subsequent builds will use Docker's cache and be much faster.

### Out of memory during build

Increase Docker's memory allocation in Docker Desktop settings (recommended: 8GB+).

## Development

### Rebuild from scratch

```bash
docker-compose build --no-cache
```

### Access container shell

```bash
docker-compose exec solana-test-validator bash
```

### View validator logs in real-time

```bash
docker-compose logs -f solana-test-validator
```

## Project Structure

```
.
├── Dockerfile          # Multi-stage build for Solana
├── docker-compose.yml  # Container orchestration
└── README.md          # This file
```

## Resources

- [Solana Documentation](https://docs.solana.com/)
- [Solana GitHub Repository](https://github.com/solana-labs/solana)
- [Docker Multi-Stage Builds](https://docs.docker.com/build/building/multi-stage/)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Based on the [Solana Labs](https://github.com/solana-labs/solana) project
- Build instructions adapted from [Billimarie Lubiano Robinson's guide](https://billimarie.medium.com/installing-solana-cli-on-arm64-3bf889771e14)