module PBDB
  class Server < Sinatra::Base
    dir = File.dirname(File.expand_path(__FILE__))

    set :views,  "#{dir}/views"
    set :public, "#{dir}/public"
    set :static, true

    get '/css' do
      sass :styles
    end

    get '/' do
      # TODO: リスト表示、ペジング、検索
      haml :index
    end

    get '/copy/:id' do
      # TODO: クリップボードに読み込み
      ''
    end
  end
end