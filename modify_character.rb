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
weapons = db.execute("SELECT wname FROM weapon")
skills = db.execute("SELECT sname FROM skill")
db.close


weapon_msg = ""
weapons.each {|weapon|
    if weapon[0] == w1 || weapon[0] == w2 || weapon[0] == w3 || weapon[0] == w4 || weapon[0] == w5
        weapon_msg += '<input type="checkbox" name="weapon" value="' + weapon[0] + '" checked="checked"> ' + weapon[0] + '<br>'
    else
        weapon_msg += '<input type="checkbox" name="weapon" value="' + weapon[0] + '"> ' + weapon[0] + '<br>'
    end
}
skill_msg = ""
skills.each {|skill|
    if skill[0] == s1 || skill[0] == s2 || skill[0] == s3 || skill[0] == s4 || skill[0] == s5
        skill_msg += '<input type="checkbox" name="skill" value="' + skill[0] + '" checked="checked"> ' + skill[0] + '<br>'
    else
        skill_msg += '<input type="checkbox" name="skill" value="' + skill[0] + '"> ' + skill[0] + '<br>'
    end
}
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
        <a href="./home.rb">ホーム</a>
        <a href="./modify_character.rb">ステータス</a>
        <a href="./ranking.rb">ランキング</a>
    </nav>
    <button class="logout-btn" onclick="clearAllCookies()">ログアウト</button>
</header>
    <!-- LOGIN FORM CREATION -->
    <div class="background"></div>
    <div class="character">
        <div style="display: flex; justify-content: center; align-items: center;">
            <h1>キャラクター変更</h1>
        </div>
        <div class="attribute">
            <h2 style="display: flex; justify-content: center; align-items: center;">プロパティ</h2>
            <div class="attribute-items">
                <div class="attribute-item">
                    <div>
                        <i class='bx bx-knife'></i>
                        <span>力（物理パワー）: </span>
                        <span id="ad">#{ad}</span>
                    </div>
                    <div>
                        <button onclick="increaseAttribute('ad')">+</button>
                        <button onclick="decreaseAttribute('ad')">-</button>
                    </div>
                </div>
                <div class="attribute-item">
                    <div>
                        <i class='bx bxs-magic-wand' ></i>
                        <span>魔（魔法パワー）: </span>
                        <span id="ap">#{ap}</span>
                    </div>
                    <div>
                        <button onclick="increaseAttribute('ap')">+</button>
                        <button onclick="decreaseAttribute('ap')">-</button>
                    </div>
                </div>
                <div class="attribute-item">
                    <div>
                        <i class='bx bx-cross' ></i>
                        <span>準（命中率）: </span>
                        <span id="hit">#{hit}</span>
                    </div>
                    <div>
                        <button onclick="increaseAttribute('hit')">+</button>
                        <button onclick="decreaseAttribute('hit')">-</button>
                    </div>
                </div>
                <div class="attribute-item">
                    <div>
                        <i class='bx bx-shield-plus' ></i>
                        <span>鎧（物理抵抗）: </span>
                        <span id="armour">#{armour}</span>
                    </div>
                    <div>
                        <button onclick="increaseAttribute('armour')">+</button>
                        <button onclick="decreaseAttribute('armour')">-</button>
                    </div>
                </div>
                <div class="attribute-item">
                    <div>
                        <i class='bx bxs-shield-plus' ></i>
                        <span>感（魔法抵抗）: </span>
                        <span id="resist">#{resist}</span>
                    </div>
                    <div>
                        <button onclick="increaseAttribute('resist')">+</button>
                        <button onclick="decreaseAttribute('resist')">-</button>
                    </div>
                </div>
                <div class="attribute-item">
                    <div>
                        <i class='bx bx-run' ></i>
                        <span>避（回避率）: </span>
                        <span id="dodge">#{dodge}</span>
                    </div>
                    <div>
                        <button onclick="increaseAttribute('dodge')">+</button>
                        <button onclick="decreaseAttribute('dodge')">-</button>
                    </div>
                </div>
            </div>
            <br>
            <div>残りの点数: <span id="totalPoints">0</span></div>
        </div>
        <div class="tool">
            <div class="weapons">
                <h2 style="display: flex; justify-content: center; align-items: center;">武器</h2>
                <form class="tool-form" id="weapon-form">
                    #{weapon_msg}
                </form>
                <div class="weapon-item"></div>
            </div>
            <div class="skills">
                <h2 style="display: flex; justify-content: center; align-items: center;">スキル</h2>
                <form class="tool-form" id="skill-form">
                    #{skill_msg}
                </form>
            </div>
        </div>
    </div>
    <button id="complete-character" onclick="doPost('./modify_character_middle.rb')">変更を完了する</button>
    <!-- SIGN UP FORM CREATION -->

    <script>
        function increaseAttribute(attributeId) {
            var attributeElement = document.getElementById(attributeId);
            var totalPointsElement = document.getElementById('totalPoints');
    
            if (parseInt(totalPointsElement.textContent) > 0) {
                attributeElement.textContent = parseInt(attributeElement.textContent) + 1;
                totalPointsElement.textContent = parseInt(totalPointsElement.textContent) - 1;
            }
        }
    
        function decreaseAttribute(attributeId) {
            var attributeElement = document.getElementById(attributeId);
            var totalPointsElement = document.getElementById('totalPoints');
    
            if (parseInt(attributeElement.textContent) > 5) {
                attributeElement.textContent = parseInt(attributeElement.textContent) - 1;
                totalPointsElement.textContent = parseInt(totalPointsElement.textContent) + 1;
            }
        }

        var maxSkills = 5;
        var selectedSkills = ['#{s1}', '#{s2}', '#{s3}', '#{s4}', '#{s5}'];

        document.getElementById('skill-form').addEventListener('change', function (event) {
            var checkbox = event.target;

            if (checkbox.type === 'checkbox' && checkbox.name === 'skill') {
                if (checkbox.checked) {
                    // 添加到已选技能列表
                    if (selectedSkills.length < maxSkills && !selectedSkills.includes(checkbox.value)) {
                        selectedSkills.push(checkbox.value);
                    } else {
                        alert("max");
                        checkbox.checked = false;
                    }
                } else {
                    // 从已选技能列表中移除
                    var skillIndex = selectedSkills.indexOf(checkbox.value);
                    if (skillIndex !== -1) {
                        selectedSkills.splice(skillIndex, 1);
                    }
                }
            }
        });

        var maxWeapons = 5;
        var selectedWeapons = ['#{w1}', '#{w2}', '#{w3}', '#{w4}', '#{w5}'];

        document.getElementById('weapon-form').addEventListener('change', function (event) {
            var checkbox = event.target;
            console.log(selectedWeapons)

            if (checkbox.type === 'checkbox' && checkbox.name === 'weapon') {
                if (checkbox.checked) {
                    // 添加到已选技能列表
                    if (selectedWeapons.length < maxWeapons && !selectedWeapons.includes(checkbox.value)) {
                        selectedWeapons.push(checkbox.value);
                    } else {
                        alert("max");
                        checkbox.checked = false;
                    }
                } else {
                    // 从已选技能列表中移除
                    var skillIndex = selectedWeapons.indexOf(checkbox.value);
                    if (skillIndex !== -1) {
                        selectedWeapons.splice(skillIndex, 1);
                    }
                }
            }
        });

        function postForm(url, data) {
            var form = document.createElement("form");
            form.setAttribute("method", "post");
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


        function doPost(url) {
            var restPoints = document.getElementById('totalPoints').textContent;
            if (restPoints != 0 || selectedWeapons.length != maxWeapons || selectedSkills.length != maxSkills) {
                alert("Not completed yet"); 
                return; 
            }
            var ad = document.getElementById("ad").textContent;
            var ap = document.getElementById("ap").textContent;
            var hit = document.getElementById("hit").textContent;

            var armour = document.getElementById("armour").textContent;
            var resist = document.getElementById("resist").textContent;
            var dodge = document.getElementById("dodge").textContent;

            var data = {'ad':ad, 'ap':ap, 'hit':hit, 'armour':armour, 'resist':resist, 'dodge':dodge, 'weapons':selectedWeapons, 'skills':selectedSkills}; 
            postForm(url, data); 
        }
    </script>
</body>

</html>
EOF