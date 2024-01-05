#!/usr/bin/env ruby
# encoding: utf-8
require 'cgi'
require 'sqlite3'

cgi = CGI.new
print cgi.header("text/html; charset=utf-8")
cookies = cgi.cookies
name = cookies["name"][0]


db = SQLite3::Database.new("../local_only/wp/game.db")
info = db.execute("SELECT * FROM character WHERE name LIKE ?", name)[0]
name, pw, win, lose, draw, ad, ap, hit, armour, resist, dodge, w1, w2, w3, w4, w5, s1, s2, s3, s4, s5 = info
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
        <a href="home.html">ホーム</a>
        <a href="modify_character.rb">ステータス</a>
        <a href="ranking.rb">ランキング</a>
    </nav>
    <button class="logout-btn" onclick="clearAllCookies()">ログアウト</button>
   </header>
    <!-- LOGIN FORM CREATION -->
    <div class="background"></div>
    <div class="home-container">
        <div class="item">
            <div class="text-item">
                <h3>これはホームページ</h3>
                <h2>こんにちは! #{name}</h2>
                <p><strong>「ランキング」</strong>でバトルの相手を探しましょう！</p>
            </div>
        </div>
        <div class="status">
            <div class="status-item">
                <h1>プロパティ</h1>
                <div class="show-attribute">
                    <div class="attack-attribute">
                        <div>
                            <i class='bx bx-knife'></i>
                            <span>力（物理パワー）: </span>
                            <span id="attack-damage">#{ad}</span>
                        </div>
                        <div>
                            <i class='bx bxs-magic-wand' ></i>
                            <span>魔（魔法パワー）: </span>
                            <span id="ability-power">#{ap}</span>
                        </div>
                        <div>
                            <i class='bx bx-cross' ></i>
                            <span>準（命中率）: </span>
                            <span id="hit-rate">#{hit}</span>
                        </div>
                    </div>
                    <div class="defense-attribute">
                        <div>
                            <i class='bx bx-shield-plus' ></i>
                            <span>鎧（物理抵抗）: </span>
                            <span id="armour">#{armour}</span>
                        </div>
                        <div>
                            <i class='bx bxs-shield-plus' ></i>
                            <span>感（魔法抵抗）: </span>
                            <span id="magic-resist">#{resist}</span>
                        </div>
                        <div>
                            <i class='bx bx-run' ></i>
                            <span>避（回避率）: </span>
                            <span id="dodge-rate">#{dodge}</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="status-item">
                <h1>武器</h1>
                <div class="show-weapon">
                    <span>#{w1}</span><br>
                    <span>#{w2}</span><br>
                    <span>#{w3}</span><br>
                    <span>#{w4}</span><br>
                    <span>#{w5}</span><br>
                </div>
            </div>

            <div class="status-item">
                <h1>スキル</h1>
                <div class="show-skill">
                    <span>#{s1}</span><br>
                    <span>#{s2}</span><br>
                    <span>#{s3}</span><br>
                    <span>#{s4}</span><br>
                    <span>#{s5}</span><br>
                </div>
            </div>
        </div>
    </div>
     <!-- SIGN UP FORM CREATION -->
</body>

</html>
EOF

