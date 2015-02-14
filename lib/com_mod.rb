# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'serialport'
require 'timeout'
require "../lib/info.rb" 

class Mock
  attr_writer :sync
  def initialize
    antf = File.open("../testdata/codes.txt","r") 
    @codes = antf.read.split(">")
    antf.close
  end
  def write(befehl)
#    puts befehl
    @tmp = /()/.match("NO DATA\n")
    @codes.each {|ll|
#      puts ">>>>>#{befehl}"
      @befehl = befehl.strip
      @tmp2 = /(#{@befehl}.*\n)/.match(ll)
      if @tmp2 then 
#        puts ">>>>>#{befehl} #{@tmp2.post_match}"   
        @tmp = @tmp2 
        break
      else  end
    }
    $antwort= @tmp.post_match + ">"
    return $antwort
  end  

  def getc
  end
 
  def close
  end
end #Mock


class Com_class
  attr_accessor :com_p, :info
 def initialize(com_p)
   @info = Dok.new
   @com_p = com_p
 end 
 def set_cmd(frage)
       $cmdneu = true
       print "Frage "
      puts frage
      $antwort = ""
      com_p.write "#{frage}\r\n"
#      $ipt.write "#{frage}\r\n"
#      $ipt.write "\r\n"
      begin
        status = Timeout.timeout(8){
   #     while $antwort.scan(">") == []     
        while not $antwort.end_with?(">")     
        end  
        }
      rescue Timeout::Error
        puts "Timeout" 
      end
      $protofile.puts frage
      $protofile.print $antwort
      puts $antwort
      return $antwort.sub(/^\n/,"")
    end #set_cmd
    
  def get_info(qry)
    return @info.get_dok(qry)
  end  
   
end


   realw = false

   if realw
    $protofile=File.open("../test/p#{`date +%s`.strip}.txt","w")
   else
    $protofile=File.open("/dev/null","w")
   end
   $protofile.print ">"


