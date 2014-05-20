require 'multimap'
require 'restclient'
require 'yaml'

MAILGUNNED = File.join(__dir__, '.mailgunned')

task :configure do
  path = File.join(__dir__, 'mailslurp.yml')
  @config = YAML.load_file(path)
end

namespace :mailgun do

  desc 'Configure Mailgun routes to point to this domain.'
  task :register => :configure do
    if File.exist? MAILGUNNED
      puts 'Already registered with mailgun. Skipping.'
      next
    end

    target = "#{@config['scheme']}://#{@config['hostname']}/incoming"
    puts "Configuring Mailgun to forward everything to: #{target}"

    data = Multimap.new
    data[:priority] = 1
    data[:description] = 'Give me all your email'
    data[:expression] = 'catch_all()'
    data[:action] = "forward('#{target}')"

    RestClient.post "https://api:#{@config['mailgun_api_key']}" \
      "@api.mailgun.net/v2/routes", data

    File.write MAILGUNNED, "Mailgunned at #{Time.now}"
  end

end
