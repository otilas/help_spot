require 'hashie'
require 'httparty'
require 'help_spot/version'

class HelpSpot
  include HTTParty
  format :xml
  mattr_inheritable :base

  class ApiErrors < RuntimeError
  end

  def initialize(base, user, pass)
    self.class.base_uri base
    self.class.basic_auth user, pass
  end

  # Verify authentication credentials
  #
  def authenticated?
    version = begin 
                api_request(:get, 'private.version').results.version
                true
              rescue HelpSpot::ApiErrors => e
                return false
              end
  end

  def create_request(options = {})
    raise ArgumentError unless options[:tNote] && options[:xCategory]
    raise ArgumentError unless options[:sFirstName] || options[:sLastName] || options[:sUserId] || options[:sEmail] || options[:sPhone]
    api_request(:post, 'private.request.create', options, :item => 'request').xRequest.to_i
  end

  def update_request(id, options = {})
    api_request(:post, 'private.request.update', options.merge(:xRequest => id), :item => 'request').xRequest.to_i
  end

  def request(id, options = {})
    response = api_request(:get, 'private.request.get', options.merge(:xRequest => id), :item => 'request')
    #munge even further the request history
    response.request_history = response.request_history['item'] rescue []
    response.request_history = [response.request_history] unless response.request_history.is_a?(Array)
    response
  end

  def search_requests(options = {})
    api_request(:get, 'private.request.search', options, {:collection => 'requests', :item => 'request'})
  end

  def categories
    api_request(:get, 'private.request.getCategories', {:fDeleted => 0}, {:collection => 'categories', :item => 'category'})
  end

  def status_types
    api_request(:get, 'private.request.getStatusTypes', {:fActiveOnly => 1}, {:collection => 'results', :item => 'status'})
  end

  def custom_fields(options = {})
    api_request(:get, 'private.request.getCustomFields', options, {:collection => 'customfields', :item => 'field'})
  end

  def filter(id, options = {})
    api_request(:get, 'private.filter.get', options.merge(:xFilter => id), {:collection => 'filter', :item => 'request'})
  end

  def search_time_events(options = {})
    api_request(:get, 'private.timetracker.search', options, {:collection => 'time_events', :item => 'event'})
  end

  def time_events(id, options = {})
    api_request(:get, 'private.request.getTimeEvents', options.merge(:xRequest => id), {:collection => 'time_events', :item => 'event'})
  end

private

  def api_request(http_method, method, options = {}, munge_options = {})
    parsed_options = {}
    if http_method == :get
      parsed_options[:query] = options
    else
      parsed_options[:query] = {}
      parsed_options[:body] = options
    end
    parsed_options[:query].merge!(:method => method)
    response = self.class.send(http_method, '/index.php', parsed_options)

    if errors = response['errors']
      # JSON gets returned weirdly sometimes if there's a single error. it gets interpreted as a hash, rather than an array with one thing
      if errors.kind_of?(Hash) 
        errors = [errors['error']]
      end

      errors_string = errors.map do |error|
        "* #{error['id']} - #{error['description']}"
      end.join("\n")

      raise ApiErrors, "#{errors.size} error(s) during #{method} API request:\n#{errors_string}"
    end


    if munge_options[:collection]
      unless collection = response[munge_options[:collection]][munge_options[:item]]
        return []
      end
      if collection.is_a?(Array)
        collection.map { |item| Hashie::Mash.new(item) }
      else
        [Hashie::Mash.new(collection)]
      end
    elsif munge_options[:item]
      Hashie::Mash.new(response[munge_options[:item]])
    else
      Hashie::Mash.new(response)
    end
  end

end
