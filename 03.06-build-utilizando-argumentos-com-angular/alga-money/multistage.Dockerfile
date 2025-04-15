# Etapa 1: Build
FROM node:18-alpine AS build
ARG ENV=dev
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install && npm install -g @angular/cli@13.0.3
COPY . .
RUN npm run build:$ENV

# Etapa 2: Servir com Nginx
FROM nginx:1.21-alpine
COPY --from=build /app/dist/algamoney-ui /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]