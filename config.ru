require 'rack'

use Rack::Static, :urls => {"/" => 'index.html'}, :root => 'public'

run lambda { |env|
  [404, {'Content-type' => 'text/plain'}, ['Not found']]
}
