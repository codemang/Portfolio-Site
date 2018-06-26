class App < Sinatra::Base
  before do
    if request.path_info == '/'
      @active_nav_item = 'about'
    else
      @active_nav_item = request.path_info.split('/')[1]
    end
  end

  get '/' do
    haml :index
  end

  get '/projects' do
    @projects = JSON.parse(File.read('projects.json'))
    haml :projects
  end
end
