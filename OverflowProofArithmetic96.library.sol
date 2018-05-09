/**
 * Overflow-Proof Arithmetic library for uint96
 *
 * To safe-guard against overflow errors.
 *
 * Dependencies:
 *   (none)
 *
 * Created by Warwick Allen, May 2018
 * Licenced under GPL3.0
 *
 * Based on the "Safe math" library by Bok Consulting Pty Ltd, retreived from
 * https://theethereum.wiki/w/index.php/ERC20_Token_Standard
 *
 */

pragma solidity ^0.4.23;
pragma experimental "v0.5.0";


library OverflowProofArithmetic96 {

    function add(uint96 a, uint96 b)
    internal
    pure
    returns (uint96 c) {
        c = a + b;
        require(c >= a && c >= b, "Overflow detected in addition");
    }

    function subtract(uint96 a, uint96 b)
    internal
    pure
    returns (uint96 c) {
        require(b <= a, "Subtraction will result in a negative value");
        c = a - b;
        require(c <= a, "Overflow detected in subtraction");
    }

    function multiply(uint96 a, uint96 b)
    internal
    pure
    returns (uint96 c) {
        c = a * b;
        require(c >= a && c >= b, "Overflow detected in multiplication");
    }

    function divide(uint96 a, uint96 b)
    internal
    pure
    returns (uint96 c) {
        require(b > 0, "Divide by zero error");
        c = a / b;
        require(c <= a, "Overflow detected in division");
    }

}
