require "nokogiri"

class Dok
 def initialize
  f = File.open("../data/p01.xml")
  @doc = Nokogiri::XML(f)
  f.close
 end 

 
 def get_dok(qry)
  rows = @doc.xpath("//tr[td/tt = \"#{qry}\"]") #rows NodeSet row Element
  details = rows.collect do |row|
   detail = {}
   [
    [:title, 'td[1]'],
    [:bytes_r, 'td[2]'],
    [:desc, 'td[3]'],
    [:min, 'td[4]'],
    [:max, 'td[5]'],
    [:units, 'td[6]'],
    [:formula, 'td[7]'],
    [:units, 'td[8]']
   ].each do |name, xpath|
    detail[name] ||= row.at_xpath(xpath).text 
   end
   return detail
  end
 end #def
end # class
 
# row = doc.search('//tr[td/tt = "01"]').collect
# row = doc.at('//tr[td/tt = "04"]').collect


 
