require 'hashie'
require 'httparty'
require 'help_spot/version'

class HelpSpot
  include HTTParty
  format :xml
  mattr_inheritable :base

  def initialize(base, user, pass)
    self.class.base_uri base
    self.class.basic_auth user, pass
  end

  # sends a feedback request to HelpSpot and returns the request ID number and access key
  #
  # == Options
  # In addition to note you must also have at least one of the following set: first_name, last_name, user_id, email or phone
  # * note
  #     The body of the ticket
  # * category
  # * first_name
  # * last_name
  # * user_id
  # * email
  # * phone
  # * urgent
  #     A boolean flag. Defaults to false.
  #
  def create(args)
    help_form = {:tNote       => args[:note],
                 :xCategory   => args[:category],
                 :sFirstName  => args[:first_name],
                 :sLastName   => args[:last_name],
                 :sUserId     => args[:user_id],
                 :sEmail      => args[:email],
                 :sPhone      => args[:phone],
                 :fUrgent     => args[:urgent]}.reject!{|k,v| v == nil}

    JSON.parse(api_request('request.create', 'POST', help_form))['xRequest'] rescue []
  end

  # Verify authentication credentials
  #
  def authenticated?
    version = Hashie::Mash.new(self.class.get("?method=private.version"))
    return false if version.errors
    return true if version.results.version
    false
  end

  # Returns an array of tickets belonging to a given user id.
  #
  # == Authentication
  # This method does require authentication.
  #
  # == Options
  # * user_id
  #     The user who's tickets you wish to view.
  #
  def get_by_user_id(args)
    JSON.parse(api_request('private.request.search', 'GET', {:sUserId => args[:user_id]}))['request'] rescue nil
  end

  # Return all information on a request.
  #
  # == Authentication
  # This method does require authentication.
  #
  def request(id)
    JSON.parse(api_request('private.request.get', 'GET', {:xRequest => id})) rescue nil
  end

  # Returns a list of custom fields.
  #
  # == Authentication
  # This method does require authentication.
  #
  # == Options
  # * xCategory
  #     Optionally limit the results to one categories custom fields
  def custom_fields(args = {})
    JSON.parse(api_request('private.request.getCustomFields', 'GET', args))['field'] rescue nil
  end

  # Returns an array of time events matching a search
  #
  # == Authentication
  # This method does require authentication.
  #
  # == Options
  # * sUserId
  # * sEmail
  # * sFirstName
  # * sLastName
  # * fOpen
  # * xStatus
  # * xMailbox
  # * fOpenedVia
  # * xCategory
  # * fUrgent
  # * xPersonAssignedTo
  # * xPersonOpenedBy
  # * Custom#
  # * start_time (30 days back by default, set to 0 for all time)
  # * end_time (right now by default)
  # * fRawValues
  # * orderBy (defaults to dtGMTDate)
  # * orderByDir (desc or asc)
  #
  def timetracker_search(args = {})
    JSON.parse(api_request('private.timetracker.search', 'GET', args))['event'] rescue nil
  end

  # Returns ticket categories.
  #
  # == Authentication
  # This method does require authentication.
  #
  # == Options
  # * include_deleted
  #     true if you want to include deleted categories.
  #
  def categories(args={})
    res = api_request('private.request.getCategories', 'GET')
    res = JSON.parse(res)['category'] rescue []

    unless args[:include_deleted] and args[:include_deleted] == true
      res.reject!{|k, v| v['fDeleted'] == '1'} rescue []
    end

    return res
  end

  # Returns an array of non-deleted categories, as key value pairs. Useful for select lists.
  #
  # == Authentication
  # This method does require authentication.
  #
  def category_key_value_pairs
    categories.collect{|k,v| [k,v['sCategory']]} rescue []
  end

  # Returns non-deleted categories, with a list of predefined categories removed
  #
  def category_key_value_pairs_without(categories=nil)
    categories ||= @config['hidden_categories'] rescue nil

    orig_categories = category_key_value_pairs
    if categories
      categories.each do |category|
        orig_categories.reject!{|i| i[1] == category}
      end
    end
    orig_categories
  end

  # Returns an array of forums
  #
  def forums_list
    JSON.parse(HelpSpot.api_request('forums.list'))['forum'] rescue []
  end

  # Returns an array of forums
  #
  # == Options
  # * forum_id
  #     The numeric id of the forum you want.
  def forum_get(args)
    JSON.parse(HelpSpot.api_request('forums.get', 'GET', :xForumId => args[:forum_id])) rescue []
  end

  # Returns an array of topics from a given forum
  #
  # == Options
  # * forum_id
  #     The numeric id of the forum you want.
  # * start
  #     record set position to start at
  # * length
  #     how many records to return
  #
  def forum_get_topics(args={})
    JSON.parse(HelpSpot.api_request('forums.getTopics', 'GET', {:xForumId => args[:forum_id]}.merge(args)))['topic'] rescue []
  end

  # Returns an array of posts from a given topic
  #
  # == Options
  # * topic_id
  #     The numeric id of the topic
  #
  def forum_get_topic_posts(args={})
    JSON.parse(HelpSpot.api_request('forums.getPosts', 'GET', :xTopicId => args[:topic_id]))['post'] rescue []
  end

end