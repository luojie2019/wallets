class User < ApplicationRecord

	scope :not_deleted, -> { where(is_deleted: false) }

	has_secure_token
	
end	
 