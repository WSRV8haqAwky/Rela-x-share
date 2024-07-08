class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]

    if @range == "User"
      @users = User.looks(params[:search], params[:word]).page(params[:page]).reverse_order
    else
      @post_relaxes = PostRelax.looks(params[:search], params[:word]).page(params[:page]).reverse_order
    end
  end
end
