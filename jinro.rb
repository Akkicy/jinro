#!/usr/bin/env ruby
# coding: utf-8

citizen = 0
all = Hash.new
yaku = []
shoku = []
n = 1
m = 1
l = 1
r = 1
j = 1
i = 1
require 'pstore'
db = PStore.new("hash.db")
require 'cgi'
c = CGI.new(:accept_charset => 'utf-8')

page = {
  "1" => "今回人狼に参加する人の人数を入力して下さい。",
  "2" => "参加者の名前を入力してください。",
  "3" => "あなたの役職は?",
  "4" => "みなさん確認しましたか?",
  "5" => "それでは相談時間です。自由に話し合ってください。",
  "6" => "投票時間となりました。",
  "7" => "恐ろしい夜がやってきました。",
  "8" => "結果発表",
}
p = c["page"]
if p == ""
  p = "1"				# page変数指定がなければ "1" とする
end
people = c["people"].to_i
name = c["name"]
jinro = c["jinro"].to_i
uranai = c["uranai"].to_i
#a = c["neta"].to_i
n = c["n"].to_i
m = c["m"].to_i
l = c["l"].to_i
j = c["j"].to_i
i = c["i"].to_i
selector = c["selector"].to_i
#r = c["r"]
#allmenmber = c["all"]
#point = 0

puts "Content-type: text/html; charset=utf-8

<!DOCTYPE html>
<html>
<head><title>人狼ゲーム #{p}</title>
<style type=\"text/css\">
<!--
body{background-image: url(jinro2.png);}
span{font-family: serif;}
h1{background-color: white; color: black; font-weight: bold;}
form{background-color: white;}
 -->
</style>
</head>
<body>
<h1>Are You a Werewolf? Page#{p}</h1>
<form method=\"POST\" action=\"jinro.rb\">"

# ページ番号による切り替え処理
case p
when "1"
  nextpage = "2"
when "2"
  nextpage = "3"
when "3"
  case m
  when 0..people - 2
    nextpage = "3"
  when people - 1
    nextpage = "4"
  end 
when "4"
  nextpage = "5"
when "5"
  nextpage = "6"
when "6"
  case j
  when  0..people - 2
    nextpage = "5"
  when people - 1
    nextpage = "7"
  end
when "7"
  nextpage = "8"
when "8"
  nextpage = nil
end

if nextpage
  if p == "1"
    puts('<p>参加人数: 
     <select name="people">
     <option>6</option>
     <option>7</option>
     <option>8</option>
     <option>9</option>
     <option>10</option>
     </select><br><br>
<p>占い師の人数: 
     <select name="uranai">
     <option>1</option>
     <option>2</option>
     <option>3</option>
     </select><br><br>
<p>人狼の人数: 
     <select name="jinro">
     <option>1</option>
     <option>2</option>
     </select><br><br>
<input type="submit" value="決定">
<input type="reset" value="reset"><br></p>')
    
  elsif p == "2"
    printf("<input type=\"hidden\" name=\"jinro\" value=\"%d\">\n", jinro)
    printf("<input type=\"hidden\" name=\"uranai\" value=\"%d\">\n", uranai)
    printf("<input type=\"hidden\" name=\"people\" value=\"%d\">\n", people)

    #printf("people=%d",people)
    for e in 1..uranai
      yaku.push("uranai")
    end
    for w in 1..jinro
      yaku.push("jinro")
    end
    citizen = people - yaku.length
    for q in 1..citizen
      yaku.push("citizen")
    end
    shoku = yaku.sample(people+1)
    for r in 1..people
      all.store(r,shoku[r-1])
      db.transaction do
        db["all"] = db["all"] ||= Hash.new
        db["all"] = all
      end
    end
    #printf("%s",all)
    #printf("%s",yaku)
    printf("<p>%d人でゲームをスタートします。</p>プレイヤーは1人目からplayer1,player2,..です。<br>",people)
    puts('<input type="submit" value="次へ">')    
  elsif p == "3"
    printf("<input type=\"hidden\" name=\"people\" value=\"%d\">\n", people)
    #printf("people=%d",people)
    db.transaction do
      all = db["all"]
    end
    #printf("%s",all)
    #for r in 0..people
    open("work.html","w+") do |output|          #openでwork.htmlを作成する
      output.puts "<!DOCTYPE html>
<html>
<head><title>your work</title></head>
<body>"
      output.printf("<p>あなたの役職は%sです</p>",all[m+1])
      output.puts "</body>
</html>"
    end                                         #openのend
    puts("<p>役職を発表します。</p>")
    printf("<p>あなたはplayer%dさんですね?<br>よろしい場合のみ、【役職発表】を押して下さい。</p><br>",m + 1)
    puts "<a href=\"work.html\">役職発表</a><br><br>"
    m += 1
    printf("<input type=\"hidden\" name=\"m\" value=\"%d\">\n", m)
    puts('<input type="submit" value="次へ">')
    
    
  elsif p == "4"
    printf("<input type=\"hidden\" name=\"people\" value=\"%d\">\n", people)
    #printf("people=%d",people)
    puts "<p>これから3分間の話し合いを行ってもらいます。</p>"
    #start = Time.now.to_i
    #while true
    puts "<p>では始めて下さい。</p><p>話し合いが終わったら【次へ】をクリックして下さい。</p>"
    puts('<input type="submit" value="次へ">')    
    #if start > 10
    #puts "時間切れです"
    #break
    #end
    #end

  elsif p == "5"
    printf("<input type=\"hidden\" name=\"people\" value=\"%d\">\n", people)
    #printf("people=%d",people)
    puts("投票して下さい。<br>あなたが人狼だと思う人を選んで下さい。<br>")
    printf("あなたはplayer%dさんですね?<br>合っていれば「次へ」を押して下さい。<br>",l + 1)
    l += 1
    printf("<input type=\"hidden\" name=\"l\" value=\"%d\">\n", l)
    puts('<input type="submit" value="次へ">')
    
  elsif p == "6"
    printf("<input type=\"hidden\" name=\"people\" value=\"%d\">\n", people)
    #printf("people=%d",people)
    db.transaction do
      all = db["all"]
    end
    puts "以下の中から投票して下さい。
  <p>該当者</p>"
    for a in 1..people
     printf("<input type=\"radio\" name=\"selector\" value=\"%d\">player%d<br>",a,a)
    end
    j += 1
    printf("<input type=\"hidden\" name=\"j\" value=\"%d\">\n", j)
    puts('<input type="submit" value="次へ">')
    puts"</select>"

  elsif p == "7"
    printf("<input type=\"hidden\" name=\"people\" value=\"%d\">\n", people)
    printf("<p>player%dさんを処刑します。<br>player%dはゲームから抜けて下さい。</p>",selector,selector)
  elsif p == "8"
    printf("<input type=\"hidden\" name=\"people\" value=\"%d\">\n", people)
  end
  printf("<input type=\"hidden\" name=\"page\" value=\"%s\">\n", nextpage)
  #puts('<input type="submit" value="次へ">')
end

  puts "</form>
</body>
</html>"
