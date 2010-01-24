require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "HelpSpot" do
  it "should provide a version constant" do
    HelpSpot::VERSION.should be_instance_of(String)
  end
  before :each do
    @help_spot = HelpSpot.new("https://support.local/api/", "user@localhost.com", "sekrit")
  end

  describe "verifying authentcation" do
    it "returns true when properly authenticated" do
      stub_http_response_with('version.xml')
      @help_spot.authenticated?.should be_true
    end
    it "returns false when not properly authenticated" do
      stub_http_response_with('error.xml')
      @help_spot.authenticated?.should be_false
    end
  end
end
