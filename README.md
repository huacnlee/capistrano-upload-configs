Capistrano plugin - Upload Configs
----------------------------------

Capistrano plugin for Upload local config files to remote, and create soft link.

For example:

- config/app.yml
- config/database.yml
- etc/nginx/nginx.conf -> /etc/nginx/nginx.conf
- etc/nginx/ssl/foo.key -> /etc/nginx/ssl/foo.key


```rb
append :linked_files, *%w(
  config/app.yml
  config/database.yml
)

# will link with absolute path
set :absolute_linked_files, %w(
  etc/nginx/nginx.conf
  etc/nginx/ssl/foo.key
)
```

## Tasks

- cap production config:check
- cap production config:push
- cap production config:pull