require 'socket'
require 'json'

server = TCPServer.open(2000)
loop do
  client = server.accept
  #request = client.read
  request = client.read_nonblock(200)
  request_headers,request_body = request.split("\r\n\r\n", 2)
  method = request_headers.split(' ')[0]
  path = request_headers.split(' ')[1]
  http_version = request_headers.split(' ')[2]

  if File.exist?(path)
    response_headers = "#{http_version} 200 OK\r\n\r\n"
    if method == "POST"
      params = Hash.new
      params = JSON.parse(request_body)
      response_body = File.read(path).gsub("<%= yield %>", "<li>Name: #{params['name']}</li><li>Email: #{params['email']}</li>")
    else
      response_body = File.read(path)
    end
  else
    response_headers = "#{http_version} 400 Not Found\r\n\r\n"
  end
  client.puts response_headers
  client.puts response_body
  client.close
end
