#!/usr/bin/env ruby
# encoding: utf-8
require 'cgi'
require 'sqlite3'

cgi = CGI.new

name = cgi.params["name"][0]
password = cgi.params["password"][0]

db = SQLite3::Database.new("../local_only/wp/game.db")
result = db.get_first_value("SELECT COUNT(*) FROM character WHERE name=? AND password=?", name, password)
db.close

html_msg = ""
redirect_page = ""
wait_time = 0
if result.to_i > 0
    new_cookie = CGI::Cookie
    new_cookie = CGI::Cookie.new("name" => "name", "value" => name.to_s)
    redirect_page = "./home.rb"
    print cgi.header("type" => "text/html", "charset" => "utf-8", "cookie" => [new_cookie])
else
    html_msg += "<p>Characer name or password wrong. Login in failed. Please try again. </p><br>"
    html_msg += "<p>Redirecting back to login page in 3 seconds...</p>"
    redirect_page = "./sign_in.rb"
    wait_time = 3000
    print cgi.header("text/html; charset=utf-8")
end

print <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Random Text Battle</title>
    <link rel="stylesheet" href="css/style.css">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
</head>
<body>
    #{html_msg}
</body>
<script>
      setTimeout(function() {
        window.location.href = "#{redirect_page}";
}, #{wait_time});
    </script>
</html>
EOF

