1. What classes does each implementation include? Are the lists the same?
    CartEntry, ShoppingCart and Order. They are same.
2. Write down a sentence to describe each class.
    CartEntry: refers to a type of item and has attributes of unit_price and quantity.
    ShoppingCart: is a collection of items.
    Order: can get access to the ShoppingCart and provide the total price (including tax).
3. How do the classes relate to each other? It might be helpful to draw a diagram on a whiteboard or piece of paper.
    CartEntry(many)--ShoppingCart(1)--Order(1)
4. What data does each class store? How (if at all) does this differ between the two implementations?
    CartEntry stores the unit price and quantity for one item; ShoppingCart stores all the CartEntry infomration; Order stores the ShoppingCart information that the customer is going to buy and can provide the price including the tax.
    They store the same information.
5. What methods does each class have? How (if at all) does this differ between the two implementations?
    In impletmentation A, CartEntry and ShoppingCart don't have the 'price' method while in B they all have 'price' method. Order class in both A and B has the 'total_price' method.
6. Consider the Order#total_price method. In each implementation:
    Is logic to compute the price delegated to "lower level" classes like ShoppingCart and CartEntry, or is it retained in Order?
        Compute the price delegated to lower level; because it decreases the dependency between two classes. 
    Does total_price directly manipulate the instance variables of other classes?
        A: yes and B: no
7. If we decide items are cheaper if bought in bulk, how would this change the code? Which implementation is easier to modify?
    Add the if/else to CartEntry, quantity == 1, normal price and quantity > 1, cheaper price. Same to modifty two implementations.
8. Which implementation better adheres to the single responsibility principle?
    B
9. Bonus question once you've read Metz ch. 3: Which implementation is more loosely coupled?
    B


Changes I made for Hotel project:
1. I created a new class Hotel::HotelData which is the parent class of Hotel::Room and Hotel::Reservation.
2. I moved the 'id' attribute and 'validate_num(num)' method to the parent class to reduce repeat.
3. I created unit tests for the new created class Hotel::HotelData
4. I added edge case test for 'make_reservation' method in Hotel::HotelSystem class for error handeling when running out of available rooms.