class TodosController < ApplicationController

  def index
    @todos = Todo.all
  end

  def create
    @todo =  Todo.create({:item =>params[:item],
      :user_id =>params[:user_id], :completed => !params[:completed].to_i.zero?})
    render json: @todo
  end

  def destroy
    @todo = Todo.find_by_id(params[:id])
    @todo.destroy
    render json: @todo
  end

  def update
    @todo = Todo.find_by_id(params[:id])
    @todo.update(completed: params[:completed])
    render json: @todo
  end

  # private
    # def todo_params
    #   params.require(:todo).permit(:item,:user_id,:completed)
    # end
end
