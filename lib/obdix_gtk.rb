require 'gtk2'
require_relative "obd_mod.rb"
require_relative "com_mod.rb"


realw = false

Gtk.init

# Create a new dialog window for the scrolled window to be
# packed into
window = Gtk::Dialog.new
window.signal_connect( "destroy") { Gtk.main_quit }
window.title=( "PID" )
window.border_width=( 0 )
window.set_size_request(1000, 700 )

# Create a new scrolled window
scrolled_window = Gtk::ScrolledWindow.new( nil, nil )
scrolled_window.border_width=( 10 )
scrolled_window.set_policy( Gtk::POLICY_AUTOMATIC, Gtk::POLICY_ALWAYS )

# The dialog window is created with a vbox packed into it
window.vbox.pack_start( scrolled_window, true, true, 0 )

# Create a table of 10 by 10 squares
table = Gtk::Table.new( 10, 10, false )

# Set spacing to 10 on x and 10 on y
table.set_row_spacings( 1 )
#table.set_col_spacings( 10 )

# pack the table into the scrolled window
scrolled_window.add_with_viewport( table )

if realw
  ipt = SerialPort.new("/dev/ttyACM1", 9600, 8, 1, SerialPort::NONE)
  ipt.sync = true
  tst_com = Com_class.new(ipt)
  
  $antwort = ""
   Thread.new {
     while true do
       if $cmdneu
         $antwort = "%c" % ipt.getc
         $cmdneu = false   
       else
         $antwort += "%c" % ipt.getc          
       end
    end
   }


else
 tst_com = Com_class.new(Mock.new)
end
 t_obj = Pclass.new('0100',@self,tst_com)
 t_obj.get_value

# $r1.ini_s2
 i = 0
 t_obj.kinder.each {|kind|
   eh=kind[1]
   #{@ident} #{@info[:desc]} #{@info[:formula]} Wert= #{@value} 
  eh.gtk = Gtk::Button.new(eh.ident + " " + eh.info[:desc])
  begin
   eh2 = Gtk::Button.new(eh.value)
  rescue
   eh2 = Gtk::Button.new("Fehlerwert")
  end   
  begin  
   eh3 = Gtk::Button.new(eh.info[:formula])
#   eh4 = Gtk::Button.new(eh.rvalue.to_s)
  rescue
   eh3 = Gtk::Button.new("keine Formel")
  end   
  eh4 = Gtk::Button.new(eh.rvalue.to_s)
  eh.gtk.set_size_request 600, 30
  eh.gtk.signal_connect( "clicked" ) do |w|
   callback(eh.a_proc)
  end
  table.attach_defaults(eh.gtk,1 , 1 + 1, i, i+1)
  table.attach_defaults(eh3,2 , 2 + 1, i, i+1)  
  table.attach_defaults(eh2,3 , 3 + 1, i, i+1)
  table.attach_defaults(eh4,4 , 4 + 1, i, i+1)
 
  i += 1

}

# add a close button to the bottom of the dialog
button = Gtk::Button.new( Gtk::Stock::CLOSE )
button.signal_connect( "clicked" ) { Gtk.main_quit }

# This make the button the default
button.set_flags( Gtk::Widget::CAN_DEFAULT )
window.action_area.pack_start( button, true, true, 0 )

# This grabs the button to be the default button. Simple hittin
# the enter key will cause this button to activate
button.grab_default

# Show everything
window.show_all
Gtk.main
