# Пользовательская ошибка. Несет в себе объект с информацией.
# Используется в контроллерах для генерации ответа.

class UserException < StandardError

  attr_accessor :object
  attr_accessor :data

  def initialize(message = nil, object = nil, data = nil)
    super(message)
    self.object = object
    self.data = data
  end
end