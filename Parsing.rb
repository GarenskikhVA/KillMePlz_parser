    require 'open-uri'
    require 'json'
    require 'rubygems'
#    require 'nokogiri'
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

      hp = Hpricot(open("http://killpls.me/story/#{postNumber}"))
      condition = hp.search("#stories > div:nth-child(3) > div:nth-child(2) > a:nth-child(#{tagNum})").inner_html

      while  condition != 0 do
        tags[tagNum - 1] = hp.search("#stories > div:nth-child(3) > div:nth-child(2) > a:nth-child(#{tagNum})").inner_html
        tagNum = tagNum + 1
        condition = hp.search("#stories > div:nth-child(3) > div:nth-child(2) > a:nth-child(#{tagNum})").inner_html.size
      end 

      newPost[:number] = postNumber
      newPost[:header] = hp.search("#stories > h2").inner_html
      newPost[:body] = hp.search("#stories > div:nth-child(4) > div").inner_html.strip
      newPost[:time] = hp.search("#stories > div:nth-child(3) > div:nth-child(1) > a:nth-child(2)").inner_html
      newPost[:tags] = tags
      newPost[:rating] = hp.search("#stories > div:nth-child(5) > div:nth-child(1) > div > b").inner_html

      if (newPost[:header] == "Новые истории")
        return nil
      else
        return newPost
      end
  end

  def getPostsToJson()
    hp = Hpricot(open("http://killpls.me/"))

    allPosts = hp.search("#stories > div:nth-child(5) > div:nth-child(1) > a:nth-child(1)").inner_html.strip
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

