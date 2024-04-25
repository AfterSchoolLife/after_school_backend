class UsermailerMailer < ApplicationMailer

    # app/mailers/user_mailer.rb
    require 'sendgrid-ruby'
    include SendGrid
  
    def welcome_email(user)
      @user = user
      mail = SendGrid::Mail.new
      mail.from = Email.new(email: 'gowthamreddy1289@gmail.com')
      mail.subject = 'Welcome to AfterSchoolLife!'
      personalization = Personalization.new
      personalization.add_to(Email.new(email: @user.email))
      mail.add_personalization(personalization)
      mail.add_content(Content.new(type: 'text/plain', value: "Hello #{@user.name}, welcome to AfterSchoolLife. You have successfully registered. Please login and look into our program offerings!"))
      
      sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
      response = sg.client.mail._('send').post(request_body: mail.to_json)
      puts response.status_code
      puts response.body
    end

  end
  
end
