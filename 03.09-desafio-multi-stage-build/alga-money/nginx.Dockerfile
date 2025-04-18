# Etapa 1: Build
FROM node:18-alpine AS build

# Define um argumento de build para o ambiente (padrão é 'dev')
ARG ENV=dev

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia os arquivos package.json e package-lock.json para o diretório de trabalho
COPY package.json package-lock.json ./

# Instala as dependências e instala globalmente o Angular CLI
RUN npm install && npm install -g @angular/cli@13.0.3

# Copia o restante dos arquivos da aplicação para o diretório de trabalho
COPY . .

# Constrói a aplicação Angular com base no ambiente especificado
RUN npm run build:$ENV

# Etapa 2: Servir com Nginx
FROM nginx:1.21-alpine

# Copiar os arquivos de build do Angular para o diretório padrão do Nginx
COPY --from=build /app/dist/algamoney-ui/ /usr/share/nginx/html

# Copiar configuração customizada do Nginx
COPY ./nginx.conf /etc/nginx/nginx.conf 

# Comando padrão para iniciar o Nginx
CMD ["nginx", "-g", "daemon off;"]