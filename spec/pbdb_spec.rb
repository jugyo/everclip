# -*- coding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "PBDB" do
  it 'should init ClipLogger and Server' do
    config = PBDB::CONFIG
    mock(PBDB::ClipLogger).run!(
      :interval => config[:interval],
      :ignore_duplication => config[:ignore_duplication]
    )
    mock(PBDB::Server).run!(
      :Host => config[:host],
      :Port => config[:port]
    )
    PBDB.start
  end
end
