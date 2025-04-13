FROM node:18-alpine
ARG ENV=dev
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install && npm install -g http-server @angular/cli@13.0.3
COPY . .
RUN npm run build:$ENV
EXPOSE 8080
CMD ["http-server", "-p", "8080", "-a", "0.0.0.0", "dist/algamoney-ui", "--proxy", "http://0.0.0.0:8080"]