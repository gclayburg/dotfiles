#!/usr/bin/expect

#spawn bash
#expect "$"
set oldpass "Funk12#$"
set newpass "qwerty7890"
#set oldpass "changeme"
set old2pass "changem3!"


proc change {} {
  global newpass
  global oldpass
  global old2pass
  send "$oldpass\r"
  expect -re "New \[UNIX]* password:" {
    send "$newpass\r"
    expect -re "new \[UNIX]* password:" {
      send "$newpass\r"
    }
    #matches space in 3 line prompt
#    expect "$ " 
#    send "exit\r"
  } "mismatch" {
    #puts "\rchangepass.ex: no changing password for you."
    puts "\rchangepass.ex: try again."
    send "\r"
    send "passwd\r"
    expect "Old password:"

    send "$old2pass\r"
    expect "New password:" {
      send "$newpass\r"
      expect "new password:"
      send "$newpass\r"
      expect "$"
      send "exit\r"
    } "mismatch" {
    puts "\rchangepass.ex: no changing password for you."
      interact
      exit
    }
  }
}
set serverhostname [lindex $argv 0]

spawn ssh [lindex $argv 0] 
expect "$serverhostname's password: " {
    puts "cannot change password this way- this box requires a password to login"
    interact
  } "(current) UNIX password:" { 
    change
  } "$ " {
    puts "no password needed to login"
  }
#}


