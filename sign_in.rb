#!/usr/bin/env ruby
# encoding: utf-8
require 'cgi'
require 'sqlite3'

cgi = CGI.new
print cgi.header("text/html; charset=utf-8")

print <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Random Text Battle</title>
    <link rel="stylesheet" href="css/style.css">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
</head>
<body>
    <!-- NAVBAR CREATION -->
   <header class="header">
    <nav class="navbar">
        <a href="#">ホーム</a>
        <a href="#">ステータス</a>
          <a href="#">ランキング</a>
    </nav>
   </header>
    <!-- LOGIN FORM CREATION -->
    <div class="background"></div>
    <div class="container">
        <div class="item">
            <div class="text-item">
                <h3>これは LOGO</h3>
                <h2>ようこそ! <br><span>
                    ランダム・テキスト・バトルへ
                </span></h2>
                <p>スキル・武器の発動やテキストの生成などを全部ランダムにしている超ローコストの文字ゲーム　∠( ᐛ 」∠)＿</p>
            </div>
        </div>
        <div class="login-section">
            <div class="form-box login">
                <form action="./sign_in_middle.rb" method="POST">
                    <h2>サインイン</h2>
                    <div class="input-box">
                        <span class="icon"><i class='bx bxs-user-circle'></i></span>
                        <input type="text" name="name" required>
                        <label>キャラクターネーム</label>
                    </div>
                    <div class="input-box">
                        <span class="icon"><i class='bx bxs-lock-alt' ></i></span>
                        <input type="password" name="password" required>
                        <label>パスワード</label>
                    </div>
                    <button class="btn">ログイン</button>
                    <div class="create-account">
                        <p>まだアカウント持っていない？ <a href="sign_up.rb" class="register-link">新規登録</a></p>
                    </div>
                </form>
            </div>
        </div>
    </div>
     <!-- SIGN UP FORM CREATION -->
</body>

</html>
EOF

