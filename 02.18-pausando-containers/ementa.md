## Container iniciado
docker run -it --name app-java algaworks/algatransito-api ash


## Comando utilizado
while true; do
   date +"%H:%M:%S" >> horas.txt
   sleep 1
done &
