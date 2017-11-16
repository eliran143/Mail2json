# Mail2json
Docker stack to convert mail to json and save it in mongo.

Based on MailToJson project by https://www.newsmanapp.com/

Build:
```
Use docker-compose to first build postfix image.
You can build the image using regular docker build and point docker-compose.yml to use the image.
```
Run:
```
docker-compose up -d
```
ENV vars for postfix:
```
$HOSTNAME - Postfix myhostname
$RELAYHOST - Host that relays your msgs
$MYNETWORKS - Allow domains from per Network ( default 127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16 )
$ALLOWED_SENDER_DOMAINS - Domains sender domains
$VIRTUAL - Domains that will be used to wildcard mailbox
$MONGO_HOST - Mongo host:port, default is mongo:27017
$MONGO_EXPIRE - TTL for the document, default is 24H
```
# License

This code is released under [MIT license](https://github.com/eliran143/Mail2json/blob/master/LICENSE) by Eliran Shlomo.
