# Build stage
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:1.25  # Use full image or keep alpine if size is a concern
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf  # Optional
HEALTHCHECK CMD wget --no-verbose --tries=1 --spider http://localhost || exit 1
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
