module ApplicationHelper

  # Унификация ответа от сервера
  def render_response(status, success, info, data, errors)
    render :status => status,
           :json => { :success => success,
                      :info => info,
                      :data => data,
                      :errors => errors }
  end

  # Отправляет ответ клиенту с данными, возвращенными в get_method.
  def simple_json_response(success_info, &get_method)
    get_method ||= lambda{ [] }

    begin
      render_response(200, true, success_info, get_method.call, {})
    rescue UserException => e
      render_response(200, false, e.message, e.data, e.object)
    rescue ActionController::ParameterMissing => e
      render_response(200, false, "Params error", nil, { e.param => ['parameter is required'] })
    rescue Exception => e
      render_response(500, false, e.message, nil, {})
    end
  end

  # Вызывает метод модификации modification_method,
  # А затем сохраняет запись, возвращенную им.
  def modification_json_response(success_info, error_info, attrs = nil, &modification_method)
    modification_method ||= lambda{ [] }

    begin
      record = modification_method.call
      puts record.login
      puts record.password
      if record.save
        attributes = {}
        # Если список атрибутов не передан, возвращаются все атрибуты
        if attrs.nil?
          attributes = record.attributes
        else
          attrs.each { |attribute| attributes[attribute] = record.public_send(attribute) }
        end
        render_response(200, true, success_info, attributes, {})
      else
        render_response(200, false, error_info, nil, record.errors)
      end
    rescue UserException => e
      puts e.data
      render_response(200, false, e.message, e.data, e.object)
    rescue Exception => e
      render_response(500, false, e.message, nil, {})
    end
  end

  def asset_data_base64(path)
    asset = Rails.application.assets.find_asset(path)
    throw "Could not find asset '#{path}'" if asset.nil?
    base64 = Base64.encode64(asset.to_s).gsub(/\s+/, "")
    "data:#{asset.content_type};base64,#{Rack::Utils.escape(base64)}"
  end

end
