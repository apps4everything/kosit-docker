# KoSIT Validator Docker Image

[![Docker Hub](https://img.shields.io/docker/v/apps4everything/kosit-validator?sort=semver&label=Docker%20Hub)](https://hub.docker.com/r/apps4everything/kosit-validator)
[![Docker Pulls](https://img.shields.io/docker/pulls/apps4everything/kosit-validator)](https://hub.docker.com/r/apps4everything/kosit-validator)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

A ready-to-use Docker image containing the official [KoSIT Validator](https://github.com/itplr-kosit/validator) (v1.6.0) 
pre-configured with [XRechnung 3.0.2](https://xeinkauf.de/xrechnung/) validation scenarios.

## What is this?

This Docker image provides an HTTP-based validation service for German e-invoices. It validates XML invoices against:

- **XRechnung** - The German standard for electronic invoices to public authorities
- **ZUGFeRD/Factur-X** - The hybrid PDF/XML invoice format used in Germany and France
- **EN16931** - The European standard for electronic invoicing

## Quick Start

```bash
docker run -d -p 8081:8081 --name kosit-validator apps4everything/kosit-validator:1.6.0-3.0.2
```

The validator is now available at `http://localhost:8081`.

## Usage

### Pull from Docker Hub (Recommended)

```bash
# Pull the image
docker pull apps4everything/kosit-validator:1.6.0-3.0.2

# Run the container
docker run -d -p 8081:8081 --name kosit-validator apps4everything/kosit-validator:1.6.0-3.0.2
```

### Build Locally

To build the image yourself you can now simply build from the Dockerfile, no downloads needed any more.

#### 1. Clone the repository

```bash
git clone https://github.com/apps4everything/kosit-docker.git
cd kosit-docker
```

#### 2. Build and run

```bash
docker build -t kosit-validator .
docker run -d -p 8081:8081 --name kosit-validator kosit-validator
```

#### 3. Health Check

```bash
curl http://localhost:8081/server/health
```

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

## Related Links

- [KoSIT Validator GitHub](https://github.com/itplr-kosit/validator) - Official validator repository
- [XRechnung](https://xeinkauf.de/xrechnung/) - German e-invoice standard
- [KoSIT](https://www.xoev.de/kosit-4863) - Koordinierungsstelle fuer IT-Standards

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

The KoSIT Validator and XRechnung scenarios are provided by [KoSIT](https://www.xoev.de/kosit-4863) under their respective licenses.
