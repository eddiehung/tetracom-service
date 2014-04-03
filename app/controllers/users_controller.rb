class UsersController < ApplicationController
	before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers, :promote]
	before_action :correct_user,   only: [:edit, :update]
	before_action :admin_user,     only: [:destroy, :promote]
	before_action :signed_in_user_filter, only: [:new, :create]

	def index
		if current_user.admin?
			@users = User.paginate(page: params[:page] )
		else
			#@users = User.paginate(page: params[:page], :conditions => "expertise<>''" )
			@users = User.paginate(page: params[:page] )
		end
	end

	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to the TETRACOM Consulation Service!"
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @user.update_attributes(user_params)
			flash[:success] = "Profile updated."
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User deleted."
		redirect_to users_url
	end

	def promote
		if User.find(params[:id]).update_attribute(:admin, true)
			flash[:success] = "User is promote to admin!"
			redirect_to users_url
		end
	end

	def following
		@title = "Experts selected"
		@user = User.find(params[:id])
		@users = @user.followed_users.paginate(page: params[:page])
		render 'show_follow'
	end

	def followers
		@title = "Users requesting advices"
		@user = User.find(params[:id])
		@users = @user.followers.paginate(page: params[:page])
		render 'show_follow'
	end

	private
	def user_params
		params.require(:user).permit(:name, :email, :phone, :affiliation, :expertise, :password, :password_confirmation, :show_name, :show_email, :show_phone, :show_affiliation)
	end

	# Before filters

	def correct_user
		@user = User.find(params[:id])
		redirect_to(root_url) unless current_user?(@user) || current_user.admin?
	end

	def admin_user
		redirect_to(root_url) unless current_user.admin?
	end

	def signed_in_user_filter
		if signed_in?
			redirect_to root_url, notice: "Already logged in."
		end
	end
end
