class UsersController < ApplicationController

  def index
  end

  def new
    redirect_to "/"
  end


  def edit
    redirect_to "/"
  end

  def destroy
    redirect_to "/new"
  end


end
