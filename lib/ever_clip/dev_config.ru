# -*- coding: utf-8 -*-

$:.unshift(File.dirname(__FILE__) + "/..")

require 'ever_clip'

EverClip.init
run EverClip::Server.new
