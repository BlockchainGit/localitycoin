/**
 * "LocalityCoin" abstract contract
 * 
 * An abstract ERC20-compatible token to be used to create tokens (coins) that
 * promote specific localities.
 *
 * Dependencies:
 * • Abstract interface
 * • Owned contract
 *     ┗ Abstract interface
 * • Suspendable contract
 *   ┣ Abstract interface
 *   ┗ Owned contract
 *     ┗ Abstract interface
 * • OverflowProofArithmetic96 library
 * • ERC20Token interface
 *
 * Created by Warwick Allen, May 2018
 * Licenced under GPL3.0 (https://www.gnu.org/licenses/gpl-3.0.txt)
 *
 * Some code portions are borrowed from https://www.ethereum.org/token.
 *
 */

pragma solidity ^0.4.23;
pragma experimental "v0.5.0";

import "./Abstract.interface.sol";
import "./OverflowProofArithmetic96.library.sol";
import "./Owned.contract.sol";
import "./Suspendable.contract.sol";
import "./ERC20Token.interface.sol";


interface tokenRecipient {
    function receiveApproval(
        address _from,
        uint256 _value,
        address _token,
        bytes _extraData
    ) external;
}


contract LocalityCoin is Abstract, Owned, Suspendable, ERC20Token {
    using OverflowProofArithmetic96 for uint96;

    string public constant about =
        "The Locality Coin exists to promote provinces, cities, towns and villages.  It was created by Warwick Allen (warwick.allen@bchain.expert) on 7 May 2018 and is licenced under the GNU GENERAL PUBLIC LICENSE Version 3.0, which can be viewed at https://www.gnu.org/licenses/gpl-3.0.txt.";
    uint8 constant public decimals = 18;
    uint96 constant public totalWholeUnits   = 7.9228162514e28;
    uint96 constant public totalMinimumUnits = 7.9228162514e10;
    uint96 constant internal creatorFee = 514e18;

    string public locality;
    string public country;
    string public name;
    string public symbol;
    string public symbolCharacter;
    string public creator;
    string public creatorEmail;
    string public blurb;
    string public miscellaneous;

    mapping (address => uint96) public localityCoinBalance;
    mapping (address => mapping (address => uint96)) public allowed;

    // Notify clients of the amount reverted.
    event RevertToContract(
        address indexed from,
        uint256 value
    );

    /**
     * Initialise token
     *
     * Initialises the token contract by giving all the localitycoin to the
     * creator of the contract (i.e., the "owner").  This is intended to be
     * called from the constructor of the specific localitycoin.
     */
    function initialise(
        string _locality,
        string _country,
        string _name,
        string _symbol,
        string _symbolCharacter,
        string _creator,
        string _creatorEmail,
        string _blurb,
        string _miscellaneous
    )
    internal
    {
        locality = _locality;
        country = _country;
        name = _name;
        symbol = _symbol;
        symbolCharacter = _symbolCharacter;
        creator = _creator;
        creatorEmail = _creatorEmail;
        blurb = _blurb;
        miscellaneous = _miscellaneous;

        owner = msg.sender;
        localityCoinBalance[owner] = creatorFee;
        localityCoinBalance[this] = totalMinimumUnits.subtract(creatorFee);
    }

    /**
     * Fall-back function to receive ether
     */
    function()
    external
    payable
    { }


    /***************************************************************************
     *  Setter functions
     **************************************************************************/

    function setLocality(string newValue)
    onlyOwner public
    returns (string) {
        return locality = newValue;
    }

    function setCountry(string newValue)
    onlyOwner public
    returns (string) {
        return country = newValue;
    }

    function setName(string newValue)
    onlyOwner public
    returns (string) {
        return name = newValue;
    }

    function setSymbol(string newValue)
    onlyOwner public
    returns (string) {
        return symbol = newValue;
    }

    function setSymbolCharacter(string newValue)
    onlyOwner public
    returns (string) {
        return symbolCharacter = newValue;
    }

    function setCreator(string newValue)
    onlyOwner public
    returns (string) {
        return creator = newValue;
    }
    function setCreatorEmail(string newValue)
    onlyOwner public returns (string) {
        return creatorEmail = newValue;
    }
    function setBlurb(string newValue)
    onlyOwner public returns (string) {
        return blurb = newValue;
    }
    function setMiscellaneous(string newValue)
    onlyOwner public returns (string) {
        return miscellaneous = newValue;
    }


    /***************************************************************************
     *  ERC20 function implemenations
     **************************************************************************/

    /**
     * Total Supply
     * 
     * The total number of whole coins.
     */
    function totalSupply()
    external
    constant
    returns (uint) {
        return totalWholeUnits;
    }

    /**
     * Get the balance of an address
     * 
     * Returns the number of minimum units of localitycoin owned by
     * `tokenOwner`.
     * 
     * @param tokenOwner The address to query
     */
    function balanceOf(address tokenOwner)
    external
    constant
    returns (uint balance) {
        return localityCoinBalance[tokenOwner];
    }

    /**
     * Get allowance
     * 
     * Returns the amount of tokens approved by the owner that can be
     * transferred to the spender's account.
     * 
     * @param tokenOwner The owner of the tokens
     * @param spender The address authorised to spend
     */
    function allowance(address tokenOwner, address spender)
    external
    constant
    returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    /**
     * Transfer localitycoin
     *
     * Send `tokens` localitycoin to `to` from the caller's account.
     *
     * @param to The address of the recipient
     * @param tokens The amount to send
     */
    function transfer(address to, uint tokens)
    external
    returns (bool success) {
        uint96 volume = uint96(tokens);
        _transfer(msg.sender, to, volume);
        return true;
    }

    /**
     * Transfer localitycoin from another address
     *
     * Send `volume` localitycoin to `to` on behalf of `from`.
     *
     * @param from The address of the sender
     * @param to The address of the recipient
     * @param tokens The amount to send
     */
    function transferFrom(address from, address to, uint tokens)
    onlyWhenActive
    public
    returns (bool success) {
        uint96 thisAllowance = allowed[from][msg.sender];
        uint96 volume = uint96(tokens);
        require(
            volume <= thisAllowance,
            "The allowance is insufficient for this transfer"
        );
        allowed[from][msg.sender] = thisAllowance.subtract(volume);
        _transfer(from, to, volume);
        return true;
    }

    /**
     * Set allowance for another address
     *
     * Allows `spender` to spend no more than `volume` tokens on the caller's
     * behalf.
     *
     * @param spender The address authorized to spend
     * @param tokens the max amount they can spend
     */
    function approve(address spender, uint tokens)
    onlyWhenActive
    public
    returns (bool success) {
        uint96 volume = uint96(tokens);
        allowed[msg.sender][spender] = volume;
        emit Approval(msg.sender, spender, volume);
        return true;
    }

    /***************************************************************************
     *  Other functions
     **************************************************************************/

    /**
     * Get the caller's balance
     * 
     * Returns the number of minimum units of localitycoin owned by the caller.
     */
    function balanceOfThis()
    view
    public
    returns (uint) {
        return localityCoinBalance[msg.sender];
    }

    /**
     * Set allowance for other address and notify
     *
     * Allows `_spender` to spend no more than `_volume` minimum units of
     * localitycoin on the caller's behalf, then pings the contract about it.
     *
     * @param _spender The address authorised to spend
     * @param _volume The max amount they can spend
     * @param _extraData Some extra information to send to the approved contract
     */
    function approveAndCall(address _spender, uint96 _volume, bytes _extraData)
    onlyWhenActive
    public
    returns (bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _volume)) {
            spender.receiveApproval(msg.sender, _volume, this, _extraData);
            return true;
        }
    }

    /**
     * Send localitycoin to the contract from another account
     *
     * Send `_volume` minimum units of localitycoin on behalf of `_from`.
     *
     * @param _from the address of the sender
     * @param _volume the amount of localitycoin to revert
     */
    function revertToContractFrom(address _from, uint96 _volume)
    public
    returns (bool success) {
        _transfer(_from, this, _volume);
        emit RevertToContract(_from, _volume);
        return true;
    }

    /**
     * Send localitycoin to the contract
     *
     * Returns `_volume` minimum units of localitycoin to the contract.
     *
     * @param _volume the amount of money to revert
     */
    function revertToContract(uint96 _volume)
    public
    returns (bool success) {
        return revertToContractFrom(msg.sender, _volume);
    }

    /**
     * Get the contract's balance
     * 
     * Returns the number of minimum units of localitycoin owned by the contract.
     */
    function balanceOfContract()
    view
    public
    returns (uint volume) {
        return localityCoinBalance[this];
    }

    /**
     * Get the price of localitycoin in ether
     */
    function getPrice()
    view
    public
    returns (uint96 price) {
        return (totalMinimumUnits.subtract(localityCoinBalance[this])) >> 2;
    }

    /**
     * Get the ether value of a volume of localitycoin
     *
     * Returns the value of wei needed to buy `_volume` minimum units of
     * localitycoin.
     * 
     * @param _volume The amount of localitycoin
     */
    function getValue(uint96 _volume)
    view
    public
    returns (uint96 value) {
        uint96 price = getPrice();
        return price.multiply(_volume);
    }

    /**
     * Get the volume that can be purchased with some ether value
     *
     * Returns the volume of minimum units of localitycoin that `_value` of wei
     * will buy.
     * 
     * @param _value The amount of wei
     */
    function getBuyVolume(uint96 _value)
    view
    public
    returns (uint96 volume) {
        uint96 price = getPrice();
        return _value.divide(price);
    }

    /**
     * Buy localitycoin
     * 
     * Exchange ether for localitycoin.
     */
    function buy()
    payable
    public
    returns (uint96 volume) {
        uint96 value = uint96(msg.value);
        require(
            uint256(value) == msg.value,
            "Overflow detected in the amount of paid ether"
        );
        volume = getBuyVolume(value);
        _transfer(this, msg.sender, volume); // from contract to seller
        return volume;
    }

    /**
     * Sell localitycoin
     * 
     * Redeem localitycoin for ether.
     */
    function sell(uint96 _amount)
    public
    returns (uint96 value){
        _transfer(msg.sender, this, _amount); // from seller to contract
        value = getValue(_amount);
        // Send ether to the seller.  It's important to do this last to prevent
        // recursion attacks.
        msg.sender.transfer(value);
        return value;
    }

    /**
     * Internal transfer, only can be called by this contract
     */
    function _transfer(address _from, address _to, uint96 _value)
    onlyWhenActive
    internal
    {
        require(_to != 0x0, "Cannot transfer to 0x0");
        require(
            localityCoinBalance[_from] >= _value,
            "The sender's localityCoin balance is too low"
        );

        localityCoinBalance[_from] = localityCoinBalance[_from].subtract(
            _value
        );   // Subtract from the sender

        localityCoinBalance[_to] = localityCoinBalance[_to].add(
            _value
        );     // Add the same to the recipient

        emit Transfer(_from, _to, _value);
    }

}
