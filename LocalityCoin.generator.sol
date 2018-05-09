/**
 * The Locality Coin generator
 * 
 * This file contains many realisations of the Locality Coin abstract contract.
 * Each of these contracts creates a token whose purpose is to promote a
 * specific locality.
 * 
 * Dependencies:
 * • LocalityCoin contract
 *   ┣ Abstract interface
 *   ┣ Owned contract
 *   ┃ ┗ Abstract interface
 *   ┣ Suspendable contract
 *   ┃ ┣ Abstract interface
 *   ┃ ┗ Owned contract
 *   ┃   ┗ Abstract interface
 *   ┣ OverflowProofArithmetic96 library
 *   ┗ ERC20Token interface
 *
 * Created by Warwick Allen, May 2018
 * Licenced under GPL3.0 (https://www.gnu.org/licenses/gpl-3.0.txt)
 *
 */

pragma solidity ^0.4.23;
pragma experimental "v0.5.0";

import "./LocalityCoin.contract.sol";


contract WaihekeCoin is LocalityCoin {

    constructor()
    internal
    {
        initialise(
            "Waiheke Island",
            "New Zealand",
            "Waiheke Coin",
            "WAIHK",
            "₩",
            "Warwick Allen",
            "<warwick.allen@blockchain.expert>",
            "",
            ""
        );
    }

    function realise() internal { }
}
