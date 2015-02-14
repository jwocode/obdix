# To change this template, choose Tools | Templates
# and open the template in the editor.
# jetzt mit eval require "../lib/calc.tab.rb"
module Odb_mod
    
end

class Mclass
  attr_accessor :kinder, :ident, :vorfahr, :info, :gtk, :value, :rvalue
  def initialize(ident,vorfahr,fhandle)
    @ident=ident.upcase
    @vorfahr=vorfahr
    @fhandle=fhandle
    @kinder = Hash.new
    @info=@fhandle.get_info(@ident[2,2])
#    puts @kinder
  end
  
  def get_value
   begin
    puts "#{tmp} #{@ident} #{@info[:desc]}"
   rescue
     puts "xxxx #{@ident} xxxMclass"
   end 
   @kinder.each {|kind|
      kind[1].get_value
      }
  end
end

class Vclass < Mclass #Werte
#  capab 
  def get_value
   tmp = @fhandle.set_cmd(@ident).gsub(/(>| )/,"")
   @rvalue = tmp
   @value = get_formel
   begin
    puts "#{tmp} #{@ident} #{@info[:desc]} #{@info[:formula]} Wert= #{@value} "
#    puts "#{tmp} #{@ident} #{@info[:desc]} #{@info[:formula]} #{@info[:unit] "
   rescue
     puts "#{tmp} #{@ident} xxxVclass"
   end 
  end   
 
 def get_formel
    get_value if @rvalue == nil  
    if @info[:units] != ""
      if true #a_formel.length > 0
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
        return @wert
      end 
      return @wert
    end
    return @wert
  end #getformel

end

class Pclass < Mclass
#  kann zulässige Pids ermitteln 
def initialize(ident,vorfahr,fhandle)
  super 
  getpids
end

def getpids

 pid_w = ident.to_i(16)

 begin
  pid_h = "%04x" % pid_w 
# tmp = @fhandle.set_cmd('0100').delete(" ")
#  tmp = @fhandle.set_cmd(pid_h).gsub(/(>| )/,"")
  $antwort=""
  tmp = @fhandle.set_cmd(pid_h).delete(" ")
  ls = "%032b" % tmp[4..12].to_i(16)
  puts "#{pid_h} >> #{ls}"
#  ls[0...-1].each_char { |c|
  ls[0...-1].each_char { |c|
         pid_w += 1
         if c =="1" 
#           puts " #{c} %04x" % pid_w
           pid_h = "%04X" % pid_w 
           begin
             kinder.update(pid_h => Vclass.new(pid_h,@vorfahr,@fhandle))
           end
         end  
#   ls = c
   }
   pid_w += 1
  end until  ls[-1] == "0"
   puts "Ende Getpids" 
 end #Getpids
 
end #Pclass

# $calcul = Calcp.new

