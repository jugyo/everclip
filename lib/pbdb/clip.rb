# -*- coding: utf-8 -*-

require 'digest/sha1'

module PBDB
  DB.create_table? :clips do
    primary_key :id
    String :sha1, :null => false
    String :text, :text => true, :null => false
    DateTime :created_at, :null => false
  end

  class Clip < Sequel::Model
    def self.<<(arg)
      case arg
      when String
        super(:sha1 => sha1(arg), :text => arg, :created_at => Time.now)
      else
        super
      end
    end

    def self.sha1(text)
      Digest::SHA1.hexdigest(text)
    end
  end
end
