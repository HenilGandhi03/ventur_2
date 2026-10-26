# --- Build a small, production-ready image --------------------------------
FROM node:22-alpine AS base
WORKDIR /app
ENV NODE_ENV=production

# Install only production dependencies first for better layer caching.
COPY package.json package-lock.json* ./
RUN npm ci --omit=dev || npm install --omit=dev

# App source.
COPY . .

# Regenerate the seed at build time so the image always ships current data.
RUN node scripts/build-seed.js

EXPOSE 3000
# Run as the built-in non-root user.
USER node

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD node -e "fetch('http://127.0.0.1:'+(process.env.PORT||3000)+'/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"

CMD ["node", "src/index.js"]
