// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7;

contract Publication {

    address payable private _owner;
    
    constructor() payable {
        _owner = payable(msg.sender);
    }

     modifier onlyOwner() {
        require(msg.sender == _owner);
        _;
    }

    function withdraw() external onlyOwner {
        uint amount = address(this).balance;
        (bool success,) = _owner.call{value: amount}("");
        require(success, "Failed to send Ether");
    }


    event newPublished(string _link,
                        string _type,
                        string _extra,
                        uint _score, uint _time);


    function publish(string calldata _link, 
                    string calldata _type,
                    string calldata _extra) external payable {
        
       emit newPublished(_link, _type, _extra, msg.value, block.timestamp);
    }



}