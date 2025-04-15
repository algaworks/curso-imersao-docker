# Use a imagem oficial do Node.js 18 Alpine como imagem base
FROM node:18-alpine

# Define um argumento de build para o ambiente (padrão é 'dev')
ARG ENV=dev

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia os arquivos package.json e package-lock.json para o diretório de trabalho
COPY package.json package-lock.json ./

# Instala as dependências e instala globalmente o http-server e o Angular CLI
RUN npm install && npm install -g http-server @angular/cli@13.0.3

# Copia o restante dos arquivos da aplicação para o diretório de trabalho
COPY . .

# Constrói a aplicação Angular com base no ambiente especificado
RUN npm run build:$ENV

# Expõe a porta 8080 para a aplicação
EXPOSE 8080

# Define o comando padrão para executar a aplicação
CMD ["http-server", "-p", "8080", "-a", "0.0.0.0", "dist/algamoney-ui", "--proxy", "http://0.0.0.0:8080"]