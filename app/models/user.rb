class User < ActiveRecord::Base
	nilify_blanks
	
	# Attributes: 
	# :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count
	# :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip
	# Custom Attributes
	# :admin, :last_name, :title
	# Required
	# :first_name
	#
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable
end
