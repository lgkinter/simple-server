require 'socket'
require 'json'

host = 'localhost'
port = 2000
index_path = "./index.html"
thanks_path = "./thanks.html"

print "Which type of request would you like to send? Type 'GET' or 'POST': "
request_type = gets.chomp.upcase!
if request_type == "POST"
  print "What your viking's name? "
  name = gets.chomp
  print "What is your viking's email address? "
  email = gets.chomp
  params = Hash.new
  params[:viking] = {:name => name, :email => email}
  json_viking = params[:viking].to_json
  request = %Q(
  POST #{thanks_path} HTTP/1.0\r\n
  From: #{email}\r\n
  Content-Length: #{json_viking.size}\r\n\r\n
  #{json_viking}\r\n\r\n
  )
else
  request = "GET #{index_path} HTTP/1.0\r\n\r\n"
end

socket = TCPSocket.open(host, port)
socket.print(request)     # Send request
response = socket.read    # Read response
headers,body = response.split("\r\n\r\n", 2)
puts headers =~ (/200 OK/) ? body : headers

socket.close
