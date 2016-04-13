require "sinatra"
require 'sinatra/cookies'
require "unicorn"
require 'socket'
require 'haml'
require 'docker'

class App < Sinatra::Base

  configure do
    set :hostname, Socket.gethostname

    set :sessions, true
    set :public, File.dirname(__FILE__) + '/public'
  end

  get "/hostname" do
    settings.hostname
  end

  get '/' do
    @hostname = settings.hostname
    @containers = get_containers_list
    haml :index
  end

  get '/uploader' do
    haml :uploader
  end
  
  post '/upload' do
    result = ""
    if params[:file]
      hostname = Socket.gethostname
      save_path = "./public/images/#{hostname}_#{params[:file][:filename]}"
      File.open(save_path, 'wb') do |f|
  	p params[:file][:tempfile]
  	f.write params[:file][:tempfile].read
  	  result = "成功"
  	end
    else
      result = "失敗"
    end
    redirect to("/result?host=#{settings.hostname}&filename=#{hostname}_#{params[:file][:filename]}&res=#{result}")
  end

  get '/result' do
    @hostname = params['host']
    @image = params['filename']
    @result = params['res']
    haml :result
  end

  get '/images' do
    images_name = Dir.glob("public/images/*")
    @images_path = []
    images_name.each do |image|
      @images_path << image.gsub("public/", "./")
    end
    haml :images
  end
 
  private

  def get_containers_list
    containers_array = []
    Docker.url="unix:///tmp/docker.sock"
    containers = Docker::Container.all(:running => true)
    containers.each do |container|
      network_mode = container.info['HostConfig']['NetworkMode']
      container_info = {}
      container_info.store("name", container.info['Names'][0].slice(1..-1))
      container_info.store("id", container.id[0,12])
      container_info.store("ip", container.info['NetworkSettings']['Networks'][network_mode]['IPAddress'])
      containers_array << container_info
    end
    return containers_array
  end

end
