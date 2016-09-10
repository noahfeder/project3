class TodosController < ApplicationController
  include UsersHelper
  before_action :get_user, only: [:index]
### This is now an API! yay!
  def index
    @todos = Todo.where(user_id: session[:user_id])
    render json: @todos
  end
  # create new todo for the specific user
  def create
    @todo =  Todo.create({
      :item =>params[:item],
      :user_id =>params[:user_id],
      :completed => !params[:completed].to_i.zero?
    })
    render json: @todo
  end
  # delete a todo
  def destroy
    @todo = Todo.find_by_id(params[:id])
    @todo.destroy
    render json: @todo
  end
  # patch and update for a todo
  #TODO add ability to update actual item:string
  def update
    @todo = Todo.find_by_id(params[:id])
    @todo.update(completed: params[:completed])
    render json: @todo
  end

end
