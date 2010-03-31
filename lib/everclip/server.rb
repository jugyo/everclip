# -*- coding: utf-8 -*-

require "sinatra"

module EverClip
  class Server < Sinatra::Base
    dir = File.dirname(File.expand_path(__FILE__))

    set :root, File.dirname(__FILE__)
    set :haml, {:escape_html => true}

    get '/css' do
      sass :style
    end
    
    get '/' do
      # TODO: リスト表示、ページング、検索
      @clips = Clip.order(:created_at.desc).limit(100)
      haml :index
    end

    get '/search' do
      query = params[:q]
      @clips = Clip.filter("text like ?", "%#{query}%").order(:created_at.desc).limit(100)
      partial :clips
    end
    
    get '/clip/:id' do
      @clip = Clip[params[:id]]
    end
    
    get '/copy/:id' do
      # TODO: クリップボードに読み込み
      ''
    end

    helpers do
      def partial(page, options={})
        haml page, options.merge!(:layout => false)
      end
    end
  end
end
