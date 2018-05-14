docker build -t pautome/miapache .
docker run -d -p 8080:80 -v /home/pau/volums/apachehtml:/var/www/html pautome/miapache
