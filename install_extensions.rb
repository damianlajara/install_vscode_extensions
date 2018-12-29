require 'net/http'
require 'json'

def color_text(color_code, text)
  "\e[#{color_code}m#{text}\e[0m"
end

def print_success_msg(msg)
  green_code = 32
  puts color_text(green_code, msg)
end

def print_error_msg(msg)
  red_code = 31
  puts color_text(red_code, msg)
end

def display_failed_plugins(plugins)
  length = plugins.length
  return if length == 0
  print_error_msg "\nLooks like #{length} extension(s) failed to install.\nRetry downloading each extension manually"
  puts "\nFailed Extensions:\n~~~~~~~~~~~~~~~~~~\n\n"
  plugins.each { |f| puts f }
end

def install_plugins(plugins = [])
  if plugins.length == 0
    print_error_msg "Woah! Looks like you have no extensions to install"
    return
  end
  failed = []
  plugins.each do |plugin|
    puts "Installing #{plugin}..."
    if(system 'code --install-extension #{plugin}')
      print_success_msg "Successfully installed #{plugin}"
    else
      print_error_msg "Failed installing #{plugin}"
      failed.push(plugin)
    end
  end
  print_success_msg "\nSuccessfully installed #{plugins.length - failed.length} extensions!"
  display_failed_plugins(failed)
end

def get_extensions(response_body)
  exts = extract_extensions(response_body)
  exts.map { |ext| "#{ext['publisher']}.#{ext['name']}" }
end

def extract_extensions(response_body)
  body = JSON.parse(response_body)
  JSON.parse(body['files']['extensions.json']['content'])
end

def validate_args
  if ARGV.length < 1 || ARGV.length > 1
    print_error_msg "You are missing some parameters...\nYou need to enter the gist ID. E.g: `ruby ./install_exstensions.rb <GIST_ID>`"
    return false
  end
  true
end

def run
  return unless validate_args

  uri = URI("https://api.github.com/gists/#{ARGV[0]}")

  request = Net::HTTP::Get.new(uri.request_uri)

  response = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => true) do |http|
    http.request(request)
  end

  if response.code == '200'
    print_success_msg "Success! Found gist\n"
    install_plugins get_extensions(response.body)
  else
    print_error_msg "Failed fetching '#{uri.path}'"
  end
end

# Start App
run