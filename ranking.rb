#!/usr/bin/env ruby
# encoding: utf-8
require 'cgi'
require 'sqlite3'

cgi = CGI.new
print cgi.header("text/html; charset=utf-8")
cookies = cgi.cookies
cookie_name = cookies["name"][0]

db = SQLite3::Database.new("../local_only/wp/game.db")
characters = db.execute("SELECT name, win, lose, draw FROM character ORDER BY win DESC")
user_info = ""
count = 0

characters.each { |character| 
    count += 1
    name, win, lose, draw = character
    user_info += '<div class="user-info">'
    user_info += '<p class="rank">' + count.to_s + '</p>'
    user_info += '<p class="id">' + name + '</p>'
    user_info += '<p class="win">' + win.to_s + '</p>'
    user_info += '<p class="lose">' + lose.to_s + '</p>'
    user_info += '<p class="draw">' + draw.to_s + '</p>'
    if name == cookie_name
        user_info += '<p class="challenge">自分に挑戦できない</p>'
    else
      user_info += '<a href="./battle.rb?rival=' + name + '" class="challenge">挑戦する</a>'
    end
    user_info += '</div>'
}
db.close


print <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Random Text Battle</title>
    <link rel="stylesheet" href="css/style.css">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
</head>
<script>
    function clearAllCookies() {
      document.cookie = "name=0; expires=Fri, 31 Dec 9999 23:59:59 GMT; path=/~s2213034/wp/";
      document.cookie = "password=0; expires=Fri, 31 Dec 9999 23:59:59 GMT; path=/~s2213034/wp/";
      setTimeout(function() {
        clearAllCookies(); 
        window.location.href = "./sign_in.rb";
    }, 0);
    }
</script>
<body>
    <!-- NAVBAR CREATION -->
   <header class="header">
    <nav class="navbar">
        <a href="home.rb">ホーム</a>
        <a href="modify_character.rb">ステータス</a>
        <a href="ranking.rb">ランキング</a>
    </nav>
    <button class="logout-btn" onclick="clearAllCookies()">ログアウト</button>
   </header>
    <!-- LOGIN FORM CREATION -->
    <div class="background"></div>
    <div class="ranking">
        <strong>
            <div class="user-info">
                <p class="rank">順位</p>
                <p class="id">ユーザネーム</p>
                <p class="win">勝ち</p>
                <p class="lose">負け</p>
                <p class="draw">引き分け</p>
            </div>
        </strong>
        #{user_info}
    </div>
     <!-- SIGN UP FORM CREATION -->
</body>

</html>
EOF

