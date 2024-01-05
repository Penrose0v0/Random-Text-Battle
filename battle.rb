#!/usr/bin/env ruby
# encoding: utf-8
require 'cgi'
require 'sqlite3'

cgi = CGI.new
print cgi.header("text/html; charset=utf-8")
begin
# Get openai API key
file = open("../local_only/wp/api_key.txt", "r:UTF-8")
api_key = CGI.escapeHTML(file.read)
file.close

cookies = cgi.cookies
c1_name = cookies["name"][0]
c2_name = cgi.params["rival"][0]

# Get attributions
db = SQLite3::Database.new("../local_only/wp/game.db")
attr1 = db.execute("SELECT ad, ap, hit, armour, resist, dodge FROM character WHERE name LIKE ?", c1_name)[0]
ad1, ap1, hit1, armour1, resist1, dodge1 = attr1
attr2 = db.execute("SELECT ad, ap, hit, armour, resist, dodge FROM character WHERE name LIKE ?", c2_name)[0]
ad2, ap2, hit2, armour2, resist2, dodge2 = attr2

# Get weapons
wfunc1 = Array.new
weapons1 = db.execute("SELECT w1, w2, w3, w4, w5 FROM character WHERE name LIKE ?", c1_name)[0]
weapons1.each do |weapon1|
    wfunc = db.execute("SELECT wfunc FROM weapon WHERE wname LIKE?", weapon1)[0][0]
    wfunc1.push(wfunc)
end
c1w1, c1w2, c1w3, c1w4, c1w5 = wfunc1

wfunc2 = Array.new
weapons2 = db.execute("SELECT w1, w2, w3, w4, w5 FROM character WHERE name LIKE ?", c2_name)[0]
weapons2.each do |weapon2|
    wfunc = db.execute("SELECT wfunc FROM weapon WHERE wname LIKE?", weapon2)[0][0]
    wfunc2.push(wfunc)
end
c2w1, c2w2, c2w3, c2w4, c2w5= wfunc2

# Get skills
sfunc1 = Array.new
skills1 = db.execute("SELECT s1, s2, s3, s4, s5 FROM character WHERE name LIKE ?", c1_name)[0]
skills1.each do |skill1|
    sfunc = db.execute("SELECT sfunc FROM skill WHERE sname LIKE?", skill1)[0][0]
    sfunc1.push(sfunc)
end
c1s1, c1s2, c1s3, c1s4, c1s5 = sfunc1

sfunc2 = Array.new
skills2 = db.execute("SELECT s1, s2, s3, s4, s5 FROM character WHERE name LIKE ?", c2_name)[0]
skills2.each do |skill2|
    sfunc = db.execute("SELECT sfunc FROM skill WHERE sname LIKE?", skill2)[0][0]
    sfunc2.push(sfunc)
end
c2s1, c2s2, c2s3, c2s4, c2s5 = sfunc2

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
    <div class="battle">
        <div id="hp-bar"></div>
        <div id="output-container"></div>
    </div>
    <div style="display: flex; justify-content: center; align-items: center; margin: 75px 0; position: absolute; width: 100%; bottom: 0; ">
        <button id="back-to-ranking" 
        onclick="back2ranking('./game_over.rb')" 
        style="padding: 10px 20px; background-color: #000; border-radius: 10px; border-color: transparent; color: #fff; font-size: 18px; cursor: pointer; display: none">
        ランキングに戻る
        </button>
    </div>
     <!-- SIGN UP FORM CREATION -->
</body>
<script>const OPENAI_API_KEY = '#{api_key}'; </script>
<script type="text/javascript" src="script/script.js"></script>
<script>
    // ----- Ruby -----
    var character1 = [#{ad1}, #{ap1}, #{hit1}, #{armour1}, #{resist1}, #{dodge1}]  // 力 知 准 铠 感 避
    character1['hp'] = Math.round(100 * (1 + (character1[3] + character1[4] + character1[5] - 15) / 15)); 
    character1['name'] = '#{c1_name}'; 
    var character2 = [#{ad2}, #{ap2}, #{hit2}, #{armour2}, #{resist2}, #{dodge2}] // 力 知 准 铠 感 避
    character2['hp'] = Math.round(100 * (1 + (character2[3] + character2[4] + character2[5] - 15) / 30)); 
    character2['name'] = '#{c2_name}'; 
    
    var functionsArray1 = [#{c1w1}, #{c1w2}, #{c1w3}, #{c1w4}, #{c1w5}, #{c1s1}, #{c1s2}, #{c1s3}, #{c1s4}, #{c1s5}];
    var functionsArray2 = [#{c2w1}, #{c2w2}, #{c2w3}, #{c2w4}, #{c2w5}, #{c2s1}, #{c2s2}, #{c2s3}, #{c2s4}, #{c2s5}];
    var functionsArray = [functionsArray1, functionsArray2]; 
    // ----- Ruby -----

    init_prompt(); 
    
    var idx = 0; 
    var idx_max = 10; 
    var characters = [character1, character2]
    var finish = false; 

    function display() {
        if (idx == 0) return; 
         
        var input = displayList[idx-1].input; 
        var response = displayList[idx-1].response; 

        print('<br>'); 
        print(`（${input}）`, end=''); 

        n = 0; 
        var stream = setInterval(function() {
            if (n < response.length) {
                print(`${response[n++]}`, end=''); 
            }
            if (n == response.length) {
                clearInterval(stream); 
                // print('<br>'); 
            }
        }, 100)
        showHP(); 

        if (finish) return -1;
        return response.length; 
    }

    function oneRound() {
        // Wait for response
        if (displayList.length < idx) {
            clearInterval(battle);
            battle = setInterval(oneRound, 100); 
            return; 
        }

        // Display on the screen
        var len = display(); 

        // Determine if game is over
        finish = is_finish(); 
        if (finish) {
            idx++; 
            clearInterval(battle);
            
            if (len != -1) 
                battle = setInterval(oneRound, len * 100); 
            else {
                var button = document.getElementById("back-to-ranking")
                button.style.display = 'inline'; 
            }

            return; 
        }

        // Set waiting time to the next round
        clearInterval(battle);
        battle = setInterval(oneRound, len * 100 + 500); 

        // Core of the battle
        var attack = characters[idx%2]; 
        var defence = characters[1-idx%2]

        var randomIndex = Math.floor(Math.random() * functionsArray[idx%2].length);
        var input = functionsArray[idx%2][randomIndex](attack, defence);
        generate_response(input);
        console.log(character1, character2); 

        idx++; 
    }
    var battle = setInterval(oneRound, 10); 

    function postForm(url, data) {
        var form = document.createElement("form");
        form.setAttribute("method", "get");
        form.setAttribute("action", url);

        for (var key in data) {
            if (data.hasOwnProperty(key)) {
                var input = document.createElement("input");
                input.setAttribute("type", "hidden");
                input.setAttribute("name", key);
                input.setAttribute("value", data[key]);
                form.appendChild(input);
            }
        }

        document.body.appendChild(form);
        form.submit();
    }


    function back2ranking(url) {
        var draw = '0'; 
        var winner = '0'; 
        var loser = '0'; 
        if (character1.hp <= 0) {
            winner = character2.name
            loser = character1.name
        } else if (character2.hp <= 0) {
            winner = character1.name
            loser = character2.name
        } else {
            draw = '1'; 
            winner = character1.name
            loser = character2.name
        }

        var data = {'draw':draw, 'winner':winner, 'loser':loser}
        postForm(url, data); 
    }
</script>
</html>
EOF

rescue => ex
    puts ex.message
    puts ex.backtrace
end
