class User < ActiveRecord::Base
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	has_many :reverse_relationships, foreign_key: "followed_id",
									class_name: "Relationship",
									dependent: :destroy
	has_many :followers, through: :reverse_relationships, source: :follower

	before_save :default_values
	before_create :create_remember_token

	validates :name, presence: true, length: { maximum: 50 }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

	VALID_PHONE_REGEX = /\A[\d+\-\(\) ]+\z/i
	validates :phone, format: { with: VALID_PHONE_REGEX }

	validates :affiliation, length: { maximum: 200 }

	validates :expertise, length: { maximum: 1000 }

	has_secure_password
	validates :password, length: { minimum: 6 }

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def following?(other_user)
		relationships.find_by(followed_id: other_user.id)
	end

	def follow!(other_user)
		relationships.create!(followed_id: other_user.id)
	end

	def unfollow!(other_user)
		relationships.find_by(followed_id: other_user.id).destroy!
	end

	private

	def create_remember_token
		self.remember_token = User.encrypt(User.new_remember_token)
	end

	def default_values
		self.email = email.downcase
		self.show_email ||= true
	end
end
