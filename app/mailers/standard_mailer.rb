class StandardMailer < ActionMailer::Base
  default from: 'video.booklyn@gmail.com'

  # TODO: Mail送信をJob経由で実行するよう変更する。

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.standard_mailer.error_mail.subject
  #
  def error_mail(subject = 'Error', text = '')
    @error_text = @@error_text << text

    mail(to: 'video.booklyn@gmail.com', subject: subject, &:text)
  end

  @@error_text = ''

  def append_error_text(text = '')
    @@error_text << text
  end

  def system_error_mail(e)
    return if e.nil?

    @system_error_text = '' << e.message.to_s << "\r\n" << e.backtrace.to_s
    mail(to: 'video.booklyn@gmail.com', subject: 'System Error', &:text)
  end
end
