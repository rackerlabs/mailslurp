#!/bin/env ruby

require 'sinatra/base'
require 'fog'
require 'yaml'

class Mailslurp < Sinatra::Base

  configure do
    enable :logging

    path = File.join(__dir__, 'mailslurp.yml')
    @mailconf = YAML.load_file(path)

    # Log in to Cloud Queues.
    service = Fog::Rackspace::Queues.new(
      :rackspace_username => @mailconf['rackspace_username'],
      :rackspace_api_key => @mailconf['rackspace_api_key'],
      :rackspace_region => @mailconf['rackspace_region']
    )

    @q = service.queues.get(@mailconf['queue_name'])
    if @q.nil?
      @q = service.queues.create(:name => @mailconf['queue_name'])
    end
  end

  post '/incoming' do
    logger.info "Got a message!"
    logger.info params.inspect

    200
  end

end
