# 📦 1. Instalação do Cosign

### 1.1. Windows via WSL (Ubuntu, Debian, etc.) e Linux

```bash
curl -Lo cosign https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-amd64
chmod +x cosign
sudo mv cosign /usr/local/bin/
cosign version
```

---

### 1.2. macOS

#### Com Homebrew:

```bash
brew install cosign
```

#### Manual:

```bash
curl -Lo cosign https://github.com/sigstore/cosign/releases/latest/download/cosign-darwin-amd64
chmod +x cosign
sudo mv cosign /usr/local/bin/
cosign version
```

---

## 🔐 2. Assinatura de Imagem com Chave (key-based signing)

### 2.1. Gerar chave:

```bash
cosign generate-key-pair
```

Resultado:
- `cosign.key` → chave privada
- `cosign.pub` → chave pública

### 2.2. Assinar a imagem (exemplo com nginx):

```bash
cosign sign --key cosign.key docker.io/library/nginx:latest
```

---

## 🔎 3. Verificação com chave

```bash
cosign verify --key cosign.pub docker.io/library/nginx:latest
```

---

## 🔓 4. Assinatura sem chave (Keyless Signing)

### 4.1. Assinar imagem com OIDC (GitHub, Google, etc.):

```bash
cosign sign --keyless docker.io/library/nginx:latest
```

- Um navegador será aberto para autenticação.

---

## 🔍 5. Verificação sem chave

```bash
cosign verify --keyless docker.io/library/nginx:latest
```

---

## 📝 Observações

- Todas as assinaturas são armazenadas no **OCI registry**, como `nginx:sha256-xxxx.sig`.
- Cosign também suporta **SBOMs, políticas, atestados, artefatos genéricos**, etc.
- Imagens privadas requerem login prévio com `docker login`.
