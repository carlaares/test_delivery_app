class HomeController < ApplicationController
  # before_filter :authenticate_user!, except: [ :index, :videos ]
  def index
    @user = current_user
  end
end
