class AccountsController < ApplicationController
  # before_action :print_params
  before_action :account_params, only: %i[login signup]

  def login
    @login_form = LoginSignupForm.new(account_params)
    @signup_form = LoginSignupForm.new

    unless @login_form.valid?
      @errors = @login_form.errors
      flashes :error, @login_form.errors.full_messages
      return render 'show', status: 422
    end

    begin
      @login_form.login!
    rescue Accounts::LoginUserNotFound => e
      flash[:error] = e.message
      return render 'show', status: 418
    rescue Accounts::TokenCreationFailed => e
      flash[:error] = e.message
      return render 'show', status: 500
    end

    unless @login_form.success
      flash[:error] = 'Something went very wrong. Please reach out to us'.freeze
      return render 'show', status: 424
    end

    session[:access_token] = @login_form.token.session_token
    session[:refresh_token] = @login_form.token.session_refresh_token

    p 'session token in session'
    p session[:access_token]

    flash[:notice] = "Welcome back #{@login_form.email.sub(/@.*$/, '')}"
    redirect_to products_url
  end

  def signup
    @login_form = LoginSignupForm.new
    @signup_form = LoginSignupForm.new(account_params)

    unless @signup_form.valid?
      @errors = @signup_form.errors
      flashes :error, @signup_form.errors.full_messages
      return render 'show', status: 422
    end

    begin
      @signup_form.signup!
    rescue Accounts::SignupUserExists => e
      flash[:error] = e.message
      return render :show, status: 422
    rescue Accounts::CreateUserFailed => e
      flash[:error] = e.message
      return render :show, status: 500
    rescue Accounts::TokenCreationFailed => e
      flash[:error] = e.message
      return render :show, status: 500
    end

    unless @signup_form.success
      flash[:error] = 'Something went very wrong. Please reach out to us'.freeze
      return render 'show', status: 424
    end

    session[:access_token] = @signup_form.token.session_token
    session[:refresh_token] = @signup_form.token.session_refresh_token

    flash[:notice] = "Welcome #{@signup_form.email.sub(/@.*$/, '')}"
    redirect_to products_url
  end

  def show
    @login_form = LoginSignupForm.new
    @signup_form = LoginSignupForm.new
  end

  def logout
    current_token.expire! if current_token.present? && current_token.valid?

    session.delete(:access_token)
    session.delete(:refresh_token)

    redirect_to root_url
  end

  def trigger_recover_password; end

  def validate_recovery_token; end

  def reset_password; end

  private

  def print_params
    p params
  end

  def account_params
    params.require(:login_signup_form).permit(:email, :password)
  end
end
