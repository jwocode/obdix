require "../lib/obd_mod.rb"
require "../lib/com_mod.rb"
require "../lib/info.rb"

require "test/unit"
 
class Test_Check < Test::Unit::TestCase
  def test_basis 
#    ipt = SerialPort.new("/dev/ttyACM0", 9600, 8, 1, SerialPort::NONE)
#    tst_com = Com_class.new(ipt)
    tst_com = Com_class.new(Mock.new)
    t_obj = Mclass.new('0100',@self,tst_com)
    assert_equal(t_obj.kinder, {})
#    puts tst_com.set_cmd('0100')
#bus    assert_equal("41 00 98 3F 80 10\n>",tst_com.set_cmd('0100'))
    assert_equal( "41 00 BE 1F A8 13",tst_com.set_cmd('0100')[0..16])
    t_obj = Pclass.new('0100',@self,tst_com)
    t_obj.get_value
    puts "xx" 
    t_obj.kinder.each {|kind  |
      puts "kind"
      puts kind
      
      }
   
  end

  def test_info
    x = Dok.new
    y1 = x.get_dok('04')
    puts y1[:desc]
    assert_equal("Calculated engine load value",y1[:desc])
    puts x.get_dok('04')
    assert_equal(hxarr("41010007E500")[:a],"07")
    puts
  end
 
end
