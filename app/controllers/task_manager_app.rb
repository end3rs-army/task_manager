require 'sass'
require 'models/task_manager'

# get('/styles.css'){ scss :styles }

class TaskManagerApp < Sinatra::Base
  set :root, File.join(File.dirname(__FILE__), '..')
  set :method_override, true

  get '/' do
    erb :dashboard  
  end

  get '/tasks' do 
    @tasks = TaskManager.all
    erb :index
  end 

  get '/tasks/new' do
    erb :new
  end

  post '/tasks' do
    TaskManager.create(params[:task])
    redirect '/tasks'
  end

  delete '/tasks/:id' do 
    TaskManager.delete(params[:id])
    redirect '/tasks'
  end

  get '/tasks/:id' do
    @task = TaskManager.find(params[:id])
    erb :show
  end

  get '/tasks/:id/update' do
    @task = TaskManager.find(params[:id])
    erb :update
  end

  post '/tasks/:id/update' do
    TaskManager.update(params[:id], params[:task])
    redirect '/tasks'
  end

end
