class TodosController < ApplicationController

  def index
    @todos = Todo.all
  end

  def create
    binding.pry
    Todo.create(todo_params)
    render json: @todos
    # redirect_to root_path
  end

  def destroy
    todo = Todo.find(params[:id])
    todo.destroy
    redirect_to root_path
  end

  private
    def todo_params
      params.require(:todo).permit(:item,:user_id)
    end
end
