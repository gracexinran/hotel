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
      puts "\n"
      puts "--- Welcome to our hotel booking system! ---"
      puts "How can I help you?"
      user_input = user_request_input
      while user_input != 3
        reservation(user_input)
        puts "\n"
        puts "Is there anything else we can help you?"
        user_input = user_request_input
      end
      puts "\n"
      puts " --- Thanks for visiting our hotel system! See you next time! ---"
      puts "\n"
    end
    
    def user_request_input
      list_menu
      print ">> "
      user_input = gets.chomp.to_i
      while !validate_menu(user_input)
        puts "\n"
        puts "Invalid input!"
        list_menu
        print ">> "
        user_input = gets.chomp.to_i
      end
      return user_input
    end
    
    def list_menu
      puts "\n"
      puts "Please choose a number:"
      puts " [1] Book your stays"
      puts " [2] Special events"
      puts " [3] Exit"
    end

    def validate_menu(user_input)
      user_input <= 3 && user_input > 0 ? true : false
    end

    def reservation(user_input)
      case user_input
      when 1
        begin
          nights = ask_info_nights
          @start_date = validate_start_date
          end_date = validate_end_date
          reservation = @hotel_system.make_reservation(@start_date, end_date, nights)
          thank_you_message(reservation)
        rescue StandardError => exception
          puts "#{exception}"
          puts "\n"
        end
        
      when 2
        begin
          nights = ask_info_nights
          @start_date = validate_start_date
          end_date = validate_end_date
          room_rate = discount_room_rate
          reservation = @hotel_system.make_reservation(@start_date, end_date, nights, room_rate)
          thank_you_message(reservation)
        rescue StandardError => exception
          puts "#{exception}"
          puts "\n"
        end

      end
    end
    
    def ask_info_nights
      puts "\n"
      puts "How many nights do you want to book?"
      print ">> "
      user_input = gets.chomp.to_i
      while user_input > 5 || user_input < 1
        puts "\n"
        puts "Invalid input!"
        puts "\n"
        puts "How many nights do you want to book?"
        print ">> "
        user_input = gets.chomp.to_i
      end
      return user_input
      
    end
    
    def ask_start_date
      puts "\n"
      puts "What's the start date?"
      print 'Year: '
      year = gets.chomp.to_i
      print 'Month: '
      month = gets.chomp.to_i
      print 'Day: '
      day = gets.chomp.to_i
      
      while !Date.valid_date?(year, month, day)
        puts "\n"
        puts "Invalid Date!"
        puts "\n"
        puts "What's the start date?"
        print 'Year: '
        year = gets.chomp.to_i
        print 'Month: '
        month = gets.chomp.to_i
        print 'Day: '
        day = gets.chomp.to_i
      end
      
      date = Date.new(year, month, day)
      return date
    end
    
    def validate_start_date
      date = ask_start_date
      while date < Date.today
        puts "\n"
        puts "Invalid Date!"
        date = ask_start_date
      end
      return date
    end
    
    def ask_end_date
      puts "\n"
      puts "What's the end date?"
      print 'Year: '
      year = gets.chomp.to_i
      print 'Month: '
      month = gets.chomp.to_i
      print 'Day: '
      day = gets.chomp.to_i
      
      while !Date.valid_date?(year, month, day)
        puts "\n"
        puts "Invalid Date!"
        puts "\n"
        puts "What's the end date?"
        print 'Year: '
        year = gets.chomp.to_i
        print 'Month: '
        month = gets.chomp.to_i
        print 'Day: '
        day = gets.chomp.to_i
      end
      
      date = Date.new(year, month, day)
      return date
    end
    
    def validate_end_date
      date = ask_end_date
      while date < Date.today || date <= @start_date
        puts "\n"
        puts "Invalid Date!"
        puts "\n"
        date = ask_end_date
      end
      return date
    end
    
    def discount_room_rate
      puts "\n"
      puts "Please provide a discount room rate"
      print ">> "
      room_rate = validate_room_rate
      return room_rate
    end
    
    def validate_room_rate
      user_input = gets.chomp.to_i
      while user_input >= STANDARD_RATE || user_input <= 0
        puts "\n"
        puts "Invalid room rate!"
        puts "\n"
        puts "Please provide a discount room rate"
        print ">> "
        user_input = gets.chomp.to_i
      end
      return user_input
      
    end
    
    def thank_you_message(reservation)
      puts "\n"
      puts "Thanks for your reservation!"
      puts "\n"
      room_ids = reservation.room_ids.join(' ,')
      puts "--- Reservation Details ---\n Reservation id: #{reservation.id} \n Room number(s): #{room_ids} \n Total cost: $#{reservation.cost}"
    end
    
  end
  
end


visit = Hotel::HotelBooking.new
visit.open_system
