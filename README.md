# Thinknetica QNA Project

### Software versions:
* Ruby 3.3.7
* Rails 6.1.7 (with webpacker 5)
* PostgreSQL
* Node JS 16
* Yarn 1.22

### Start project
1. Set up local environment (Ruby, etc.)
2. Download or clone a repository
3. Run bundler and yarn to install required gems and dependencies

```bash
$ bundle install
$ yarn
```

If necessary, you can run PostgreSQL and Redis locally using [Docker](https://docker.com)

Make sure you are using [Docker Compose V2](https://docs.docker.com/compose/#compose-v2-and-the-new-docker-compose-command)

```
% docker compose version
Docker Compose version v2.3.3
```

`docker-compose.yml` configured to run PostgreSQL

```bash
$ docker compose up -d
```

4. Create and set up a database for the project

```bash
$ rails db:prepare
```

5. Start project with foreman gem (project include webpacker)

```bash
$ bin/dev
```

### The project is available at the link http://localhost:3000/
