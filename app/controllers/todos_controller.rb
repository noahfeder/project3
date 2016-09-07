class TodosController < ApplicationController

  def index
    @todos = Todo.all
  end

  def create
    #   binding.pry
    @todo =  Todo.create({:item =>params[:item],
      :user_id =>params[:user_id], :completed => !params[:completed].to_i.zero?})
    render json: @todo
    # redirect_to root_path
  end

  def destroy
    todo = Todo.find(params[:id])
    todo.destroy
  end

  # private
    # def todo_params
    #   params.require(:todo).permit(:item,:user_id,:completed)
    # end
end
