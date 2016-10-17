# Отложенная операция для отправления пуш уведомлений
class SendPushWorker

  include Sidekiq::Worker

  def perform(tokens, options)
    PushSender.send_push(tokens, options)
  end
end