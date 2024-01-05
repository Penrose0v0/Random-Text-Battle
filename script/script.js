// Variables
var prompt;
var displayList = [];  // input, response

// Print function
function print(content, end='<br>', location='output-container') {
  if (content == undefined) content = ''; 
  var container = document.getElementById(location);
  container.innerHTML += `${content}${end}`;
}

// Determine if one is dead
function is_finish() {
  if (character1.hp <= 0 || character2.hp <=0) {
      if (character1.hp <= 0) {
          var winner = character2; 
          var loser = character1; 
      } else {
          var winner = character1; 
          var loser = character2; 
      }
      generate_response(`${winner.name}が${loser.name}を討ち取った`); 
      return true; 
  } else if (idx >= idx_max) {
    generate_response(`${character1.name}と${character2.name}が引き分け`); 
    return true; 
  }
    return false; 
}

// Show HP at top of the page
function showHP() {
  var container = document.getElementById('hp-bar');
  container.innerHTML = character1.name + ': ' + Math.max(character1.hp, 0) + ' vs ' 
  + character2.name + ': ' + Math.max(character2.hp, 0);
}

// Init prompt
function init_prompt() {
  prompt = {
    model: 'gpt-3.5-turbo',
    messages: [
      {
        role: 'system',
        content: 
          `現在、文本の修辞が可能なロボットとして、武侠小説の文体を基に、与えられたテキストを元に原文を続けてください。
          ここで、対戦する二者の名前はそれぞれ${character1.name}と${character2.name}です。

          あなたがやるべきことは：
          1. 与えられたテキストを基に、誰が誰に対して何をしたか、そしてその結果は何かを描写してください。
          2. テキストを文脈とより関連性を持つようにしてください。
          3. 答えはできるだけ簡潔にする必要があります。
          4. もしもダメージを受けた場合は、与えられたテキストと一致するようにしてください。ダメージがある場合、その値も与えられたテキストと一致させる必要があります。


          やってはいけないことは：
          1. 同じ表現を再び生成しないでください。
          2. 技能や技を勝手に名前をつけないでください。
          3. 物語の展開を勝手に想像しないでください。
          4. 元のテキストや記録を繰り返さないでください。直接続けてください。
          5. 最初にの環境の描写は同じにしないでください。`
          
      },
    ], 
    temperature: 0.3, 
    // stream: true, 
  };
}

// Generate response
function generate_response(input) {
  prompt.messages.push({
    role: 'user', 
    content: input
  }); 
  console.log(prompt);

  // console.log(prompt); 

  fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${OPENAI_API_KEY}`
    },
    body: JSON.stringify(prompt)
  })
    .then(response => response.json())

    .then(data => {
      // Get data
      // console.log(prompt);
      var message = data.choices[0].message.content; 

      // Append response
      displayList.push({
        input: input, 
        response: message
      })

      // modify prompt
      // prompt.messages[0].content += message + '\n'; 
      // prompt.messages.pop(); 
      prompt.messages.push({
        role: 'assistant', 
        content: message
      })
    })

    .catch(error => {
      console.log(prompt)
      console.error('Error:', error);
  });
}

function realDamage(x, k) {
  return 35 * k / (1 + Math.exp(-0.1 * k * (x - 20 - 3 * (k - 1))))
}
// Weapons
function dragonSlayer(attack, defense) { 
  var x = attack[0]; 
  var k = 3; 
  var real_damage = realDamage(x, k); 
  prefix = `${attack.name}が屠龍刀を使用し`
  if (Math.random() < 3 / k * attack[2] / (attack[2] + defense[5])) {
      var damage = real_damage * 100 / (100 + defense[3]); 
      damage = Math.round(damage); 
      defense.hp -= damage; 
      content = `${defense.name}に${damage}のダメージを与えた`; 
  } else {
      content = `しかし${defense.name}に命中できなかった`
  }
  return prefix + '、' + content;
}

function crossCutter(attack, defense) {
  var x = attack[0]; 
  var k = 2; 
  var real_damage = realDamage(x, k); 
  prefix = `${attack.name}が十文字切りを使い`
  if (Math.random() < 3 / k * attack[2] / (attack[2] + defense[5])) {
      var damage = real_damage * 100 / (100 + defense[3]); 
      damage = Math.round(damage); 
      defense.hp -= damage; 
      content = `${defense.name}に${damage}のダメージを与えた`; 
  } else {
      content = `しかし${defense.name}に命中できなかった`
  }
  return prefix + '、' + content; 
}

function normalSlayer(attack, defense) { 
  var x = attack[0]; 
  var k = 1; 
  var real_damage = realDamage(x, k); 
  prefix = `${attack.name}が全力で斬撃し`
  if (Math.random() < 3 / k * attack[2] / (attack[2] + defense[5])) {
      var damage = real_damage * 100 / (100 + defense[3]); 
      damage = Math.round(damage); 
      defense.hp -= damage; 
      content = `${defense.name}に${damage}のダメージを与えた`; 
  } else {
      content = `しかし${defense.name}に命中できなかった`
  }
  return prefix + '、' + content; 
}

function heavenSword(attack, defense) {
  var x = attack[0]; 
  var k = 2.75; 
  var real_damage = realDamage(x, k); 
  prefix = `${attack.name}が倚天剑を振り`
  if (Math.random() < 3 / k * attack[2] / (attack[2] + defense[5])) {
      var damage = real_damage * 100 / (100 + defense[3]); 
      damage = Math.round(damage); 
      defense.hp -= damage; 
      content = `${defense.name}に${damage}のダメージを与えた`; 
  } else {
      content = `しかし${defense.name}に命中できなかった`
  }
  return prefix + '、' + content; 
}

function spear(attack, defense) {
  var x = attack[0]; 
  var k = 1.75; 
  var real_damage = realDamage(x, k); 
  prefix = `${attack.name}が長槍で素早く刺し`
  if (Math.random() < 3 / k * attack[2] / (attack[2] + defense[5])) {
      var damage = real_damage * 100 / (100 + defense[3]); 
      damage = Math.round(damage); 
      defense.hp -= damage; 
      content = `${defense.name}に${damage}のダメージを与えた`; 
  } else {
      content = `しかし${defense.name}に命中できなかった`
  }
  return prefix + '、' + content; 
}

function guillotine(attack, defense) {
  var x = attack[0]; 
  var k = 2.25; 
  var real_damage = realDamage(x, k); 
  prefix = `${attack.name}が断頭台の斧で切り`
  if (Math.random() < 3 / k * attack[2] / (attack[2] + defense[5])) {
      var damage = real_damage * 100 / (100 + defense[3]); 
      damage = Math.round(damage); 
      defense.hp -= damage; 
      defense[3] -= Math.round(0.2 * x); 
      content = `${defense.name}に${damage}のダメージを与え、「鎧」を下げた`; 
  } else {
      content = `しかし${defense.name}に命中できなかった`
  }
  return prefix + '、' + content; 
}

function sevenSins(attack, defense) {
  var x = attack[0]; 
  var k = 2.5; 
  var real_damage = realDamage(x, k); 
  prefix = `${attack.name}が七本の罪切りの剣で斬撃を放ち`
  if (Math.random() < 3 / k * attack[2] / (attack[2] + defense[5])) {
      var damage = real_damage * 100 / (100 + defense[3]); 
      damage = Math.round(damage); 
      defense.hp -= damage; 
      content = `${defense.name}に${damage}のダメージを与えた`; 
  } else {
      content = `しかし${defense.name}に命中できなかった`
  }
  return prefix + '、' + content; 
}

function kunai(attack, defense) {
  var x = attack[0]; 
  var k = 1.25; 
  var real_damage = realDamage(x, k); 
  prefix = `${attack.name}が苦無を投げ`
  if (Math.random() < 3 / k * attack[2] / (attack[2] + defense[5])) {
      var damage = real_damage * 100 / (100 + defense[3]); 
      damage = Math.round(damage); 
      defense.hp -= damage; 
      content = `${defense.name}に${damage}のダメージを与えた`; 
  } else {
      content = `しかし${defense.name}に命中できなかった`
  }
  return prefix + '、' + content; 
}

// Skills
function thunderSpell(attack, defense) {
  var x = attack[1]; 
  var k = 3; 
  var real_damage = realDamage(x, k); 
  prefix = `${attack.name}が雷を呼び`
  if (Math.random() < 3 / k * attack[2] / (attack[2] + defense[5])) {
      var damage = real_damage * 100 / (100 + defense[4]); 
      damage = Math.round(damage); 
      defense.hp -= damage; 
      content = `${defense.name}に${damage}のダメージを与えた`; 
  } else {
      content = `しかし${defense.name}に命中できなかった`
  }
  return prefix + '、' + content; 
}

function firePunch(attack, defense) {
  var x = attack[1]; 
  var k = 1; 
  var real_damage = realDamage(x, k); 
  prefix = `${attack.name}が炎拳で打ち`
  if (Math.random() < 3 / k * attack[2] / (attack[2] + defense[5])) {
      var damage = real_damage * 100 / (100 + defense[4]); 
      damage = Math.round(damage); 
      defense.hp -= damage; 
      content = `${defense.name}に${damage}のダメージを与えた`; 
  } else {
      content = `しかし${defense.name}に命中できなかった`
  }
  return prefix + '、' + content; 
}

function blizzard(attack, defense) {
  var x = attack[1]; 
  var k = 2.5; 
  var real_damage = realDamage(x, k); 
  prefix = `${attack.name}が吹雪を招き`
  if (Math.random() < 3 / k * attack[2] / (attack[2] + defense[5])) {
      var damage = real_damage * 100 / (100 + defense[4]); 
      damage = Math.round(damage); 
      defense.hp -= damage; 
      content = `${defense.name}に${damage}のダメージを与えた`; 
  } else {
      content = `しかし${defense.name}に命中できなかった`
  }
  return prefix + '、' + content; 
}

function avadaKedavra(attack, defense) {
  var x = attack[1]; 
  var k = 1; 
  var real_damage = realDamage(x, k); 
  prefix = `${attack.name}が禁忌の索命呪を打ち`
  if (Math.random() < 0.05 || x >= 35) {
      var damage = 9999; 
      damage = Math.round(damage); 
      defense.hp -= damage; 
      content = `${defense.name}の命を奪った`; 
  } else {
      content = `しかし無効果だった`
  }
  return prefix + '、' + content; 
}

function cyclone(attack, defense) {
  var x = attack[1]; 
  var k = 1.5; 
  var real_damage = realDamage(x, k); 
  prefix = `${attack.name}が狂風を吹き`
  if (Math.random() < 3 / k * attack[2] / (attack[2] + defense[5])) {
      var damage = real_damage * 100 / (100 + defense[4]); 
      damage = Math.round(damage); 
      defense.hp -= damage; 
      content = `${defense.name}に${damage}のダメージを与えた`; 
  } else {
      content = `しかし${defense.name}に命中できなかった`
  }
  return prefix + '、' + content; 
}

function flash(attack, defense) {
  var x = attack[1]; 
  prefix = `${attack.name}が閃光になり`
  attack[5] += Math.round(0.2 * x); 
  content = `「避」を上げた`
  return prefix + '、' + content; 
}
