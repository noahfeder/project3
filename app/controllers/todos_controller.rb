class TodosController < ApplicationController

  def index
    @todos = Todo.all
  end

  def create
    Todo.create(todo_params)
    redirect_to root_path #TODO SEND BACK JSON INSTEAD
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
