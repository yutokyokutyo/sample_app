#!/usr/bin/ruby

require './utility.rb'
puts "あなたの体重は何ですか？"
weight = gets.to_i
puts "あなたの身長は何ですか？"
height = gets.to_f
bmi = calcBmi weight, height
puts "あなたのBMIは #{bmi} なのら！"

