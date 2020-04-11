require 'rack'
require 'rack/contrib'
require 'pg'

rack_static = Rack::TryStatic.new(Rack::NotFound.new, :urls => %w[/], :root => 'public',
  :index => 'index.html', :try => ['.html'])

run lambda { |env|
  case env['REQUEST_METHOD']
  when 'POST'
    useragent = env['HTTP_USER_AGENT']
    feature = env["PATH_INFO"]
    content = env['rack.input'].read

    uri = URI.parse(ENV['DATABASE_URL'])
    begin
      connection = PG.connect(uri.hostname, uri.port, nil, nil, uri.path[1..-1], uri.user, uri.password)
      connection.prepare 'insert', "INSERT INTO reports VALUES(DEFAULT, $1, $2, $3)"
      connection.exec_prepared 'insert', [useragent, feature, content]
    ensure
      connection.close if connection
    end
    [204, {}, []]
  when 'GET'
    rack_static.call(env)
  end
}
