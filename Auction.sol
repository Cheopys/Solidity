pragma solidity ^0.4.17;

contract Auction
{
    struct Bid
    {
        address bidder;
        uint32  itemId;
    }

    struct Item
    {
        uint32 itemId;
        string description;
    }
}