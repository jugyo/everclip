# -*- coding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "PBDB::ClipLogger" do
  before do
    @now = Time.now
    stub(Time).now { @now }
    PBDB::Clip.delete
  end

  it 'should log text from clipboad' do
    stub(PB).read { 'foo' }
    mock.proxy(PBDB::Clip).<<('foo')
    PBDB::ClipLogger.clip!(60)
    PBDB::Clip.stored?('foo').should be_true
  end

  it 'should not store same text' do
    stub(PB).read { 'foo' }
    PBDB::ClipLogger.clip!(60)
    PBDB::Clip.count.should == 1
    PBDB::ClipLogger.clip!(60)
    PBDB::Clip.count.should == 1
  end
end
