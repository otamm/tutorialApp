class UserMailer < ApplicationMailer
  default from: "noreply@veryveryverycoolwebsite.net"
  #Generated with 'rails generate mailer UserMailer account_activation password_reset' on the terminal.

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation" # the 'subject' key will be the subject of the e-mail.

    # The URL generated will be something like this: http://www.example.com/account_activations/q5lt38hQDc_959PVoo6b7A/edit
    # the string after /account_activations/ is a URL-safe base64 string generated by the 'new_token' method.
    # the ActivationsController edit method will be available in the params hash as params[:id].
    # In order to include the e-mail as well, we need to use a query parameter, which in a URL appears as a key-value pair located after a question mark: "(...)/edit?email=kikass%40email.net"
    # Note that the '@' was replaced with '%40'. It was 'escaped out' to guarantee a valid URL.
    # The way to set up a query parameter in Rails is to include a hash in the named route (ex: 'edit_account_activation_url(@user.activation_token, email: @user.email)')
    # When using named routes to define query parameters, Rails automatically escapes out any special characters (like the '@' at the e-mail). The e-mail will be available in params[:email]
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
