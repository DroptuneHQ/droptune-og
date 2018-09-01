class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    @url  = 'https://droptune.co'
    mail(to: @user.email, subject: 'Welcome to Droptune!')
  end
end
