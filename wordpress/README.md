# Creating modern WordPress development environment

## Part 1, Getting docker running WordPress

Official docker docs is great place to start so this part is going to include my notes and problems I faced when following official docker intructions.

By following the official instructions the developer can achieve a working environment in no time (or if we want to be precise in 4-10 mins). There were not any major issues other than mistyping word *services* so double check your `docker-compose.yml`-file if you get `(root) Additional property ervices is not allowed` or something similar as a response when using `docker compose up -d`-command.

Resources:
https://docs.docker.com/samples/wordpress/