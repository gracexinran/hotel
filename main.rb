require 'date'
require_relative "lib/hotel_system"
require_relative "lib/reservation"
require_relative "lib/room"

module Hotel
  class HotelBooking
    STANDARD_RATE = 200
    def initialize
      @hotel_system = Hotel::HotelSystem.new
      @start_date
    end
    
    def open_system
      puts "Welcome to our hotel booking system!"
      puts "How can I help you?"
      list_menu
      print '*** >>  '
      user_input = gets.chomp.to_i
      while !validate(user_input)
        puts "\n"
        puts "Invalid input!"
        list_menu
        user_input = gets.chomp.to_i
      end
      user_request(user_input)
      
    end
    
    def list_menu
      puts "\n"
      puts "Please choose a number:"
      puts " 1. Book your stays"
      puts " 2. Special events"
      puts " 3. Exit"
    end
    
    def user_request(user_input)
      case user_input
      when 1
        nights = ask_info_nights
        @start_date = validate_start_date
        end_date = validate_end_date
        reservation = @hotel_system.make_reservation(@start_date, end_date, nights)
        thank_you_message(reservation)
        
      when 2
        nights = ask_info_nights
        @start_date = validate_start_date
        end_date = validate_end_date
        room_rate = discount_room_rate
        reservation = @hotel_system.make_reservation(@start_date, end_date, nights, room_rate)
        thank_you_message(reservation)
        
      when 3
        puts "Thanks for visiting our hotel system! See you next time!"
      end
      
    end
    
    def validate(user_input)
      user_input <= 3 && user_input > 0 ? true : false
    end
    
    def ask_info_nights
      puts "How many nights do you want to book?"
      print '*** >>  '
      user_input = gets.chomp.to_i
      while user_input > 5 || user_input < 1
        puts "\n"
        puts "Invalid input!"
        puts "How many nights do you want to book?"
        p '*** >>  '
        user_input = gets.chomp.to_i
      end
      return user_input
      
    end
    
    def ask_start_date
      puts "What's the start date?"
      print '*** Year: '
      year = gets.chomp.to_i
      print '*** Month: '
      month = gets.chomp.to_i
      print '*** Day: '
      day = gets.chomp.to_i
      
      while !Date.valid_date?(year, month, day)
        puts "Invalid Date!"
        puts "What's the start date?"
        print '*** Year: '
        year = gets.chomp.to_i
        print '*** Month: '
        month = gets.chomp.to_i
        print '*** Day: '
        day = gets.chomp.to_i
      end

      date = Date.new(year, month, day)
      return date
    end
    
    def validate_start_date
      date = ask_start_date
      while date < Date.today
        puts "Invalid Date!"
        date = ask_start_date
      end
      return date
    end
    
    def ask_end_date
      puts "What's the end date?"
      print '*** Year: '
      year = gets.chomp.to_i
      print '*** Month: '
      month = gets.chomp.to_i
      print '*** Day: '
      day = gets.chomp.to_i
      
      while !Date.valid_date?(year, month, day)
        puts "Invalid Date!"
        puts "What's the end date?"
        print '*** Year: '
        year = gets.chomp.to_i
        print '*** Month: '
        month = gets.chomp.to_i
        print '*** Day: '
        day = gets.chomp.to_i
      end

      date = Date.new(year, month, day)
      return date
    end
    
    def validate_end_date
      date = ask_end_date
      while date < Date.today || date <= @start_date
        puts "Invalid Date!"
        date = ask_end_date
      end
      return date
    end
    
    def discount_room_rate
      puts "\n"
      puts "Please provide a discount room rate"
      room_rate = validate_room_rate
      return room_rate
    end
    
    def validate_room_rate
      user_input = gets.chomp.to_i
      while user_input >= STANDARD_RATE || user_input <= 0
        puts "Invalid room rate!"
        puts "Please provide a discount room rate"
        user_input = gets.chomp.to_i
      end
      return user_input
      
    end
    
    def thank_you_message(reservation)
      puts "Thanks for your reservation!"
      room_ids = reservation.room_ids.join(' ,')
      puts "Your reservation id is #{reservation.id}. \nYour room number(s) is(are) #{room_ids}. \nTotal cost for your reservation is #{reservation.cost}."
    end
    
  end
  
end


visit = Hotel::HotelBooking.new
visit.open_system
