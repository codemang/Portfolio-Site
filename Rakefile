def source_env_string
  "eval $(egrep -v '^#' .env | xargs)"
end

task :deploy do
  Rake::Task["sync_env"].execute
  `#{source_env_string} && ssh $SSH_ENDPOINT "cd $PROJECT_DIR && #{source_env_string} ./deploy.sh"`
end

task :sync_env do
  `#{source_env_string} && scp .env $SSH_ENDPOINT:$PROJECT_DIR`
end

require 'sinatra'
require 'sprockets'
require 'sprockets-helpers'
require 'sinatra/asset_pipeline/task'
require './app'

Sinatra::AssetPipeline::Task.define! App
