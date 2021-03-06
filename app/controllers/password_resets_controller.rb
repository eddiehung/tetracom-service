class PasswordResetsController < ApplicationController

	def new
		@user = User.new
	end

	def show
	end

	def create
		@user = User.find_by_email(params[:email].downcase)
		@user.send_password_reset if @user
		redirect_to root_url, notice: "Email sent with password reset instructions."
	end

	def edit
		@user = User.find_by_password_reset_token!(params[:id])
	end

	def update
		@user = User.find_by_password_reset_token!(params[:id])
		if @user.password_reset_sent_at < 2.hours.ago
			redirect_to_new password_reset_path, alert: "Reset password request has expired."
		elsif @user.update_attributes(user_params)
			redirect_to root_url, notice: "Password has been reset!"
		else
			render :edit
		end
	end

	private
	def user_params
		params.require(:user).permit(:name, :email, :phone, :affiliation, :expertise, :password, :password_confirmation, :show_name, :show_email, :show_phone, :show_affiliation)
	end

end
