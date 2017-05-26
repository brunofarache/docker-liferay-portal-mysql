```sh
docker run -p 9002:8080 -p 11002:11311 --restart=unless-stopped --link <mysql-container-name>:mysql -d brunofarache/liferay-portal
```