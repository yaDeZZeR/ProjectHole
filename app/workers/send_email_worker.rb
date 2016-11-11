# Отложенная операция для отправления пуш уведомлений
class SendEmailWorker

  include Sidekiq::Worker

  def perform(email, id, token)
    EmailSender.send_email(email, id, token)
  end
end