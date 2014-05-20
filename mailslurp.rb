#!/bin/env ruby

require 'sinatra/base'
require 'fog'
require 'yaml'
require 'time'

class TheQueue
  def self.login
    path = File.join(__dir__, 'mailslurp.yml')
    mailconf = YAML.load_file(path)

    # Log in to Cloud Queues.
    service = Fog::Rackspace::Queues.new(
      :rackspace_username => mailconf['rackspace_username'],
      :rackspace_api_key => mailconf['rackspace_api_key'],
      :rackspace_region => mailconf['rackspace_region']
    )

    # Find or create the queue.
    @q = service.queues.get(mailconf['queue_name'])
    if @q.nil?
      @q = service.queues.create(:name => mailconf['queue_name'])
    end
  end

  def self.enqueue data
    @q.enqueue data, 3600
  end
end

class Mailslurp < Sinatra::Base

  configure do
    enable :logging

    TheQueue.login
  end

  get '/' do
    'Online and ready to receive.'
  end

  post '/incoming' do
    logger.info "Got a message!"
    logger.info params.inspect

    # Construct an event body from the message.
    subject = params['Subject'].gsub(/^(?:(?:Re:|Fwd:)\s*)+/, '')

    TheQueue.enqueue(
      reporter: 'mailslurp',
      title: subject,
      incident_date: Time.parse(params['Date']).to_i
    )

    200
  end

end
