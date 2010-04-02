require 'sinatra'
require 'dm-core'
require 'haml'
require 'sass'

require 'client'
require 'project'

module Dashboard
  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/dashboard.db")
  
  configure :development do
    DataMapper.auto_upgrade!
  end
  
  class Server < Sinatra::Base
    set :haml, { :format => :html5 }
    
    before do
      headers 'Content-Type' => 'text/html; charset=utf-8'
    end
    
    helpers do
      def path_root
        ENV["RACK_BASE_URI"]
      end
    end
    
    get '/?' do
      @projects = Project.all
      haml :index
    end
    
    post '/build/?' do
      project = Project.create_or_update(params)
      Dashboard::Client.send_message(request.host, project.to_json)
    end
    
    get '/main.css' do
      content_type 'text/css', :charset => 'utf-8'
      sass :main
    end
  end
end
