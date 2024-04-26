class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :created_at, :parent_1_name, :parent_2_name, :parent_1_phone_number, :parent_2_phone_number,
              :emergency_1_name, :emergency_2_name, :emergency_1_relation, :emergency_2_relation, :emergency_1_phone_number, :emergency_2_phone_number, :role, :country
end
