#!/usr/bin/env ruby
require 'rubygems'
require 'feed-normalizer'
require 'kconv'
#Kconv.tosjis(str)

def strip_tags(str)
  str.gsub(/<.+?>/, '')
end

def strip_blank_line(str)
  if str.respond_to?(:gsub)
    str.gsub(/\n+/, "\n").chomp
  else
    str
  end
end

rssfile = ARGV.shift || 'daitoua-sensou-jyuugunki.xml'
rssstr = open(rssfile,'rb') {|f| f.read.gsub(/\r\n?/,"\n") }
feed = FeedNormalizer::FeedNormalizer.parse(rssstr)

open('大東亜戦争従軍記.txt', 'w') do |f|
  f.write feed.title + "\n"
  f.write "駒形鉄次\n\n"

  f.write <<EOS
-------------------------------------------------------
【テキスト中に現れる記号について】

《》：ルビ
（例）行《え》ぐんだ

｜：ルビの付く文字列の始まりを特定する記号
（例）貧民｜窟《くつ》

［＃］：入力者注　主に外字の説明や、傍点の位置の指定
　　　（数字は、JIS X 0213の面区点番号、または底本のページと行数）
（例）※［＃二の字点、1-2-22］
-------------------------------------------------------\n
EOS

  feed.entries.each do |entry|
    f.write "　　　　　#{entry.title}\n\n"
    f.write strip_tags(strip_blank_line(entry.content)) + "\n\n"
  end
end
