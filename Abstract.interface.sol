/**
 * "Abstract" interface
 *
 * This contract declares a single unimplemented function, realise().  Any
 * contract that inherits from this contract will be abstract unless it
 * implements the realise() function.
 * 
 * Dependencies:
 *   (none)
 *
 * Created by Warwick Allen, May 2018
 * Licenced under GPL3.0
 *
 */

pragma solidity ^0.4.23;
pragma experimental "v0.5.0";


contract Abstract {

    function realise()
    internal;
    
}
