#!/usr/bin/env ruby
# encoding: utf-8
require 'cgi'
require 'sqlite3'

cgi = CGI.new
print cgi.header("text/html; charset=utf-8")
cookies = cgi.cookies
name = cookies["name"][0]

ad = cgi.params["ad"][0].to_i
ap = cgi.params["ap"][0].to_i
hit = cgi.params["hit"][0].to_i
armour = cgi.params["armour"][0].to_i
resist = cgi.params["resist"][0].to_i
dodge = cgi.params["dodge"][0].to_i

w1, w2, w3, w4, w5 = cgi.params["weapons"][0].split(',')
s1, s2, s3, s4, s5 = cgi.params["skills"][0].split(',')
begin
db = SQLite3::Database.new("../local_only/wp/game.db")
db.execute("UPDATE character SET ad=?, ap=?, hit=?, armour=?, resist=?, dodge=?, w1=?, w2=?, w3=?, w4=?, w5=?, s1=?, s2=?, s3=?, s4=?, s5=? WHERE name LIKE ?", ad, ap, hit, armour, resist, dodge, w1, w2, w3, w4, w5, s1, s2, s3, s4, s5, name)
db.close
rescue => ex
    puts ex.message
    puts ex.backtrace
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
</body>
<script>
    setTimeout(function() {
        window.location.href = "./home.rb";
    }, 0);
</script>

</html>
EOF

