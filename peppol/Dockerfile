# Peppol BIS Billing 3.0 Validator

FROM eclipse-temurin:21-jre-alpine AS runtime

# Build arguments
ARG VALIDATOR_VERSION=1.6.0
ARG PEPPOL_VERSION=3.0.20

# Labels
LABEL maintainer="apps4everything"
LABEL description="Peppol BIS Billing ${PEPPOL_VERSION} Validator"
LABEL validator.version="${VALIDATOR_VERSION}"
LABEL peppol.version="${PEPPOL_VERSION}"

# Install dependencies
RUN apk add --no-cache wget unzip

# Create non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set working directory
WORKDIR /app

RUN wget -q "https://github.com/itplr-kosit/validator/releases/download/v${VALIDATOR_VERSION}/validator-${VALIDATOR_VERSION}.zip" \
    -O validator.zip \
    && unzip -q validator.zip \
	&& mv validator-${VALIDATOR_VERSION}-standalone.jar validator.jar \
    && rm validator-${VALIDATOR_VERSION}.jar \
	&& rm -r libs \
    && rm validator.zip

# https://github.com/itplr-kosit/validator-configuration-bis/releases/download/release-3.0.20/validation-configuration-bis-3.0.20.zip
RUN wget -q "https://github.com/itplr-kosit/validator-configuration-bis/releases/download/release-${PEPPOL_VERSION}/validation-configuration-bis-${PEPPOL_VERSION}.zip" \
    -O peppol-config.zip \
    && unzip -q peppol-config.zip \
    && rm peppol-config.zip

# Cleanup
RUN apk del unzip

# Set permissions
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose HTTP port
EXPOSE 8081

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget -qO- http://localhost:8081/server/health || exit 1

# Run validator as HTTP daemon
CMD ["java", "-Xms256m", "-Xmx512m", "-jar", "validator.jar", \
     "-s", "scenarios.xml", \
     "-D", \
     "-H", "0.0.0.0", \
     "-P", "8081", \
     "--disable-gui"]
