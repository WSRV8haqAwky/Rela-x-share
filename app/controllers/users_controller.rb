class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:show]

  def index
    @users = User.page(params[:page]).reverse_order
    @user = current_user
  end

  def show
    @user = User.find(params[:id])
    @post_relaxes = PostRelax.page(params[:page]).where(user_id: @user.id).reverse_order
    @currentUserEntry=Entry.where(user_id: current_user.id)
    @userEntry=Entry.where(user_id: @user.id)
    if @user.id == current_user.id
    else
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id then
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      if @isRoom
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def edit
    @user = User.find(params[:id])
    if @user.id != current_user.id
      redirect_to user_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id),
      notice: "プロフィールの更新に成功しました"
    else
      render :edit
    end
  end


  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end
end
