# Отложенная операция для отправления пуш уведомлений
class SendPushJob < ActiveJob::Base

  queue_as :default

  def perform(tokens, options)
    PushSender.send_push(tokens, options)
  end
end