# -*- coding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "EverClip" do
  it 'should init ClipLogger and Server' do
    config = YAML.load_file(EverClip.config_file_path)
    mock(EverClip::ClipLogger).run!(
      :interval => config[:interval],
      :ignore_duplication => config[:ignore_duplication]
    )
    mock(EverClip::Server).run!(
      :Host => config[:host],
      :Port => config[:port]
    )
    EverClip.start
  end
end
