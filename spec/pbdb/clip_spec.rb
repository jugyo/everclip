# -*- coding: utf-8 -*-

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "PBDB::Clip" do
  before do
    @now = Time.now
    stub(Time).now { @now }
    PBDB::Clip.delete
  end

  it 'should store text' do
    key = PBDB::Clip << {:sha1 => 'xxx', :text => 'foo', :created_at => Time.now}
    row = PBDB::Clip[key]
    row.text.should == 'foo'
    row.sha1.should == 'xxx'

    key = PBDB::Clip << 'bar'
    row = PBDB::Clip[key]
    row.text.should == 'bar'
    row.sha1.should == PBDB::Clip.sha1('bar')
    row.created_at.should == @now
  end

  it 'should be able to check to store text' do
    PBDB::Clip << {:sha1 => PBDB::Clip.sha1('foo'), :text => 'foo', :created_at => Time.now - 60}

    PBDB::Clip.stored?('foo').should be_true
    PBDB::Clip.stored?('foo', 10).should be_false
  end
end
