docker run -d --name game-db -p 5432:5432 -v D:\game-db-data:/var/lib/postgresql/data -e POSTGRES_USER=iot -e POSTGRES_PASSWORD=006931 -e POSTGRES_DB=game_db postgres:latest

USER:iot
PW:006931
VOLUMN:D:\game-db-data
PORT:5432