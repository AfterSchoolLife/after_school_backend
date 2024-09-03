
# User.create!(
#   email: 'syedjawadbukhari5@gmail.com',
#   password: 'password123', # Providing a password here
#   password_confirmation: 'password123', # Confirming the password
#   parent_1_name: 'Parent One Name',
#   parent_1_phone_number: '1234567890',
#   parent_1_relation: 'Father',
#   emergency_1_name: 'Emergency Contact One',
#   emergency_1_relation: 'Uncle',
#   emergency_1_phone_number: '0987654321',
#   country: 'usa' # Replace with a valid country name if needed
# )

# User.create!(
#   email: 'livespotless@gmail.com',
#   password: 'password123',
#   password_confirmation: 'password123',
#   parent_1_name: 'Parent Two Name',
#   parent_1_phone_number: '0987654321',
#   parent_1_relation: 'Mother',
#   emergency_1_name: 'Emergency Contact Two',
#   emergency_1_relation: 'Aunt',
#   emergency_1_phone_number: '1234567890',
#   country: 'usa'
# )

# User.create!(
#   email: 'paindahaya@gmail.com',
#   password: 'password123',
#   password_confirmation: 'password123',
#   parent_1_name: 'Parent Three Name',
#   parent_1_phone_number: '1122334455',
#   parent_1_relation: 'Guardian',
#   emergency_1_name: 'Emergency Contact Three',
#   emergency_1_relation: 'Grandparent',
#   emergency_1_phone_number: '5544332211',
#   country: 'usa'
# )

# # Create Schools
# schools = [
#   { name: 'Green Valley School', address: '123 Green Valley Rd', country: 'USA' },
#   { name: 'Blue Mountain School', address: '456 Blue Mountain Ave', country: 'UK' }
# ]

# schools.each do |school_data|
#   School.create!(school_data)
# end

# # Create Programs
# programs = [
#   { title: 'Science Club', description: 'Explore the wonders of science!', created_by: User.first.id },
#   { title: 'Art Class', description: 'Unleash your creativity!', created_by: User.first.id }
# ]

# programs.each do |program_data|
#   Program.create!(program_data)
# end


# Schedule.create!(
#   days: 'Monday',
#   start_time: '09:00',
#   end_time: '11:00',
#   start_date: '2024-09-01',
#   end_date: '2024-12-01',
#   age_group: '6-8',
#   price: 100.00,
#   is_active: true,
#   school_id: School.last.id,  # Replace with a valid school_id
#   program_id: Program.last.id,  # Replace with a valid program_id
#   teacher_name: 'John Doe',  # Provide a valid teacher name
#   cost_of_teacher: 50.00,  # Provide a valid cost for the teacher
#   facility_rental: 20.00,  # Provide a valid facility rental cost
#   total_available: 20,
#   currently_available: 20,
#   created_by: User.last.id,  # Replace with a valid user_id
#   country: 'usa'  # Ensure this is a valid country
# )


# # Create Students
# students = [
#   { firstname: 'John', lastname: 'Doe', age: 7, grade: '1st', address: '123 Apple St', city: 'New York', 
#     state: 'NY', zip: '10001', user_id: User.first.id },
#   { firstname: 'Jane', lastname: 'Smith', age: 9, grade: '3rd', address: '456 Orange Rd', city: 'London', 
#     state: 'LN', zip: '10002', user_id: User.last.id }
# ]

# students.each do |student_data|
#   Student.create!(student_data)
# end

# # Create Carts
# carts = [
#   { user_id: User.first.id, schedule_id: Schedule.first.id, student_id: Student.first.id, cart_type: 'enrollment' },
#   { user_id: User.last.id, schedule_id: Schedule.last.id, student_id: Student.last.id, cart_type: 'enrollment' }
# ]

# carts.each do |cart_data|
#   Cart.create!(cart_data)
# end

# # Create Purchaseds
# purchaseds = [
#   { user_id: User.first.id, student_id: Student.first.id, schedule_id: Schedule.first.id, cart_type: 'purchase', 
#     purchase_uuid: SecureRandom.uuid, status: 'completed' },
#   { user_id: User.last.id, student_id: Student.last.id, schedule_id: Schedule.last.id, cart_type: 'purchase', 
#     purchase_uuid: SecureRandom.uuid, status: 'completed' }
# ]

# purchaseds.each do |purchased_data|
#   Purchased.create!(purchased_data)
# end

# # Create Waitlists
# waitlists = [
#   { schedule_id: Schedule.first.id, student_id: Student.last.id, user_id: User.last.id },
#   { schedule_id: Schedule.last.id, student_id: Student.first.id, user_id: User.first.id }
# ]

# waitlists.each do |waitlist_data|
#   Waitlist.create!(waitlist_data)
# end

# puts "Database seeded successfully!"
