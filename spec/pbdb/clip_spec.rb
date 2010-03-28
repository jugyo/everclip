require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "PBDB::Clip" do
  before do
    @now = Time.now
    stub(Time).now { @now }
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
end
