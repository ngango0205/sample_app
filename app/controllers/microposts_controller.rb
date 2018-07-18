class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t "micropost_created"
      redirect_to root_url
    else
      @feed_items = []
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "micropost_deleted"
      redirect_to request.referrer || root_url
    else
      flash[:warning] = t "title11"
      redirect_to root_path
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :picturesss
  end

  def correct_user
    unless @micropost = current_user.microposts.find_by id: params[:id]
      redirect_to root_url
    end
  end
end
