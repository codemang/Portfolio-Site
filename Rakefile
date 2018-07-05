def source_env_string
  "eval $(egrep -v '^#' .env | xargs)"
end

task :remote_deploy do
  `ssh $SSH_ENDPOINT '#{source_env_string} $PROJECT_DIR/deploy.sh'`
end

task :sync_env do
  `#{source_env_string} && scp .env $SSH_ENDPOINT:$PROJECT_DIR`
end
