require 'rack'
require 'pg'

use Rack::Static, :urls => {"/" => 'index.html'}, :root => 'public'

run lambda { |env|
  case env['REQUEST_METHOD']
  when 'POST'
    useragent = env['HTTP_USER_AGENT']
    content = env['rack.input'].read

    uri = URI.parse(ENV['DATABASE_URL'])
    begin
      connection = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
      connection.prepare 'insert', "INSERT INTO reports VALUES($1, $2)"
      connection.exec_prepared 'insert', [useragent, content]
    ensure
      connection.close if connection
    end
    [204, {}, []]
  when 'GET'
    [404, {'Content-type' => 'text/plain'}, ['Not found']]
  end
}
