puts("月を入力してね")
month = gets.to_i
case month
  when 1,2,12
    puts("#{month} 月は寒いですね。")
  when 3,4,5
    puts("#{month} 月は寒いですね。")
  when 6,7,8
    puts("#{month} 月は暖かいですね。")
  when 9,10,11
    puts("#{month} 月は肌寒いですね。")
  else
    puts("そんな月はないよ")
end
