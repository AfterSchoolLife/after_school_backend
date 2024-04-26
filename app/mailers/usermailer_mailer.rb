class UsermailerMailer < ApplicationMailer
  require 'sendgrid-ruby'
  include SendGrid

  def welcome_email(user)
    @user = user
    subject = 'Welcome to AfterSchoolLife!'
    content = "Hello #{@user.parent_1_name}, welcome to AfterSchoolLife. You have successfully registered. Please login and look into our program offerings!"
    send_email(@user.email, subject, content)
  end

  def payment_successful_email(user)
    @user = user
    subject = 'Payment Confirmation for AfterSchoolLife'
    content = "Dear #{@user.parent_1_name}, your payment has been successfully processed. Thank you for your purchase."
    send_email(@user.email, subject, content)
  end

  def payment_faliure_email(user)
    @user = user
    subject = 'Payment Faliure for AfterSchoolLife'
    content = "Dear #{@user.parent_1_name}, your payment has failed."
    send_email(@user.email, subject, content)
  end

  def program_registration_email(user, program)
    @user = user
    @program = program
    subject = 'Confirmation of Registration for Program'
    content = "Hello #{@user.parent_1_name}, you have successfully registered for #{@program}. Details about the program will follow shortly."
    send_email(@user.email, subject, content)
  end

  private

  def send_email(to, subject, content)
    mail = SendGrid::Mail.new
    mail.from = Email.new(email: 'gowthamreddy1289@gmail.com')
    personalization = Personalization.new
    personalization.add_to(Email.new(email: to))
    mail.add_personalization(personalization)
    mail.subject = subject
    mail.add_content(Content.new(type: 'text/plain', value: content))
    
    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    response = sg.client.mail._('send').post(request_body: mail.to_json)
    puts response.status_code
    puts response.body
  end
end
