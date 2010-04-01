# -*- coding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe "EverClip::ClipLogger" do
  before do
    @now = Time.now
    stub(Time).now { @now }
    EverClip::Clip.delete
  end

  it 'should log text from clipboad' do
    stub(PB).read { 'foo' }
    mock.proxy(EverClip::Clip).<<('foo')
    EverClip::ClipLogger.clip!(60)
    EverClip::Clip.stored?('foo').should be_true
  end

  it 'should not store same text' do
    stub(PB).read { 'foo' }
    EverClip::ClipLogger.clip!(60)
    EverClip::Clip.count.should == 1
    EverClip::ClipLogger.clip!(60)
    EverClip::Clip.count.should == 1
  end
end
