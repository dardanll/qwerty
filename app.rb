require "bundler/setup"
require "sinatra"
require "rack/csrf"
require "ruote"
require "json"

Dir.glob(File.join("lib/qwerty", "**", "*.rb")).each do |klass|
  require_relative klass
end

require "sinatra/reloader" if development?

use Rack::Session::Cookie, :secret => ""
use Rack::Csrf, :raise => true
use Qwerty::TrainClassifier

get '/' do
  engine = ruote
  @ruote.noisy = true

  conveyor do
    initial :source

    section(:classifier) do
      action(:ots)
      action(:lda)
      action(:bayes)
    end
  end
end
