# About the directory structure

The wordpress directory contains a rudimentary development environment which is great as a quick template to get your development environment up and running. The wordpress-ssl directory in the other hand is more robust environment which has SSL-connection already set up. This directory is also going to be the one that is going to get more updates.

If something isn't working as intended please double check what has changed between the tested versions and the latest.

**Latest tested versions**

*Provided string is the digest id*
- MariaDB `ff1367c7152e`
- Wordpress `63a40d433d89`
- Nginx `4c1c50d0ffc6`

# About the current version

**WordPress environment without ssl protocol haven't been changed and should work as previously.**

**WordPress environment with ssl protocol is completely functional, but it's not perfect.**

User needs to generate their own certificate files (`.crt` and `.key`), check the `./wordpress-ssl/nginx-config/certs` directory for further instructions. And user also needs to include their custom domain in `hosts` file.

**What is a `hosts` file?**

*The hosts file is a plain text file used by operating systems to map hostnames to IP addresses. It acts as a local DNS (Domain Name System) lookup table, allowing you to manually define specific mappings between domain names and IP addresses.*

You can find the file by following certain paths:
- **Windows**: `C:\Windows\System32\drivers\etc\hosts`
- **Mac**: `/private/etc/hosts`
- **Linux**: `/etc/hosts`

In order to use custom domains, include following line in the `hosts` file.

```
# Port      Domain
127.0.0.1   wordpress.example.test
```

Things to improve on:
- Sometimes ssl protocol is not used
- It would be handy to have scripts to prevent manual changes
  - Generate keys script
  - Add custom domain to `hosts` file script
  - Start docker instance script

# Creating modern WordPress development environment

The purpose of this README file is to explain how this environment works and how it was made. The file has been written in a way that any user should be able to create the same environment using given resources.

If you don't want to read the whole README file here's the TL;DR:
  - Install Docker
  - Clone this repository
  - Open terminal inside of wordpress directory
  - Use command `docker compose up -d` to run the environment
  - Use command `docker compose down` to stop the environment

Useful commands:
  - Check the status of services `docker-compose ps`
  - Check the logs of a service `docker-compose logs [service_name]`
  - Check certificate `docker-compose exec webserver ls -la /etc/letsencrypt/live`

## Part 1, Getting docker to run WordPress

Official docker documentations are great place to start so this part is going to include my notes and problems I faced when following official docker intructions.

By following the official instructions the developer can achieve a working environment in no time (or if we want to be precise in 4-10 mins). There were not any major issues other than mistyping word **services** so double check your `docker-compose.yml`-file if you get `(root) Additional property ervices is not allowed` or something similar as a response when using `docker compose up -d`-command.

**Resources:**
  - https://docs.docker.com/samples/wordpress/

## Part 2, Developing with Docker

WordPress should function just fine and should run on `localhost:80` without a problem. 

*You can test creating posts, pages and see if the database keeps your changes after stopping the container with `docker composer down`. If you would prefer that the database wipes itself after stopping the container there is a attribute for that.*

At the moment the development environment doesn't support local development. For some reason some guides skip this step which is kind of funny when considering that the environment is for developing (some use this method to push their WordPress setup to their host site so I can understand why some guides don't go over this step). Yoast is reliable entity in the WordPress environment and they have also some articles/guides/tutorials about setting up docker development environment.

**"Setting up a WordPress development environment in Docker"** article doesn't go over everything, but it includes how to manipulate files in docker. At this point we're interested in **"Adding a WordPress installation"** and **"Using the dev environment for plugin development"** parts. First let's add new volumes for WordPress which are for `wp-content/plugins` and `wp-content/themes`.

Restarting the environment should create *plugins* and *themes* folders which can be used to develop corresponding parts. Try adding a plugin through *plugins* folder and a theme through *themes* folder. The container should be able to read the changes on the fly so the changes should appear on WordPress without restarting the container.

*Note that on ideal development environment you should start developing with the latest versions of given technologies or depending on situation you should mimic the final production environment as much as possible. So defaulting to latest WordPress image isn't always the best way of using this kind of development environment.*

**Resources:**
  - https://developer.yoast.com/blog/set-up-wordpress-development-environment-in-docker/

## Part 3, Addressing potential errors

Depending on what is being developed the insecurity of `http` can end up being a problem. So the current environment should be changed to support secured SSL-connection.

There are some errors/warnings when docker is starting the container such as 
```
apache2: Could not reliably determine the server's fully qualified domain name, using 172.18.0.3. Set the 'ServerName' directive globally to suppress this message
``` 
and 
```
No 'wp-config.php' found in /var/www/html, but 'WORDPRESS_...' variables supplied; copying 'wp-config-docker.php'
```
Even if the environment work without a problem for now, it's a good practice to fix warnings when possible.

The current environment doesn't let the developer to change the specific php version (or any other image version which could in theory trigger an error when developing older themes or plugins) so I would advice to read more about WordPress images by visiting [the docker hub page](https://hub.docker.com/_/wordpress/). The site also includes some examples of issues and how to solve them.

**Resources:**
  - https://hub.docker.com/_/wordpress/

## Part 4, SSL-connection

Digital Ocean is popular host service provider who also make good tutorials on different things. Their tutorial about *"How to install WordPress with docker compose"* is extensive tutorial that explains docker setup in a good detail.

The article uses **nginx** web server to resolve the insecure connection problem. Before we can resolve the problem we need to setup **nginx** which requires new folder in the directory named `nginx-conf` which contains the `nginxs.conf` file. The article includes the contents of the config file, for our purpose this is great base which can be modified in the future if needed. After that the docker compose needs a new service `webserver` and again the article includes the details.

*Note that the services need to be on the same network and the wordpress service shouldn't include the port after this point.*

And finally we can include the final service which will handle the certification of the domain which makes the development environment SSL-certified. The final service is called `certbot` which will time to time refresh the SSL status of the site which makes sure the wordpress site is able to use protected connection.

And now the environment needs the network definition.

*For more detail read the whole article from Digital Ocean's website.*

**Resources:**
 - https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-docker-compose
