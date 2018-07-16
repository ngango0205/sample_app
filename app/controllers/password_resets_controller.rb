class PasswordResetsController < ApplicationController
  before_action :find_user, :valid_user, :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "email_send"
      redirect_to root_url
    else
      flash.now[:danger] = t "email_notfound"
      render :new
    end
  end

  def edit
  end

  def update
    if params[:user][:password].present?
      if @user.update_attributes user_params
        log_in @user
        flash[:success] = t "pass_reseted"
        redirect_to @user
      else
        render :edit
      end
    else @user.errors.add :password, t("errors_empty")
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user
    @user = User.find_by email: params[:email]
    return if @user
    flash[:danger] = t "title10"
    redirect_to root_url
  end

  def valid_user
    unless @user&.activated? && @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "pass_expried"
    redirect_to new_password_reset_url
  end
end
