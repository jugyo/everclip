# -*- coding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "EverClip::Clip" do
  before do
    @now = Time.now
    stub(Time).now { @now }
    EverClip::Clip.delete
  end

  it 'should store text' do
    key = EverClip::Clip << {:sha1 => 'xxx', :text => 'foo', :created_at => Time.now}
    row = EverClip::Clip[key]
    row.text.should == 'foo'
    row.sha1.should == 'xxx'

    key = EverClip::Clip << 'bar'
    row = EverClip::Clip[key]
    row.text.should == 'bar'
    row.sha1.should == EverClip::Clip.sha1('bar')
    row.created_at.should == @now
  end

  it 'should be able to check to store text' do
    EverClip::Clip << {:sha1 => EverClip::Clip.sha1('foo'), :text => 'foo', :created_at => Time.now - 60}

    EverClip::Clip.stored?('foo').should be_true
    EverClip::Clip.stored?('foo', 10).should be_false
  end
end
