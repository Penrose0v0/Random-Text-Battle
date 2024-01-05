#!/usr/bin/env ruby
# encoding: utf-8
require 'cgi'
require 'sqlite3'

cgi = CGI.new
print cgi.header("text/html; charset=utf-8")

name = cgi.params["name"][0]
password = cgi.params["password"][0]

ad = cgi.params["ad"][0].to_i
ap = cgi.params["ap"][0].to_i
hit = cgi.params["hit"][0].to_i
armour = cgi.params["armour"][0].to_i
resist = cgi.params["resist"][0].to_i
dodge = cgi.params["dodge"][0].to_i

w1, w2, w3, w4, w5 = cgi.params["weapons"][0].split(',')
s1, s2, s3, s4, s5 = cgi.params["skills"][0].split(',')

db = SQLite3::Database.new("../local_only/wp/game.db")
db.execute("INSERT INTO character VALUES(?, ?, 0, 0, 0, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?); ", name, password, ad, ap, hit, armour, resist, dodge, w1, w2, w3, w4, w5, s1, s2, s3, s4, s5)
db.close

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
        window.location.href = "./sign_in.rb";
    }, 0);
</script>

</html>
EOF

