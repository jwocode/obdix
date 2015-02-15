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

class Formel
  
end

def hxarr(ins)
  return Hash[:a => ins[4..5],:b => ins[6..7],:c => ins[8..9],:d => ins[10..11]]
#  return tmparr
end

def find_formel
  specpid = ["01","03"]
  if specpid.include? info[:title] 
    return "p" + info[:title]
  else
   return "get_formelx"
  end
end

def get_formelx
    get_value if @rvalue == nil  
    if @info[:units] != ""
       begin 
          p_str=@info[:formula]
          p_str.gsub!("A",@rvalue[4..5].to_i(16).to_s)
          p_str.gsub!("B",@rvalue[6..7].to_i(16).to_s)
        rescue
        end
        begin
         return eval(p_str).to_s
        rescue SyntaxError => se
         return "N/C"
        end  
      else 
        return "N/C2"
      end 
      return @wert
  end #getformel

def p01
  get_value if @rvalue == nil
  tmp = hxarr(rvalue)
  if (tmp[:a].hex & "80".hex) == 0
    res = "MIL OFF "
  else
    res = "MIL ON! "
  end
  res +=  (tmp[:a].hex & "7F".hex).to_s + " Err\n"
  if (tmp[:b].hex & "1000".to_i(2)) == 0
    res += "Spark ignition"
  else
    res += "Compression ignition"
  end
  if (tmp[:b].hex & "1".to_i(2)) != 0
    res += "\nMisfire "
    if (tmp[:b].hex & "10000".to_i(2)) != 0 then res += "Test Pending" end
  end
  if (tmp[:b].hex & "10".to_i(2)) != 0
    res += "\nFuel System "
    if (tmp[:b].hex & "100000".to_i(2)) != 0 then res += "Test Pending" end
  end
  if (tmp[:b].hex & "100".to_i(2)) != 0
    res += "\nComponents "
    if (tmp[:b].hex & "1000000".to_i(2)) != 0 then res += "Test Pending" end
  end
  return res
end

def p03 #Fuel system Status
  
  
  get_value if @rvalue == nil
  tmp = hxarr(rvalue)
  return {0 => "--",
  1 =>"Open loop due to insufficient engine temperature", 
  2 =>"Closed loop, using oxygen sensor feedback to determine fuel mix",
  4 =>"Open loop due to engine load OR fuel cut due to deceleration",
  8 =>"Open loop due to system failure",
  16 =>"Closed loop, using at least one oxygen sensor but there is a fault in the feedback system"}[tmp[:a].hex].to_s
end
  
 
