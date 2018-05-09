/**
 * ERC Token Standard #20 Interface
 * 
 * Dependencies:
 *   (none)
 *
 * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
 */

pragma solidity ^0.4.23;
pragma experimental "v0.5.0";


interface ERC20Token {

    function totalSupply()
    external
    constant
    returns (uint);

    function balanceOf(address tokenOwner)
    external
    constant
    returns (uint balance);

    function allowance(address tokenOwner, address spender)
    external
    constant
    returns (uint remaining);

    function transfer(address to, uint tokens)
    external
    returns (bool success);

    function approve(address spender, uint tokens)
    external
    returns (bool success);

    function transferFrom(address from, address to, uint tokens)
    external
    returns (bool success);

    event Transfer(
        address indexed from,
        address indexed to,
        uint value
    );

    event Approval(
        address indexed owner,
        address indexed spender,
        uint value
    );

}
