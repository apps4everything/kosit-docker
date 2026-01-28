# KoSIT Validator Docker Image

[![Docker Hub](https://img.shields.io/docker/v/apps4everything/kosit-validator?sort=semver&label=Docker%20Hub)](https://hub.docker.com/r/apps4everything/kosit-validator)
[![Docker Pulls](https://img.shields.io/docker/pulls/apps4everything/kosit-validator)](https://hub.docker.com/r/apps4everything/kosit-validator)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

A ready-to-use Docker image containing the official [KoSIT Validator](https://github.com/itplr-kosit/validator) (v1.6.0) pre-configured with [XRechnung 3.0.2](https://xeinkauf.de/xrechnung/) validation scenarios.

## What is this?

This Docker image provides an HTTP-based validation service for German e-invoices. It validates XML invoices against:

- **XRechnung** - The German standard for electronic invoices to public authorities
- **ZUGFeRD/Factur-X** - The hybrid PDF/XML invoice format used in Germany and France
- **EN16931** - The European standard for electronic invoicing

## Quick Start

```bash
docker run -d -p 8081:8081 --name kosit-validator apps4everything/kosit-validator:1.6.0
```

The validator is now available at `http://localhost:8081`.

## Usage

### Pull from Docker Hub (Recommended)

```bash
# Pull the image
docker pull apps4everything/kosit-validator:1.6.0

# Run the container
docker run -d -p 8081:8081 --name kosit-validator apps4everything/kosit-validator:1.6.0
```

### Build Locally

To build the image yourself, you need to download the KoSIT Validator and XRechnung scenario files first.

#### 1. Clone the repository

```bash
git clone https://github.com/apps4everything/kosit-docker.git
cd kosit-docker
```

#### 2. Download KoSIT Validator

```bash
wget https://github.com/itplr-kosit/validator/releases/download/v1.6.0/validator-1.6.0-distribution.zip
unzip validator-1.6.0-distribution.zip
cp validator-1.6.0/libs/validator-1.6.0-standalone.jar .
```

#### 3. Download XRechnung Scenarios

```bash
wget https://github.com/itplr-kosit/validator-configuration-xrechnung/releases/download/release-2025-07-10/validator-configuration-xrechnung_3.0.2_2025-07-10.zip
unzip validator-configuration-xrechnung_3.0.2_2025-07-10.zip
```

#### 4. Build and run

```bash
docker build -t kosit-validator:1.6.0 .
docker run -d -p 8081:8081 --name kosit-validator kosit-validator:1.6.0
```

## API Endpoints

### Health Check

```bash
curl http://localhost:8081/server/health
```

Returns the health status of the validator service.

### Validate Invoice

```bash
curl -X POST http://localhost:8081/ \
  -H "Content-Type: application/xml" \
  -d @invoice.xml
```

The response contains the validation report in XML format, including:
- Validation status (valid/invalid)
- List of errors and warnings
- Applied validation rules

### Example with File

```bash
# Validate a local XRechnung file
curl -X POST http://localhost:8081/ \
  -H "Content-Type: application/xml" \
  --data-binary @path/to/your/invoice.xml
```

## Configuration

| Setting | Value |
|---------|-------|
| HTTP Port | `8081` |
| Health Endpoint | `/server/health` |
| Validation Endpoint | `POST /` |
| Base Image | `eclipse-temurin:21-jre-alpine` |
| KoSIT Validator | `1.6.0` |
| XRechnung Scenarios | `3.0.2` |

## Docker Compose

```yaml
services:
  kosit-validator:
    image: apps4everything/kosit-validator:1.6.0
    ports:
      - "8081:8081"
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "wget", "-qO-", "http://localhost:8081/server/health"]
      interval: 30s
      timeout: 5s
      start_period: 10s
```

## Security

This image follows security best practices:

- Runs as non-root user (`appuser`)
- Based on Alpine Linux (minimal attack surface)
- No unnecessary packages installed
- Built-in health checks

## Included Components

| Component | Version | Description |
|-----------|---------|-------------|
| KoSIT Validator | 1.6.0 | Core validation engine |
| XRechnung Scenarios | 3.0.2 | German e-invoice validation rules |
| EN16931 CII Validation | included | Cross Industry Invoice support |
| EN16931 UBL Validation | included | Universal Business Language support |
| Eclipse Temurin JRE | 21 | Java runtime environment |

## Related Links

- [KoSIT Validator GitHub](https://github.com/itplr-kosit/validator) - Official validator repository
- [XRechnung](https://xeinkauf.de/xrechnung/) - German e-invoice standard
- [KoSIT](https://www.xoev.de/kosit-4863) - Koordinierungsstelle fuer IT-Standards

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

The KoSIT Validator and XRechnung scenarios are provided by [KoSIT](https://www.xoev.de/kosit-4863) under their respective licenses.
