    require 'open-uri'
    require 'json'
    require 'rubygems'
    require 'nokogiri'
    require 'hpricot'


 #while  
   #url = URI.parse("http://www.google.com/")
#req = Net::HTTP.new(url.host, url.port)
#res = req.request_head(url.path)
#if res.code == 404
#    puts res.code
#else 
#	puts "Page exist"
#end


   # if (HTML)
   #doc = Nokogiri::HTML(open("http://killpls.me/story/16168"))
  
  #url = URI.parse("http://killpls.me/story/16168")
   #puts url
  #  if (doc != nil) 
  #  	puts "Yes"
 #   else 
  #  	puts "No"
 #   end
    #doc.xpath('//h3/a').each do |node|
      #puts node.text
# end

=begin
class Post
  attr_accessor :tags
  attr_accessor :header
  attr_accessor :number
  attr_accessor :body
  attr_accessor :time
end
=end


#Объект класса фиг приведешь к JSON, пришлось переделывать все на HashMap =/

class Parser
  def getPostFromNum(postNumber)
      tagNum = 1
      newPost = {}
      tags = Array.new()

      doc = Nokogiri::HTML(open("http://killpls.me/story/#{postNumber}"))
      condition = doc.css("#stories > div:nth-child(3) > div:nth-child(2) > a:nth-child(#{tagNum})").text

      while  condition != 0 do
        tags[tagNum - 1] = doc.css("#stories > div:nth-child(3) > div:nth-child(2) > a:nth-child(#{tagNum})").text
        tagNum = tagNum + 1
        condition = doc.css("#stories > div:nth-child(3) > div:nth-child(2) > a:nth-child(#{tagNum})").text.size
      end 

      newPost[:number] = postNumber
      newPost[:header] = doc.css("#stories > h2").text
      newPost[:body] = doc.css("#stories > div:nth-child(4) > div").text.strip
      newPost[:time] = doc.css("#stories > div:nth-child(3) > div:nth-child(1) > a:nth-child(2)").text
      newPost[:tags] = tags
      newPost[:rating] = doc.css("#stories > div:nth-child(5) > div:nth-child(1) > div > b").text

      if (newPost[:header] == "Новые истории")
        return nil
      else
        return newPost
      end
  end

  def getPostsToJson()
    doc = Nokogiri::HTML(open("http://killpls.me/"))

    allPosts = doc.css("#stories > div:nth-child(5) > div:nth-child(1) > a:nth-child(1)").text
    allPosts =  allPosts[1..-1]
    
    puts "["

    1.upto(allPosts.to_i) { |currNum| 
      currPost = getPostFromNum(currNum)
        
      if currPost != nil 
        puts currPost.to_json
        puts ", "
      end    
    }

      puts "]"
  end
end

#В Ruby я чайник, поэтому вызвал просто в конце всего кода)
Parse = Parser.new
SearchPost = Parse.getPostsToJson

