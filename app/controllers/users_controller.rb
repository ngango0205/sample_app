class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update]
  before_action :logged_in_user, only: [:index, :edit, :update, :show, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.where(activated: true).page(params[:page])
    .per(Settings.page.per_page)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "title5"
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    if @user&.activated
      @microposts = @user.microposts.page(params[:page]).per Settings.page.per_page
    else
      redirect_to root_url
    end
  end

  def edit
    @users
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "title4"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "title3"
      redirect_to users_url
    else
      flash[:warning] = t "title2"
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "title10"
    redirect_to root_url
  end

  def logged_in_user
    unless logged_in?
      flash[:danger] = t "title2"
      redirect_to login_url
    end
  end

  def correct_user
    find_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
