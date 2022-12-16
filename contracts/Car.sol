// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Car {
    address public RentalOwner;
    uint256 private counter;

    constructor(){
        RentalOwner = msg.sender;    
        counter =0;
        }
    struct rentalInst {
        string carname;
        string carnum;
        string imgUrl;
        string[] dates;
        uint256 id;
        address renter;
        uint256 price;
    }    
    event rentalopen (
        string carname,
        string carum,
        string imgUrl,
        string[] dates,
        address renter ,
        uint256 id ,
        uint256 price
       
    );

    event newDatesBooked (
        string[] datesBooked,
        uint256 id,
        address booker,
        
        string imgUrl 
    );

    mapping(uint256 => rentalInst) rentals;
    uint256[] public rentalIds;

    function getAllRentalsValue() public view returns ( uint256   ) {
        return counter;
    }

    function addRentals(
        string memory carname,
        string memory carnum,
        string memory imgUrl,
        string[] memory dates,
        uint256 id,
        address renter , 
        uint256 price
    ) public {
       // require(msg.sender == RentalOwner , "Only OWner can post rentals");
        rentalInst storage newRent = rentals[counter];
        newRent.carname = carname;
        newRent.carnum = carnum;
        newRent.imgUrl = imgUrl;
        newRent.dates = dates;
        newRent.id = counter;
        newRent.renter = renter;
        newRent.price = price;
        rentalIds.push(counter);

        emit rentalopen(carname, carnum, imgUrl, dates, renter, id , price);

        counter++;
    }

    function checkBookings(uint256 id , string[] memory newBookings) private view returns (bool){
        for(uint i=0; i< newBookings.length ; i++){
            for(uint j=0; j < rentals[id].dates.length ; j++){
                if( keccak256(abi.encodePacked(rentals[id].dates[j]))== keccak256(abi.encodePacked(newBookings[i]))){
                    return false;
                }
            }
        }
        return true;
    }

    function addDatesBooked(uint256 id , string[] memory newBookings) public payable {
        require(id <counter , "NO SUCH RENTAL");
        require(checkBookings(id , newBookings),"Already BOOKED");
        require(msg.value == (rentals[id].price  ), "Please Pay The Correct Amount");

        for(uint i=0 ; i <newBookings.length ; i++){
            rentals[id].dates.push(newBookings[i]);

            payable(RentalOwner).transfer(msg.value);
            emit newDatesBooked(newBookings, id, msg.sender, rentals[id].imgUrl);

        }

    }

    function getRental(uint256 id ) public view returns (string memory , uint256 , string[] memory , uint256 , string memory)
    {
        require(id <counter,"NO Such Rentals");

        rentalInst storage s = rentals[id];
        return (s.carname , s.price , s.dates , s.id , s.imgUrl);
    }

    



}