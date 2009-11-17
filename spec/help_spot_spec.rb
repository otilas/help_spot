require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "HelpSpot" do
  before :each do
    HelpSpot.configure :root_url => "https://support.local/api/index.php?format=json",
      :username => "user@localhost.com",
      :password => "sekrit"
  end

  it "requires root_url, username, and password" do
    lambda { HelpSpot.configure :username => 'foo', :password => 'foo' }.should raise_error
    lambda { HelpSpot.configure :root_url => 'foo', :password => 'foo' }.should raise_error
    lambda { HelpSpot.configure :root_url => 'foo', :username => 'foo' }.should raise_error
    lambda { HelpSpot.configure :root_url => nil, :username => nil, :password => nil }.should raise_error
  end

  it "can verify authentication" do
    FakeWeb.register_uri(:get, "https://user%40localhost.com:sekrit@support.local/api/index.php?output=json&method=private.version&format=json",
      [
        {:body => "{\"error\":[{\"id\":2,\"description\":\"User authentication failed\"}]}", :status => ["401", "Unauthorized"]},
        {:body => "{\"version\":\"1.2\",\"min_version\":\"1.0\"}"}
      ]
    )
    HelpSpot.authenticated?.should be_false
    HelpSpot.authenticated?.should be_true
  end
end
