#!/usr/bin/env ruby
# encoding: utf-8
require 'cgi'
require 'sqlite3'

cgi = CGI.new
print cgi.header("text/html; charset=utf-8")
begin
draw = cgi.params["draw"][0]
winner = cgi.params["winner"][0]
loser = cgi.params["loser"][0]

db = SQLite3::Database.new("../local_only/wp/game.db")
if draw.to_i == 1
    c1_draw = db.execute("SELECT draw FROM character WHERE name LIKE ?", winner)[0][0]
    db.execute("UPDATE character SET draw=? WHERE name LIKE ?", c1_draw + 1, winner)
    c2_draw = db.execute("SELECT draw FROM character WHERE name LIKE ?", loser)[0][0]
    db.execute("UPDATE character SET draw=? WHERE name LIKE ?", c2_draw + 1, loser)
else
    winner_win = db.execute("SELECT win FROM character WHERE name LIKE ?", winner)[0][0]
    db.execute("UPDATE character SET win=? WHERE name LIKE ?", winner_win + 1, winner)
    loser_lose = db.execute("SELECT lose FROM character WHERE name LIKE ?", loser)[0][0]
    db.execute("UPDATE character SET lose=? WHERE name LIKE ?", loser_lose + 1, loser)
end
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
        window.location.href = "./ranking.rb";
    }, 0);
</script>
</html>
EOF

rescue => ex
    puts ex.message
    puts ex.backtrace
end

