# About the directory structure

The wordpress directory contains a rudimentary development environment which is great as a quick template to get your development environment up and running. The wordpress-ssl directory in the other hand is more robust environment which has SSL-connection already set up. This directory is also going to be the one that is going to get more updates.

*If something isn't working as intended please double check what has changed between the tested versions and the latests.*

**Latest tested versions**
- MariaDB
- Wordpress
- Nginx

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

## Part 5, Issues & Improvements

Throughout the usage of this docker environment I have come across issues that prevent the development experience from being smooth. On this chapter my aim is to present the issues and improvements.

### Issues

**1) Exposed directories don't offer enough flexibility**

In certain projects I have had an issue where I needed deeper access in Wordpress directory tree than what the environment offered (only plugins and themes directories were exposed). Sure it's nice to have simple file structure, but when there's issues developers usually need to access deeper than just plugins and themes directories.

**2) Multiple yml-files are fired on Docker startup**

For whatever reason when Docker is opened it starts previously used containers on before Docker was closed. This issue can be handled by manually closing the containers that aren't in use, but there is the issue that developer **needs** to remember to shut these containers. I don't know about you but I don't always remember to close the container which is why after a weekend it takes about 10 minutes to finally realize why the port is hosting wrong Wordpress environment. And that brings us to the next issue.

**3) Container doesn't care if default port is busy**

This issue could be included in previous one, but because of it's effects I'm going to write it down as completely separate issue. Anyway when there's forgotten container running in the background it's probably running on default port and because there's no secondary port to fallback on that the container could use. The container is going to prompt an error that tells the port is busy or something similar. This could be probably fixed so developer wouldn't need to stop the running container, before they could (for example) move to another project for a while.

**4) The localhost domain is too simple**

When an instance of the Wordpress environment is running it's showed as just **localhost**. It would be helpful if the url would atleast show which port the instance is running on.

### Improvements

**1) Exposed directories don't offer enough flexibility**

**2) Multiple yml-files are fired on Docker startup**

**3) Container doesn't care if default port is busy**

**4) The localhost domain is too simple**


Note for self for SSL follow this tutorial: https://dev.to/vishalraj82/using-https-in-docker-for-local-development-nc7