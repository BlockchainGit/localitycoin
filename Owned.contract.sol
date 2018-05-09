/**
 * "Owned" abstract contract
 *
 * To give the ability to modify functions so they can only be run by the
 * contract's owner.
 * 
 * Dependencies:
 * • Abstract interface
 *
 * Created by Warwick Allen, May 2018
 * Licenced under GPL3.0
 *
 */

pragma solidity ^0.4.23;
pragma experimental "v0.5.0";

import "./Abstract.interface.sol";


contract Owned is Abstract {
    address public owner;
    address public ownerChangeRequest = 0x0;

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the owner can run this function"
        );
        _;
    }

    function requestOwnerChange(address _newOwner)
    onlyOwner
    public
    returns (bool success) {
        ownerChangeRequest = _newOwner;
        return true;
    }

    function acceptOwnerChange()
    public
    returns (bool success) {
        require(
            ownerChangeRequest != 0x0,
            "Cannot change the owner to 0x0"
        );
        require(
            msg.sender == ownerChangeRequest,
            "This address has not been nominated to be the new owner"
        );
        owner = ownerChangeRequest;
        ownerChangeRequest = 0x0;
        return true;
    }

}
