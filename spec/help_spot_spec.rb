require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "HelpSpot" do
  it "should provide a version constant" do
    HelpSpot::VERSION.should be_instance_of(String)
  end
  before :each do
    @help_spot = HelpSpot.new("https://support.local/api/", "foobar@localhost.com", "sekrit")
  end
  describe "verifying authentcation" do
    it "returns true when properly authenticated" do
      @help_spot.stub_get('/api/index.php?method=private.version', 'version.xml')
      @help_spot.authenticated?.should be_true
    end
    it "returns false when not properly authenticated" do
      @help_spot.stub_http_response_with('error.xml')
      @help_spot.authenticated?.should be_false
    end
  end

  describe 'requests' do
    describe "being created" do
      before(:each) do
        @help_spot.stub_post('/api/index.php?method=private.request.create', 'request.id.xml')
      end
      it "require a note, a category, and some contact info" do
        lambda { @help_spot.create_request() }.should raise_exception
        lambda { @help_spot.create_request(:tNote => 'foo') }.should raise_exception
        lambda { @help_spot.create_request(:xCategory => 1) }.should raise_exception
        lambda { @help_spot.create_request(:tNote => 'foo', :xCategory => 1) }.should raise_exception
        %w(sFirstName sLastName sUserId sEmail sPhone).each do |valid_contact_info|
          lambda { @help_spot.create_request(:tNote => 'foo', :xCategory => 1, valid_contact_info.intern => 'foo') }.should_not raise_exception
        end
      end
      it "return the request id" do
        @help_spot.create_request(:tNote => 'foo', :xCategory => 1, :sEmail => 'needy@customer.com').should == 12746
      end
    end
    describe "being updated" do
      before(:each) do
        @help_spot.stub_post('/api/index.php?method=private.request.update', 'request.id.xml')
      end
      it "return the request id" do
        @help_spot.update_request(12746, :tNote => 'foo', :xCategory => 1, :sEmail => 'needy@customer.com').should == 12746
      end
    end
    it "should be accessible" do
      @help_spot.stub_get('/api/index.php?method=private.request.get&xRequest=12745', 'request.get.xml')
      request = @help_spot.request(12745)
      request.xPersonAssignedTo.should == 'Ian Landsman'
      request.request_history.first.xPerson.should == 'Ian Landsman'
    end
    it "should have accessible history" do
      @help_spot.stub_get('/api/index.php?method=private.request.get&xRequest=12745', 'request.get.xml')
      request = @help_spot.request(12745)
      request.request_history.length.should == 4
      request.request_history.first.xPerson.should == 'Ian Landsman'
    end
    it "should be searchable" do
      @help_spot.stub_get('/api/index.php?method=private.request.search&sSearch=printer', 'request.search.xml')
      requests = @help_spot.search_requests(:sSearch => 'printer')
      requests.first.xPersonAssignedTo.should == 'Ian Landsman'
    end
  end
  describe 'categories' do
    it "can be listed" do
      @help_spot.stub_get('/api/index.php?method=private.request.getCategories&fDeleted=0', 'request.getCategories.xml')
      categories = @help_spot.categories
      categories.first.sCategory.should == 'Pre Sales Question'
    end
  end
  describe 'statuses' do
    it "can be listed" do
      @help_spot.stub_get('/api/index.php?method=private.request.getStatusTypes&fActiveOnly=1', 'request.getStatusTypes.xml')
      statues = @help_spot.status_types
      statues.first.sStatus.should == 'Active'
    end
  end
  describe 'custom fields' do
    it "can be listed" do
      @help_spot.stub_get('/api/index.php?method=private.request.getCustomFields', 'request.getCustomFields.xml')
      fields = @help_spot.custom_fields
      fields.first.fieldName.should == 'Ajax Lookup'
    end
  end
  describe 'filters' do
    it "can have their requests retrieved" do
      @help_spot.stub_get('/api/index.php?method=private.filter.get&xFilter=1234', 'filter.get.xml')
      requests = @help_spot.filter(1234)
      requests.first.tNote.should == 'I would like to be able to upload documents over 1 gigabyte.'
    end
  end
  describe 'time tracking events' do
    it "can be searched" do
      @help_spot.stub_get('/api/index.php?method=private.timetracker.search&start_time=1', 'private.timetracker.search.xml')
      time_events = @help_spot.search_time_events(:start_time => 1)
      time_events.size.should == 2
      time_events.first.iSeconds.should == "5400"
    end
  end
end