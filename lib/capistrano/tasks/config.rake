def get_local_config_name(config, stage)
  path = File.dirname(config)
  extension = File.extname(config)
  filename = File.basename(config, extension)
  extension.sub!(/^\./, '')
  local_file = [filename, stage].join('.')
  local_file = [local_file, extension].join('.') unless extension.empty?
  local_path = File.join(path, local_file)
end

namespace :config do
  desc 'Check local configuration files for each stage'
  task :check do
    run_locally do
      fetch(:config_files).each do |config|
        local_path = get_local_config_name(config, fetch(:stage).to_s)
        if File.exists?(local_path)
          info "Found: #{local_path}"
        else
          warn "Not found: #{local_path}"
        end
      end
    end
  end

  desc 'Push configuration to the remote server'
  task :push do
    on release_roles :all do
      within shared_path do
        use_stage_remotely = fetch(:config_use_stage_remotely)
        fetch(:config_files).each do |config|
          local_path = get_local_config_name(config, fetch(:stage).to_s)
          server_name = use_stage_remotely ? local_path.split('/').last : config
          if File.exists?(local_path)
            info "Uploading config #{local_path} as #{server_name}"
            remote_path = File.join(shared_path, server_name)
            execute :mkdir, "-p", File.dirname(remote_path)
            upload! StringIO.new(IO.read(local_path)), remote_path
          else
            fail "#{local_path} doesn't exist"
          end
        end

        fetch(:absolute_linked_files).each do |config|
          local_path = get_local_config_name(config, fetch(:stage).to_s)
          server_name = use_stage_remotely ? local_path.split('/').last : config
          sudo :ln, "-sf #{shared_path}/#{server_name} /#{server_name}"
        end
      end
    end
  end

  desc 'Pull configuration from the remote server'
  task :pull do
    on release_roles :all do
      within shared_path do
        use_stage_remotely = fetch(:config_use_stage_remotely)
        fetch(:config_files).each do |config|
          local_path = get_local_config_name(config, fetch(:stage).to_s)
          server_name = use_stage_remotely ? local_path.split('/').last : config
          info "Downloading config #{server_name} as #{local_path} "
          download! File.join(shared_path, server_name), local_path
        end
      end
    end
  end
end

namespace :load do
  task :defaults do
    set :config_files, -> { fetch(:linked_files) + fetch(:absolute_linked_files) }
    set :config_use_stage_remotely, false
  end
end

before 'deploy:check:linked_files', 'config:push'