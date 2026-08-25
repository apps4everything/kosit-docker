# KoSIT Validator Docker Images

Ready-to-use Docker images for validating European e-invoices using the official [KoSIT Validator](https://github.com/itplr-kosit/validator).

## Available Images

| Image | Use Case | Standards | Docker Hub |
|-------|----------|-----------|------------|
| **[XRechnung](#xrechnung)** | German B2B & B2G invoices | XRechnung 3.0.2, ZUGFeRD, EN16931 | [![Docker Pulls](https://img.shields.io/docker/pulls/apps4everything/kosit-validator-xrechnung?style=flat-square&logo=docker)](https://hub.docker.com/r/apps4everything/kosit-validator-xrechnung) |
| **[Peppol BIS](#peppol-bis-billing)** | International Peppol invoices | Peppol BIS 3.0.20, EN16931 | [![Docker Pulls](https://img.shields.io/docker/pulls/apps4everything/kosit-validator-peppol?style=flat-square&logo=docker)](https://hub.docker.com/r/apps4everything/kosit-validator-peppol) |

## Which Image Do I Need?
```
Receiving invoice from German public authority or sending to one?
  └─► XRechnung

Receiving invoice via Peppol network from international supplier?
  └─► Peppol BIS

German B2B invoice (ZUGFeRD, Factur-X)?
  └─► XRechnung

Not sure?
  └─► XRechnung (covers most German use cases)
```

---

## XRechnung

[![Docker Image Version](https://img.shields.io/docker/v/apps4everything/kosit-validator-xrechnung?sort=semver&style=flat-square&logo=docker&label=version)](https://hub.docker.com/r/apps4everything/kosit-validator-xrechnung)
[![Docker Image Size](https://img.shields.io/docker/image-size/apps4everything/kosit-validator-xrechnung?style=flat-square&logo=docker&label=size)](https://hub.docker.com/r/apps4everything/kosit-validator-xrechnung)

Validates German e-invoices: **XRechnung 3.0.2**, **ZUGFeRD/Factur-X**, and **EN16931** (UBL & CII).
```bash
docker run -d -p 8081:8081 --name kosit-validator \
  apps4everything/kosit-validator-xrechnung:3.0.2-1
```

---

## Peppol BIS Billing

[![Docker Image Version](https://img.shields.io/docker/v/apps4everything/kosit-validator-peppol?sort=semver&style=flat-square&logo=docker&label=version)](https://hub.docker.com/r/apps4everything/kosit-validator-peppol)
[![Docker Image Size](https://img.shields.io/docker/image-size/apps4everything/kosit-validator-peppol?style=flat-square&logo=docker&label=size)](https://hub.docker.com/r/apps4everything/kosit-validator-peppol)

Validates international Peppol invoices: **Peppol BIS Billing 3.0.20** and **EN16931** (UBL & CII).
```bash
docker run -d -p 8081:8081 --name kosit-validator-peppol \
  apps4everything/kosit-validator-peppol:3.0.21
```

---

## Usage

Both images expose the same HTTP API on port `8081`.

### Validate an Invoice
```bash
curl -X POST http://localhost:8081/ \
  -H "Content-Type: application/xml" \
  -d @invoice.xml
```

### Health Check
```bash
curl http://localhost:8081/server/health
```

### Response

The validator returns an XML report containing:
- Validation status (valid/invalid)
- List of errors and warnings
- Applied validation rules

---

## Building Locally
```bash
# Clone the repository
git clone https://github.com/apps4everything/kosit-docker.git
cd kosit-docker

# Build XRechnung image
cd xrechnung
docker build -t kosit-validator .

# Build Peppol image
cd ../peppol
docker build -t kosit-validator-peppol .
```

---

## Version Matrix

| Image                           | KoSIT Validator | Configuration                |
|---------------------------------|-----------------|------------------------------|
| `kosit-validator-xrechnung:3.0.2-1` | 1.6.3           | XRechnung 3.0.2 (2025-07-10) |
| `kosit-validator-peppol:3.0.21` | 1.6.3           | Peppol BIS Billing 3.0.21    |

---

## Related Projects

- 🌐 [xvalidator.de](https://xvalidator.de) – Free online validator using these images
- 📄 [xml-rechnung.eu](https://xml-rechnung.eu) – Generate, validate and archive electronic invoices 

---

## Links

- [KoSIT Validator](https://github.com/itplr-kosit/validator) – Official validator engine
- [XRechnung Standard](https://xeinkauf.de/xrechnung/) – German e-invoice standard
- [Peppol BIS Billing 3.0](https://docs.peppol.eu/poacc/billing/3.0/) – Peppol specification
- [EN16931](https://ec.europa.eu/digital-building-blocks/sites/display/DIGITAL/EN16931) – European e-invoice standard
- [github.com/horstoeko/zugferd](https://github.com/horstoeko/zugferd) - PHP libary for processing ZUGFeRD invoices (PDF/A-3)
---

## License

Apache License 2.0 – see [LICENSE](LICENSE) for details.

The KoSIT Validator is provided by [KoSIT](https://www.xoev.de/) under their respective licenses.

---

<p align="center">
  <sub>Made with ❤️ in Märkisch-Oderland by <a href="https://apps4everything.de">apps4everything</a></sub>

</p>








