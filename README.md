```sh
docker run -p 9002:8080 -p 11002:11311 -e MYSQL_PASS=root --restart=unless-stopped --link database:mysql liferay-forms-portal
```