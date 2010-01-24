require 'help_spot'
require 'spec'
require 'spec/autorun'
require 'fakeweb'

FakeWeb.allow_net_connect = false

class HelpSpot

  def help_spot_url(path)
    uri = URI.parse(self.class.default_options[:base_uri])
    uri.path, uri.query = path.split('?')
    uri.userinfo = "#{self.class.default_options[:basic_auth][:username]}:#{self.class.default_options[:basic_auth][:password]}".gsub(/@/, '%40')
    uri.to_s
  end

  def file_fixture(filename)
    open(File.join(File.dirname(__FILE__), 'fixtures', "#{filename.to_s}")).read
  end

  def stub_get(path, filename, status=nil)
    options = {:body => file_fixture(filename)}
    options.merge!({:status => status}) unless status.nil?
    FakeWeb.register_uri(:get, help_spot_url(path), options)
  end

  def stub_post(path, filename)
    FakeWeb.register_uri(:post, help_spot_url(path), :body => file_fixture(filename))
  end

  def stub_put(path, filename)
    FakeWeb.register_uri(:put, help_spot_url(path), :body => file_fixture(filename))
  end

  def stub_delete(path, filename)
    FakeWeb.register_uri(:delete, help_spot_url(path), :body => file_fixture(filename))
  end

  def stub_http_response_with(filename)
    format = filename.split('.').last.intern
    data = file_fixture(filename)

    response = Net::HTTPOK.new("1.1", 200, "Content for you")
    response.stub!(:body).and_return(data)

    http_request = HTTParty::Request.new(Net::HTTP::Get, 'http://localhost', :format => format)
    http_request.stub!(:perform_actual_request).and_return(response)

    HTTParty::Request.should_receive(:new).at_least(1).and_return(http_request)
  end

end