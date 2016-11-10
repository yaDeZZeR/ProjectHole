# Отложенная операция для отправления пуш уведомлений
class SendEmailWorker

  include Sidekiq::Worker

  def perform(email, id)
    EmailSender.send_email(email, id)
  end
end