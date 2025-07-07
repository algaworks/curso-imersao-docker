# Como Ativar a Docker Remote API no Linux

## Passos para Configurar Docker Remote API

### Usando systemd 

#### Criar arquivo de configuração
```bash
sudo systemctl status docker  
sudo systemctl edit docker.service 
```

#### Configuração(Apenas para Desenvolvimento Local)
```ini
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375
```

digite CTRL + X para sair, depois Y para salvar. nome do arquivo será `docker.service.d/docker.conf`.

#### Recarregar configurações e reiniciar Docker
```bash
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl status docker  
```

#### Verificar se está funcionando
```bash
sudo systemctl status docker
```

#### Rode o comando 
```bash
 curl http://localhost:2375/info
```
