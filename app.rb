require 'rack'
require_relative 'lib/time_formatter'

class App

  def call(env)
    request = Rack::Request.new(env)
  
    if request.get? && !request.params.empty?
      operate_request(request)
    else
      Rack::Response.new('Can`t serve your request')
    end
  end

  def operate_request(request)
    params_string = request.params['format']
    formatted_time = TimeFormatter.new(params_string)

    if formatted_time.valid?
      Rack::Response.new("#{formatted_time.converted_formats}")
    else
      Rack::Response.new("Unknown formats #{formatted_time.rejected_params}")
    end
  end
end

