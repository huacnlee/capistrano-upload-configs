# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "capistrano-upload-configs"
  s.version     = '0.0.1'
  s.authors     = ["Jason Lee"]
  s.email       = ["huacnlee@gmail.com"]
  s.homepage    = "https://github.com/huacnlee/capistrano-upload-configs"
  s.summary     = %q{Capistrano plugin for Upload local config files to remote, and create soft link ...}
  s.description = %q{Capistrano plugin for Upload local config files to remote, and create soft link.}
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- {bin}/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]


  # specify any dependencies here; for example:
  s.files        = Dir.glob("{bin,lib}/**/*")
  s.files       += %w(README.md CHANGELOG.md)
  s.add_runtime_dependency "sshkit-sudo"
end
