require 'sinatra/asset_pipeline'
require 'sinatra'


class App < Sinatra::Base

  set :assets_paths, %w(assets/javascripts assets/stylesheets)
  register Sinatra::AssetPipeline

  before do
    if request.path_info == '/'
      @active_nav_item = 'about'
    else
      @active_nav_item = request.path_info.split('/')[1]
    end
  end


  helpers do
    def is_prod?
      ENV['HOST_ENV'] == 'production'
    end

    def is_dev?
      ENV['HOST_ENV'] == 'development'
    end

    def styles_for(page)
      if page == 'layout'
        if is_prod?
          ['/stylesheets/container.css']
        else
          ['/stylesheets/container.css']
        end
      end
    end

    def load_projects
      @@projects ||= JSON.parse(File.read('projects.json'))
    end
  end


  get '/' do
    haml :index
  end

  get '/projects' do
    @projects = load_projects
    haml :projects, layout: :wide_layout
  end

  get '/projects/:id' do
    @project = load_projects.find{|proj| proj['slug'] == params['id']}
    haml :"projects/#{@project['slug']}"
  end
end
