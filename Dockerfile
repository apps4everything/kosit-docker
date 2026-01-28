# Multi-stage build for KoSIT Validator 1.6.0 with XRechnung 3.0.2
FROM eclipse-temurin:21-jre-alpine AS runtime

# Install wget for healthcheck
RUN apk add --no-cache wget

# Create non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set working directory
WORKDIR /app

# Copy KoSIT Validator 1.6.0
COPY validator-1.6.0-standalone.jar /app/validator.jar

# Copy XRechnung 3.0.2 scenario configuration
COPY scenarios.xml /app/
COPY EN16931-CII-validation.xslt /app/
COPY EN16931-UBL-validation.xslt /app/
COPY resources /app/resources

# Set permissions
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose HTTP port
EXPOSE 8081

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s \
    CMD wget -qO- http://localhost:8081/server/health || exit 1

# Run validator as HTTP daemon
CMD ["java", "-jar", "validator.jar", \
     "-s", "scenarios.xml", \
     "-r", "/app", \
     "-D", \
     "-H", "0.0.0.0", \
     "-P", "8081", \
     "--disable-gui"]
