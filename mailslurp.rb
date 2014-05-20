#!/bin/env ruby

require 'sinatra/base'
require 'fog'
require 'yaml'
require 'time'

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

  get '/' do
    'Online and ready to receive.'
  end

  post '/incoming' do
    logger.info "Got a message!"
    logger.info params.inspect

    # Construct an event body from the message.
    subject = params['Subject'].gsub(/^(?:(?:Re:|Fwd:)\s*)+/, '')

    event = {
      reporter: 'mailslurp',
      title: subject,
      incident_date: Time.parse(params['Date']).to_i
    }

    @q.enqueue event, 3600

    200
  end

end
