require 'rack'
require_relative 'lib/time_formatter'

class App

  def call(env)
    request = Rack::Request.new(env)

    request_valid?(request) ? operate_request(request) : response_bad_request
  end

  private

  def operate_request(request)
    params_string = request.params['format']
    @time_formatter = TimeFormatter.new(params_string)

    request_query_string_valid? ? response_success : response_unknown_formats
  end

  def request_query_string_valid?
    @time_formatter.rejected_params.empty?
  end

  def request_valid?(request)
    request.get? &&
    request.path == '/time' &&
    !request.params.empty? &&
    !request.params['format'].nil?
  end

  def response(options)
    [
      options[:status],
      {'Content-Type' => "text/html"},
      [options[:body]]
    ]
  end

  def response_bad_request
    response({status: 404, body: 'Check your request'})
  end

  def response_success
    response({status: 200, body: @time_formatter.converted_formats})
  end

  def response_unknown_formats
    response({status: 400, body: "Unknown formats #{@time_formatter.rejected_params}"})
  end
end
