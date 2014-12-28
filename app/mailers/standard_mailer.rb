class StandardMailer < ActionMailer::Base
  default from: "js6070699@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.standard_mailer.error_mail.subject
  #
  def error_mail(subject, text)
    @text = 'Error ' + text

    mail(to: "sakamoto.jun05@gmail.com", subject: subject)
  end
end
