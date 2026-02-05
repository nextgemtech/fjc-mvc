# README

[Design Link](<https://www.figma.com/file/608pfcvNtMT8wyOHPu5EKL/Full-E-Commerce-Website-UI-UX-Design-(Community)?type=design&node-id=1-3&mode=design&t=pMaFk7PRDGqftoS2-0>)

## Development Environment

Copy ENV

```
cp .env.template .env
```

Install dependencies

> Assuming that you have already installed rails in your machine.

> Highly recommend to use any linux distros(Ubuntu, etc..) or use WSL(if you use windows)

```
bundle install
```

Run postgres docker instance

> Not running rails dev environment as a docker container due to tailwind's watcher doesn't work well.

```
docker compose up -d
```

Initiate DB

```
rails db:create
rails db:migrate
rails db:seed
```

Run locally

```
bin/dev
```

Test account

```
phone: 09012345678
pass: password
```

RSpec unit test

```
rspec
```

Annotate

```
annotate
```

Rubocop Linter

> run

```
rubocop
```

> with autocorrect

```
rubocop -A
```

Tapioca generate gems RBI

```
bin/tapioca gems
```

Sorbet type checking

```
srb tc
```

HTML to HAML

```
HAML_RAILS_DELETE_ERB=true rails haml:erb2haml
```

## Troubleshoot

Libvips

> Ubuntu - Could not open library 'vips.*'

```
sudo apt-get install -y libvips
```

> MAC - Could not open library 'glib-*>'

```
brew install vips
```
