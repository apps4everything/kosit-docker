FROM eclipse-temurin:21-jre-alpine AS runtime

ARG VALIDATOR_VERSION=1.6.0
ARG XRECHNUNG_VERSION=3.0.2
ARG XRECHNUNG_CONFIG_DATE=2025-07-10

LABEL maintainer="apps4everything"
LABEL description="XRechnung ${XRECHNUNG_VERSION} Validator with full EN 16931 + XRechnung (BR-DE) validation"
LABEL validator.version="${VALIDATOR_VERSION}"
LABEL xrechnung.version="${XRECHNUNG_VERSION}"
LABEL xrechnung.config.date="${XRECHNUNG_CONFIG_DATE}"

RUN apk add --no-cache wget unzip

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

RUN cd /app

RUN wget -q "https://github.com/itplr-kosit/validator/releases/download/v${VALIDATOR_VERSION}/validator-${VALIDATOR_VERSION}.zip" \
    -O validator.zip \
    && unzip -q validator.zip \
	&& mv validator-${VALIDATOR_VERSION}-standalone.jar validator.jar \
    && rm validator.zip

RUN wget -q "https://github.com/itplr-kosit/validator-configuration-xrechnung/releases/download/release-${XRECHNUNG_CONFIG_DATE}/validator-configuration-xrechnung_${XRECHNUNG_VERSION}_${XRECHNUNG_CONFIG_DATE}.zip" \
    -O xrechnung-config.zip \
    && unzip -q xrechnung-config.zip \
    && rm xrechnung-config.zip

RUN apk del unzip

RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 8081

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD wget -qO- http://localhost:8081/server/health || exit 1

CMD ["java", "-Xms256m", "-Xmx512m", "-jar", "validator.jar", \
     "-s", "scenarios.xml", \
     "-D", \
     "-H", "0.0.0.0", \
     "-P", "8081", \
     "--disable-gui"]
