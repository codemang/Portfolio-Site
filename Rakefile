def command_with_env(command)
  `eval $(egrep -v '^#' .env | xargs) #{command}`
end

task :remote_deploy do
  command_with_env('ssh $SSH_ENDPOINT "./$PROJECT_DIR/deploy.sh"')
end

task :sync_env do
  command_with_env('scp .env $SSH_ENDPOINT:$PROJECT_DIR')
end
