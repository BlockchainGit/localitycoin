/**
 * "Suspendable" abstract contract
 *
 * To give the ability to suspend the contract so that suspendable functions
 * cannot be run (except for by the contract's owner).
 * 
 * Dependencies:
 * • Abstract interface
 * • Owned contract
 *   ┗ Abstract interface
 *
 * Created by Warwick Allen, May 2018
 * Licenced under GPL3.0
 *
 */

pragma solidity ^0.4.23;
pragma experimental "v0.5.0";

import "./Abstract.interface.sol";
import "./Owned.contract.sol";


contract Suspendable is Abstract, Owned {
    /**
     * Modify functions to be "onlyWhenActive" to prevent them from being
     * executed when the contract has been suspended.
     */
    bool public suspended = false;

    modifier onlyWhenActive() {
        // The owner can still run functions when the token is suspended.
        require(
            !suspended || msg.sender == owner,
            "This token is currently disabled"
        );
        _;
    }

    /**
     * Suspend the contract if there is some problem.
     */
    function suspend()
    onlyOwner
    public
    {
        suspended = true;
    }

    /**
     * Re-enable the contract if it has been suspended.
     */
    function enable()
    onlyOwner
    public
    {
        suspended = false;
    }

}
