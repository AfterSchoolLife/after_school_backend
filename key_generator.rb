require 'securerandom'
jwt_secret_key = SecureRandom.hex(64)
puts jwt_secret_key