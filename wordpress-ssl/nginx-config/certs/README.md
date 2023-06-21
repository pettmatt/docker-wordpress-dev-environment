# How to generate certifications for local environment manually

***Usually people use certbot to handle certificates for their environments, but it can also be done manually. If you want to handle certificates yourself make sure to remove certbot from docker-compose file.***

There are more than one way to generate certificates, but I recommend using [mkcert](https://github.com/FiloSottile/mkcert) which supports Linux, MacOS and Windows.

*At the time of writing mkcert doesn't support Firefox on Windows.*

Mkcert repository contains great instructions of how to use the tool and install it, so go read it, install and generate your own certificate and come back for instructions how to include your certificates in `nginx.conf` file.

At this point you should have two `.pem`-files in this directory. Example:

- `wordpress.example.test+3-key.pem`
- `wordpress.example.test+3.pem`

**Setting up nginx.conf-file**

Open `nginx.conf`-file. In this file you can change quite a few things, but if you want to learn more I recommend checking [Nginx full configuration example](https://www.nginx.com/resources/wiki/start/topics/examples/full/) and [Nginx beginner's guide](https://nginx.org/en/docs/beginners_guide.html). Anyway, relevant attributes you might want to change are; port, server name and SSL certificates.

Below you can see an example how earlier generated certificates should be added. Just change the name of the certificate and keep everything after `+` sign:

- `ssl_certificate /etc/nginx/cert/[cert-name]+3.pem`
- `ssl_certificate_key /etc/nginx/cert/[cert-name]+3-key.pem.key;`

It's worth noting that Nginx is unable to create and read the certificates if multiple containers are starting at the same time. You can find more information about this bug from this [Stack Exchange post](https://serverfault.com/questions/937274/nginx-doesnt-find-ssl-certificate-in-docker-even-though-its-there).

**Update to the issue introduced above. Currently I'm unable to reproduce the problem, but it may appear when using this docker setup for longer period of time.**

## Recommended tutorial to generate `.crt` and `.key` files

If the above guide didn't work please take a look at Dave Kerr's guide for generating SSL-keys with `mkcert` and enabling SSL-support with Nginx. [Link to the guide](https://hackerrdave.com/https-local-docker-nginx/).