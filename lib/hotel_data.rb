module Hotel
  class HotelData 
    attr_reader :id
    def initialize(id:)
      @id = id
    end

    def validate_num(num)
      raise ArgumentError.new('It cannot be blank and must be an integer greater than zero.') if num.nil? || num.class != Integer || num <= 0
    end
    
  end
end