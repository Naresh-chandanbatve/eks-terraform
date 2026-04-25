# ---------- 1. Build Stage ----------
FROM node:20-alpine AS builder

WORKDIR /app

# Install dependencies first (better caching)
COPY package.json package-lock.json ./
RUN npm ci

# Copy app source
COPY . .

# Build Next.js app
RUN npm run build


# ---------- 2. Runtime Stage ----------
FROM node:20-alpine

WORKDIR /app

# Copy only necessary build output
COPY --from=builder /app ./

# Disable telemetry
ENV NEXT_TELEMETRY_DISABLED=1

# Expose Next.js port
EXPOSE 3000

# Start production server
CMD ["npm", "start"]