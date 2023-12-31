// Sources flattened with hardhat v2.4.1 https://hardhat.org

// File zos-lib/contracts/Initializable.sol@v2.2.3

pragma solidity >=0.4.24 <0.6.0;

/**
 * @title Initializable
 *
 * @dev Helper contract to support initializer functions. To use it, replace
 * the constructor with a function that has the `initializer` modifier.
 * WARNING: Unlike constructors, initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract, as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be taken to not invoke
 * a parent initializer twice, or ensure that all initializers are idempotent,
 * because this is not dealt with automatically as with constructors.
 */
contract Initializable {
  /**
   * @dev Indicates that the contract has been initialized.
   */
  bool private initialized;

  /**
   * @dev Indicates that the contract is in the process of being initialized.
   */
  bool private initializing;

  /**
   * @dev Modifier to use in the initializer function of a contract.
   */
  modifier initializer() {
    require(
      initializing || isConstructor() || !initialized,
      "Contract instance has already been initialized"
    );

    bool wasInitializing = initializing;
    initializing = true;
    initialized = true;

    _;

    initializing = wasInitializing;
  }

  /// @dev Returns true if and only if the function is running in the constructor
  function isConstructor() private view returns (bool) {
    // extcodesize checks the size of the code stored in an address, and
    // address returns the current address. Since the code is still not
    // deployed when running a constructor, any checks on its code size will
    // yield zero, making it an effective way to detect if a contract is
    // under construction or not.
    uint256 cs;
    assembly {
      cs := extcodesize(address)
    }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}

// File openzeppelin-eth/contracts/ownership/Ownable.sol@v2.1.3

pragma solidity ^0.5.0;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable is Initializable {
  address private _owner;

  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function initialize(address sender) public initializer {
    _owner = sender;
    emit OwnershipTransferred(address(0), _owner);
  }

  /**
   * @return the address of the owner.
   */
  function owner() public view returns (address) {
    return _owner;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(isOwner());
    _;
  }

  /**
   * @return true if `msg.sender` is the owner of the contract.
   */
  function isOwner() public view returns (bool) {
    return msg.sender == _owner;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0));
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }

  uint256[50] private ______gap;
}

// File contracts/interfaces/IERC721.sol

pragma solidity 0.5.7;

/// @title ERC-721 Non-Fungible Token Standard
/// @dev See https://eips.ethereum.org/EIPS/eip-721
///  Note: the ERC-165 identifier for this interface is 0x80ac58cd

interface IERC721 {
  /// @dev This emits when ownership of any NFT changes by any mechanism.
  ///  This event emits when NFTs are created (`from` == 0) and destroyed
  ///  (`to` == 0). Exception: during contract creation, any number of NFTs
  ///  may be created and assigned without emitting Transfer. At the time of
  ///  any transfer, the approved address for that NFT (if any) is reset to none.
  event Transfer(
    address indexed _from,
    address indexed _to,
    uint indexed _tokenId
  );

  /// @dev This emits when the approved address for an NFT is changed or
  ///  reaffirmed. The zero address indicates there is no approved address.
  ///  When a Transfer event emits, this also indicates that the approved
  ///  address for that NFT (if any) is reset to none.
  event Approval(
    address indexed _owner,
    address indexed _approved,
    uint indexed _tokenId
  );

  /// @dev This emits when an operator is enabled or disabled for an owner.
  ///  The operator can manage all NFTs of the owner.
  event ApprovalForAll(
    address indexed _owner,
    address indexed _operator,
    bool _approved
  );

  /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
  ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
  ///  THEY MAY BE PERMANENTLY LOST
  /// @dev Throws unless `msg.sender` is the current owner, an authorized
  ///  operator, or the approved address for this NFT. Throws if `_from` is
  ///  not the current owner. Throws if `_to` is the zero address. Throws if
  ///  `_tokenId` is not a valid NFT.
  /// @param _from The current owner of the NFT
  /// @param _to The new owner
  /// @param _tokenId The NFT to transfer
  function transferFrom(
    address _from,
    address _to,
    uint _tokenId
  ) external payable;

  /// @notice Set or reaffirm the approved address for an NFT
  /// @dev The zero address indicates there is no approved address.
  /// @dev Throws unless `msg.sender` is the current NFT owner, or an authorized
  ///  operator of the current owner.
  /// @param _approved The new approved NFT controller
  /// @param _tokenId The NFT to approve
  function approve(address _approved, uint _tokenId) external payable;

  /// @notice Transfers the ownership of an NFT from one address to another address
  /// @dev Throws unless `msg.sender` is the current owner, an authorized
  ///  operator, or the approved address for this NFT. Throws if `_from` is
  ///  not the current owner. Throws if `_to` is the zero address. Throws if
  ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
  ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
  ///  `onERC721Received` on `_to` and throws if the return value is not
  ///  `bytes4(keccak256('onERC721Received(address,address,uint,bytes)'))`.
  /// @param _from The current owner of the NFT
  /// @param _to The new owner
  /// @param _tokenId The NFT to transfer
  /// @param data Additional data with no specified format, sent in call to `_to`
  function safeTransferFrom(
    address _from,
    address _to,
    uint _tokenId,
    bytes calldata data
  ) external payable;

  /// @notice Transfers the ownership of an NFT from one address to another address
  /// @dev This works identically to the other function with an extra data parameter,
  ///  except this function just sets data to ''
  /// @param _from The current owner of the NFT
  /// @param _to The new owner
  /// @param _tokenId The NFT to transfer
  function safeTransferFrom(
    address _from,
    address _to,
    uint _tokenId
  ) external payable;

  /// @notice Enable or disable approval for a third party ('operator') to manage
  ///  all of `msg.sender`'s assets.
  /// @dev Emits the ApprovalForAll event. The contract MUST allow
  ///  multiple operators per owner.
  /// @param _operator Address to add to the set of authorized operators.
  /// @param _approved True if the operator is approved, false to revoke approval
  function setApprovalForAll(address _operator, bool _approved) external;

  /// @notice Count all NFTs assigned to an owner
  /// @dev NFTs assigned to the zero address are considered invalid, and this
  ///  function throws for queries about the zero address.
  /// @param _owner An address for whom to query the balance
  /// @return The number of NFTs owned by `_owner`, possibly zero
  function balanceOf(address _owner) external view returns (uint);

  /// @notice Find the owner of an NFT
  /// @dev NFTs assigned to zero address are considered invalid, and queries
  ///  about them do throw.
  /// @param _tokenId The identifier for an NFT
  /// @return The address of the owner of the NFT
  function ownerOf(uint _tokenId) external view returns (address);

  /// @notice Get the approved address for a single NFT
  /// @dev Throws if `_tokenId` is not a valid NFT
  /// @param _tokenId The NFT to find the approved address for
  /// @return The approved address for this NFT, or the zero address if there is none
  function getApproved(uint _tokenId) external view returns (address);

  /// @notice Query if an address is an authorized operator for another address
  /// @param _owner The address that owns the NFTs
  /// @param _operator The address that acts on behalf of the owner
  /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
  function isApprovedForAll(
    address _owner,
    address _operator
  ) external view returns (bool);

  /// @notice A descriptive name for a collection of NFTs in this contract
  function name() external view returns (string memory _name);
}

// File openzeppelin-solidity/contracts/introspection/IERC165.sol@v2.2.0

pragma solidity ^0.5.2;

/**
 * @title IERC165
 * @dev https://eips.ethereum.org/EIPS/eip-165
 */
interface IERC165 {
  /**
   * @notice Query if a contract implements an interface
   * @param interfaceId The interface identifier, as specified in ERC-165
   * @dev Interface identification is specified in ERC-165. This function
   * uses less than 30,000 gas.
   */
  function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File openzeppelin-solidity/contracts/introspection/ERC165.sol@v2.2.0

pragma solidity ^0.5.2;

/**
 * @title ERC165
 * @author Matt Condon (@shrugs)
 * @dev Implements ERC165 using a lookup table.
 */
contract ERC165 is IERC165 {
  bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
  /*
   * 0x01ffc9a7 ===
   *     bytes4(keccak256('supportsInterface(bytes4)'))
   */

  /**
   * @dev a mapping of interface id to whether or not it's supported
   */
  mapping(bytes4 => bool) private _supportedInterfaces;

  /**
   * @dev A contract implementing SupportsInterfaceWithLookup
   * implement ERC165 itself
   */
  constructor() internal {
    _registerInterface(_INTERFACE_ID_ERC165);
  }

  /**
   * @dev implement supportsInterface(bytes4) using a lookup table
   */
  function supportsInterface(bytes4 interfaceId) external view returns (bool) {
    return _supportedInterfaces[interfaceId];
  }

  /**
   * @dev internal method for registering an interface
   */
  function _registerInterface(bytes4 interfaceId) internal {
    require(interfaceId != 0xffffffff);
    _supportedInterfaces[interfaceId] = true;
  }
}

// File openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol@v2.2.0

pragma solidity ^0.5.2;

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
contract IERC721Receiver {
  /**
   * @notice Handle the receipt of an NFT
   * @dev The ERC721 smart contract calls this function on the recipient
   * after a `safeTransfer`. This function MUST return the function selector,
   * otherwise the caller will revert the transaction. The selector to be
   * returned can be obtained as `this.onERC721Received.selector`. This
   * function MAY throw to revert and reject the transfer.
   * Note: the ERC721 contract address is always the message sender.
   * @param operator The address which called `safeTransferFrom` function
   * @param from The address which previously owned the token
   * @param tokenId The NFT identifier which is being transferred
   * @param data Additional data with no specified format
   * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
   */
  function onERC721Received(
    address operator,
    address from,
    uint256 tokenId,
    bytes memory data
  ) public returns (bytes4);
}

// File openzeppelin-solidity/contracts/token/ERC721/ERC721Holder.sol@v2.2.0

pragma solidity ^0.5.2;

contract ERC721Holder is IERC721Receiver {
  function onERC721Received(
    address,
    address,
    uint256,
    bytes memory
  ) public returns (bytes4) {
    return this.onERC721Received.selector;
  }
}

// File openzeppelin-solidity/contracts/token/ERC20/IERC20.sol@v2.2.0

pragma solidity ^0.5.2;

/**
 * @title ERC20 interface
 * @dev see https://eips.ethereum.org/EIPS/eip-20
 */
interface IERC20 {
  function transfer(address to, uint256 value) external returns (bool);

  function approve(address spender, uint256 value) external returns (bool);

  function transferFrom(
    address from,
    address to,
    uint256 value
  ) external returns (bool);

  function totalSupply() external view returns (uint256);

  function balanceOf(address who) external view returns (uint256);

  function allowance(
    address owner,
    address spender
  ) external view returns (uint256);

  event Transfer(address indexed from, address indexed to, uint256 value);

  event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File contracts/mixins/MixinFunds.sol

pragma solidity 0.5.7;

/**
 * @title An implementation of the money related functions.
 * @author HardlyDifficult (unlock-protocol.com)
 */
contract MixinFunds {
  /**
   * The token-type that this Lock is priced in.  If 0, then use ETH, else this is
   * a ERC20 token address.
   */
  address public tokenAddress;

  constructor(address _tokenAddress) public {
    require(
      _tokenAddress == address(0) || IERC20(_tokenAddress).totalSupply() > 0,
      "INVALID_TOKEN"
    );
    tokenAddress = _tokenAddress;
  }

  /**
   * Ensures that the msg.sender has paid at least the price stated.
   *
   * With ETH, this means the function originally called was `payable` and the
   * transaction included at least the amount requested.
   *
   * Security: be wary of re-entrancy when calling this function.
   */
  function _chargeAtLeast(uint _price) internal {
    if (_price > 0) {
      if (tokenAddress == address(0)) {
        require(msg.value >= _price, "NOT_ENOUGH_FUNDS");
      } else {
        IERC20 token = IERC20(tokenAddress);
        uint balanceBefore = token.balanceOf(address(this));
        token.transferFrom(msg.sender, address(this), _price);

        // There are known bugs in popular ERC20 implements which means we cannot
        // trust the return value of `transferFrom`.  This require statement ensures
        // that a transfer occurred.
        require(
          token.balanceOf(address(this)) > balanceBefore,
          "TRANSFER_FAILED"
        );
      }
    }
  }

  /**
   * Transfers funds from the contract to the account provided.
   *
   * Security: be wary of re-entrancy when calling this function.
   */
  function _transfer(address _to, uint _amount) internal {
    if (_amount > 0) {
      if (tokenAddress == address(0)) {
        address(uint160(_to)).transfer(_amount);
      } else {
        IERC20 token = IERC20(tokenAddress);
        uint balanceBefore = token.balanceOf(_to);
        token.transfer(_to, _amount);

        // There are known bugs in popular ERC20 implements which means we cannot
        // trust the return value of `transferFrom`.  This require statement ensures
        // that a transfer occurred.
        require(token.balanceOf(_to) > balanceBefore, "TRANSFER_FAILED");
      }
    }
  }

  /**
   * Gets the current balance of the account provided.
   */
  function _getBalance(address _account) internal view returns (uint) {
    if (tokenAddress == address(0)) {
      return _account.balance;
    } else {
      return IERC20(tokenAddress).balanceOf(_account);
    }
  }
}

// File contracts/mixins/MixinDisableAndDestroy.sol

pragma solidity 0.5.7;

/**
 * @title Mixin allowing the Lock owner to disable a Lock (preventing new purchases)
 * and then destroy it.
 * @author HardlyDifficult
 * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
 * separates logically groupings of code to ease readability.
 */
contract MixinDisableAndDestroy is IERC721, Ownable, MixinFunds {
  // Used to disable payable functions when deprecating an old lock
  bool public isAlive;

  event Destroy(uint balance, address indexed owner);

  event Disable();

  constructor() internal {
    isAlive = true;
  }

  // Only allow usage when contract is Alive
  modifier onlyIfAlive() {
    require(isAlive, "LOCK_DEPRECATED");
    _;
  }

  /**
   * @dev Used to disable lock before migrating keys and/or destroying contract
   */
  function disableLock() external onlyOwner onlyIfAlive {
    emit Disable();
    isAlive = false;
  }

  /**
   * @dev Used to clean up old lock contracts from the blockchain
   * TODO: add a check to ensure all keys are INVALID!
   */
  function destroyLock() external onlyOwner {
    require(isAlive == false, "DISABLE_FIRST");

    emit Destroy(address(this).balance, msg.sender);

    // this will send any ETH or ERC20 held by the lock to the owner
    _transfer(msg.sender, _getBalance(address(this)));
    selfdestruct(msg.sender);

    // Note we don't clean up the `locks` data in Unlock.sol as it should not be necessary
    // and leaves some data behind ('Unlock.LockBalances') which may be helpful.
  }
}

// File contracts/interfaces/IUnlock.sol

pragma solidity 0.5.7;

/**
 * @title The Unlock Interface
 **/

interface IUnlock {
  // Events
  event NewLock(address indexed lockOwner, address indexed newLockAddress);

  event NewTokenURI(string tokenURI);

  event NewGlobalTokenSymbol(string tokenSymbol);

  // Use initialize instead of a constructor to support proxies (for upgradeability via zos).
  function initialize(address _owner) external;

  /**
   * @dev Create lock
   * This deploys a lock for a creator. It also keeps track of the deployed lock.
   * @param _tokenAddress set to the ERC20 token address, or 0 for ETH.
   */
  function createLock(
    uint _expirationDuration,
    address _tokenAddress,
    uint _keyPrice,
    uint _maxNumberOfKeys,
    string calldata _lockName
  ) external;

  /**
   * This function keeps track of the added GDP, as well as grants of discount tokens
   * to the referrer, if applicable.
   * The number of discount tokens granted is based on the value of the referal,
   * the current growth rate and the lock's discount token distribution rate
   * This function is invoked by a previously deployed lock only.
   */
  function recordKeyPurchase(
    uint _value,
    address _referrer // solhint-disable-line no-unused-vars
  ) external;

  /**
   * This function will keep track of consumed discounts by a given user.
   * It will also grant discount tokens to the creator who is granting the discount based on the
   * amount of discount and compensation rate.
   * This function is invoked by a previously deployed lock only.
   */
  function recordConsumedDiscount(
    uint _discount,
    uint _tokens // solhint-disable-line no-unused-vars
  ) external;

  /**
   * This function returns the discount available for a user, when purchasing a
   * a key from a lock.
   * This does not modify the state. It returns both the discount and the number of tokens
   * consumed to grant that discount.
   */
  function computeAvailableDiscountFor(
    address _purchaser, // solhint-disable-line no-unused-vars
    uint _keyPrice // solhint-disable-line no-unused-vars
  ) external view returns (uint discount, uint tokens);

  // Function to read the globalTokenURI field.
  function getGlobalBaseTokenURI() external view returns (string memory);

  /** Function to set the globalTokenURI field.
   *  Should throw if called by other than owner
   */
  function setGlobalBaseTokenURI(string calldata _URI) external;

  // Function to read the globalTokenSymbol field.
  function getGlobalTokenSymbol() external view returns (string memory);

  /** Function to set the globalTokenSymbol field.
   *  Should throw if called by other than owner.
   */
  function setGlobalTokenSymbol(string calldata _symbol) external;
}

// File contracts/mixins/MixinLockCore.sol

pragma solidity 0.5.7;

/**
 * @title Mixin for core lock data and functions.
 * @author HardlyDifficult
 * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
 * separates logically groupings of code to ease readability.
 */
contract MixinLockCore is Ownable, MixinFunds, MixinDisableAndDestroy {
  event PriceChanged(uint oldKeyPrice, uint keyPrice);

  event Withdrawal(address indexed _sender, uint _amount);

  // Unlock Protocol address
  // TODO: should we make that private/internal?
  IUnlock public unlockProtocol;

  // Duration in seconds for which the keys are valid, after creation
  // should we take a smaller type use less gas?
  // TODO: add support for a timestamp instead of duration
  uint public expirationDuration;

  // price in wei of the next key
  // TODO: allow support for a keyPriceCalculator which could set prices dynamically
  uint public keyPrice;

  // Max number of keys sold if the keyReleaseMechanism is public
  uint public maxNumberOfKeys;

  // A count of how many new key purchases there have been
  uint public numberOfKeysSold;

  // Ensure that the Lock has not sold all of its keys.
  modifier notSoldOut() {
    require(maxNumberOfKeys > numberOfKeysSold, "LOCK_SOLD_OUT");
    _;
  }

  constructor(
    uint _expirationDuration,
    uint _keyPrice,
    uint _maxNumberOfKeys
  ) internal {
    require(
      _expirationDuration <= 100 * 365 * 24 * 60 * 60,
      "MAX_EXPIRATION_100_YEARS"
    );
    unlockProtocol = IUnlock(msg.sender); // Make sure we link back to Unlock's smart contract.
    expirationDuration = _expirationDuration;
    keyPrice = _keyPrice;
    maxNumberOfKeys = _maxNumberOfKeys;
  }

  /**
   * @dev Called by owner to withdraw all funds from the lock.
   * TODO: consider allowing anybody to trigger this as long as it goes to owner anyway?
   */
  function withdraw() external onlyOwner {
    uint balance = _getBalance(address(this));
    require(balance > 0, "NOT_ENOUGH_FUNDS");
    // Security: re-entrancy not a risk as this is the last line of an external function
    _withdraw(balance);
  }

  /**
   * @dev Called by owner to partially withdraw funds from the lock.
   * TODO: consider allowing anybody to trigger this as long as it goes to owner anyway?
   */
  function partialWithdraw(uint _amount) external onlyOwner {
    require(_amount > 0, "GREATER_THAN_ZERO");
    uint balance = _getBalance(address(this));
    require(balance >= _amount, "NOT_ENOUGH_FUNDS");
    // Security: re-entrancy not a risk as this is the last line of an external function
    _withdraw(_amount);
  }

  /**
   * A function which lets the owner of the lock to change the price for future purchases.
   */
  function updateKeyPrice(uint _keyPrice) external onlyOwner onlyIfAlive {
    uint oldKeyPrice = keyPrice;
    keyPrice = _keyPrice;
    emit PriceChanged(oldKeyPrice, keyPrice);
  }

  /**
   * Public function which returns the total number of unique keys sold (both
   * expired and valid)
   */
  function totalSupply() public view returns (uint) {
    return numberOfKeysSold;
  }

  /**
   * @dev private version of the withdraw function which handles all withdrawals from the lock.
   *
   * Security: Be wary of re-entrancy when calling this.
   */
  function _withdraw(uint _amount) private {
    _transfer(Ownable.owner(), _amount);
    emit Withdrawal(msg.sender, _amount);
  }
}

// File contracts/mixins/MixinKeys.sol

pragma solidity 0.5.7;

/**
 * @title Mixin for managing `Key` data.
 * @author HardlyDifficult
 * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
 * separates logically groupings of code to ease readability.
 */
contract MixinKeys is Ownable, MixinLockCore {
  // The struct for a key
  struct Key {
    uint tokenId;
    uint expirationTimestamp;
  }

  // Called when the Lock owner expires a user's Key
  event ExpireKey(uint tokenId);

  // Keys
  // Each owner can have at most exactly one key
  // TODO: could we use public here? (this could be confusing though because it getter will
  // return 0 values when missing a key)
  mapping(address => Key) private keyByOwner;

  // Each tokenId can have at most exactly one owner at a time.
  // Returns 0 if the token does not exist
  // TODO: once we decouple tokenId from owner address (incl in js), then we can consider
  // merging this with numberOfKeysSold into an array instead.
  mapping(uint => address) private ownerByTokenId;

  // Addresses of owners are also stored in an array.
  // Addresses are never removed by design to avoid abuses around referals
  address[] public owners;

  // Ensures that an owner owns or has owned a key in the past
  modifier ownsOrHasOwnedKey(address _owner) {
    require(keyByOwner[_owner].expirationTimestamp > 0, "HAS_NEVER_OWNED_KEY");
    _;
  }

  // Ensures that an owner has a valid key
  modifier hasValidKey(address _owner) {
    require(getHasValidKey(_owner), "KEY_NOT_VALID");
    _;
  }

  // Ensures that a key has an owner
  modifier isKey(uint _tokenId) {
    require(ownerByTokenId[_tokenId] != address(0), "NO_SUCH_KEY");
    _;
  }

  // Ensure that the caller owns the key
  modifier onlyKeyOwner(uint _tokenId) {
    require(isKeyOwner(_tokenId, msg.sender), "ONLY_KEY_OWNER");
    _;
  }

  /**
   * A function which lets the owner of the lock expire a users' key.
   */
  function expireKeyFor(address _owner) public onlyOwner hasValidKey(_owner) {
    Key storage key = keyByOwner[_owner];
    key.expirationTimestamp = block.timestamp; // Effectively expiring the key
    emit ExpireKey(key.tokenId);
  }

  /**
   * In the specific case of a Lock, each owner can own only at most 1 key.
   * @return The number of NFTs owned by `_owner`, either 0 or 1.
   */
  function balanceOf(address _owner) external view returns (uint) {
    require(_owner != address(0), "INVALID_ADDRESS");
    return getHasValidKey(_owner) ? 1 : 0;
  }

  /**
   * Checks if the user has a non-expired key.
   */
  function getHasValidKey(address _owner) public view returns (bool) {
    return keyByOwner[_owner].expirationTimestamp > block.timestamp;
  }

  /**
   * @notice Find the tokenId for a given user
   * @return The tokenId of the NFT, else revert
   */
  function getTokenIdFor(
    address _account
  ) external view hasValidKey(_account) returns (uint) {
    return keyByOwner[_account].tokenId;
  }

  /**
   * A function which returns a subset of the keys for this Lock as an array
   * @param _page the page of key owners requested when faceted by page size
   * @param _pageSize the number of Key Owners requested per page
   */
  function getOwnersByPage(
    uint _page,
    uint _pageSize
  ) public view returns (address[] memory) {
    require(owners.length > 0, "NO_OUTSTANDING_KEYS");
    uint pageSize = _pageSize;
    uint _startIndex = _page * pageSize;
    uint endOfPageIndex;

    if (_startIndex + pageSize > owners.length) {
      endOfPageIndex = owners.length;
      pageSize = owners.length - _startIndex;
    } else {
      endOfPageIndex = (_startIndex + pageSize);
    }

    // new temp in-memory array to hold pageSize number of requested owners:
    address[] memory ownersByPage = new address[](pageSize);
    uint pageIndex = 0;

    // Build the requested set of owners into a new temporary array:
    for (uint i = _startIndex; i < endOfPageIndex; i++) {
      ownersByPage[pageIndex] = owners[i];
      pageIndex++;
    }

    return ownersByPage;
  }

  /**
   * Checks if the given address owns the given tokenId.
   */
  function isKeyOwner(
    uint _tokenId,
    address _owner
  ) public view returns (bool) {
    return ownerByTokenId[_tokenId] == _owner;
  }

  /**
   * @dev Returns the key's ExpirationTimestamp field for a given owner.
   * @param _owner address of the user for whom we search the key
   */
  function keyExpirationTimestampFor(
    address _owner
  ) public view ownsOrHasOwnedKey(_owner) returns (uint timestamp) {
    return keyByOwner[_owner].expirationTimestamp;
  }

  /**
   * Public function which returns the total number of unique owners (both expired
   * and valid).  This may be larger than totalSupply.
   */
  function numberOfOwners() public view returns (uint) {
    return owners.length;
  }

  /**
   * @notice ERC721: Find the owner of an NFT
   * @return The address of the owner of the NFT, if applicable
   */
  function ownerOf(
    uint _tokenId
  ) public view isKey(_tokenId) returns (address) {
    return ownerByTokenId[_tokenId];
  }

  /**
   * Assigns the key a new tokenId (from numberOfKeysSold) if it does not already have
   * one assigned.
   */
  function _assignNewTokenId(Key storage _key) internal {
    if (_key.tokenId == 0) {
      // This is a brand new owner, else an owner of an expired key buying an extension.
      // We increment the tokenId counter
      numberOfKeysSold++;
      // we assign the incremented `numberOfKeysSold` as the tokenId for the new key
      _key.tokenId = numberOfKeysSold;
    }
  }

  /**
   * Records the owner of a given tokenId
   */
  function _recordOwner(address _owner, uint _tokenId) internal {
    if (ownerByTokenId[_tokenId] != _owner) {
      // TODO: this may include duplicate entries
      owners.push(_owner);
      // We register the owner of the tokenID
      ownerByTokenId[_tokenId] = _owner;
    }
  }

  /**
   * Returns the Key struct for the given owner.
   */
  function _getKeyFor(address _owner) internal view returns (Key storage) {
    return keyByOwner[_owner];
  }
}

// File contracts/mixins/MixinApproval.sol

pragma solidity 0.5.7;

/**
 * @title Mixin for the Approval related functions needed to meet the ERC721
 * standard.
 * @author HardlyDifficult
 * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
 * separates logically groupings of code to ease readability.
 */
contract MixinApproval is IERC721, MixinDisableAndDestroy, MixinKeys {
  // Keeping track of approved transfers
  // This is a mapping of addresses which have approved
  // the transfer of a key to another address where their key can be transfered
  // Note: the approver may actually NOT have a key... and there can only
  // be a single approved beneficiary
  // Note 2: for transfer, both addresses will be different
  // Note 3: for sales (new keys on restricted locks), both addresses will be the same
  mapping(uint => address) private approved;

  // Keeping track of approved operators for a Key owner.
  // Since an owner can have up to 1 Key, this is similiar to above
  // but the approval does not reset when a transfer occurs.
  mapping(address => mapping(address => bool)) private ownerToOperatorApproved;

  // Ensure that the caller has a key
  // or that the caller has been approved
  // for ownership of that key
  modifier onlyKeyOwnerOrApproved(uint _tokenId) {
    require(
      isKeyOwner(_tokenId, msg.sender) ||
        _isApproved(_tokenId, msg.sender) ||
        isApprovedForAll(ownerOf(_tokenId), msg.sender),
      "ONLY_KEY_OWNER_OR_APPROVED"
    );
    _;
  }

  /**
   * This approves _approved to get ownership of _tokenId.
   * Note: that since this is used for both purchase and transfer approvals
   * the approved token may not exist.
   */
  function approve(
    address _approved,
    uint _tokenId
  ) external payable onlyIfAlive onlyKeyOwnerOrApproved(_tokenId) {
    require(msg.sender != _approved, "APPROVE_SELF");

    approved[_tokenId] = _approved;
    emit Approval(ownerOf(_tokenId), _approved, _tokenId);
  }

  /**
   * @dev Sets or unsets the approval of a given operator
   * An operator is allowed to transfer all tokens of the sender on their behalf
   * @param _to operator address to set the approval
   * @param _approved representing the status of the approval to be set
   */
  function setApprovalForAll(address _to, bool _approved) external onlyIfAlive {
    require(_to != msg.sender, "APPROVE_SELF");
    ownerToOperatorApproved[msg.sender][_to] = _approved;
    emit ApprovalForAll(msg.sender, _to, _approved);
  }

  /**
   * external version
   * Will return the approved recipient for a key, if any.
   */
  function getApproved(uint _tokenId) external view returns (address) {
    return _getApproved(_tokenId);
  }

  /**
   * @dev Tells whether an operator is approved by a given owner
   * @param _owner owner address which you want to query the approval of
   * @param _operator operator address which you want to query the approval of
   * @return bool whether the given operator is approved by the given owner
   */
  function isApprovedForAll(
    address _owner,
    address _operator
  ) public view returns (bool) {
    return ownerToOperatorApproved[_owner][_operator];
  }

  /**
   * @dev Checks if the given user is approved to transfer the tokenId.
   */
  function _isApproved(
    uint _tokenId,
    address _user
  ) internal view returns (bool) {
    return approved[_tokenId] == _user;
  }

  /**
   * Will return the approved recipient for a key transfer or ownership.
   * Note: this does not check that a corresponding key
   * actually exists.
   */
  function _getApproved(uint _tokenId) internal view returns (address) {
    address approvedRecipient = approved[_tokenId];
    require(approvedRecipient != address(0), "NONE_APPROVED");
    return approvedRecipient;
  }

  /**
   * @dev Function to clear current approval of a given token ID
   * @param _tokenId uint256 ID of the token to be transferred
   */
  function _clearApproval(uint256 _tokenId) internal {
    if (approved[_tokenId] != address(0)) {
      approved[_tokenId] = address(0);
    }
  }
}

// File contracts/mixins/MixinGrantKeys.sol

pragma solidity 0.5.7;

/**
 * @title Mixin allowing the Lock owner to grant / gift keys to users.
 * @author HardlyDifficult
 * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
 * separates logically groupings of code to ease readability.
 */
contract MixinGrantKeys is IERC721, Ownable, MixinKeys {
  /**
   * Allows the Lock owner to give a user a key with no charge.
   */
  function grantKey(
    address _recipient,
    uint _expirationTimestamp
  ) external onlyOwner {
    _grantKey(_recipient, _expirationTimestamp);
  }

  /**
   * Allows the Lock owner to give a collection of users a key with no charge.
   * All keys granted have the same expiration date.
   */
  function grantKeys(
    address[] calldata _recipients,
    uint _expirationTimestamp
  ) external onlyOwner {
    for (uint i = 0; i < _recipients.length; i++) {
      _grantKey(_recipients[i], _expirationTimestamp);
    }
  }

  /**
   * Allows the Lock owner to give a collection of users a key with no charge.
   * Each key may be assigned a different expiration date.
   */
  function grantKeys(
    address[] calldata _recipients,
    uint[] calldata _expirationTimestamps
  ) external onlyOwner {
    for (uint i = 0; i < _recipients.length; i++) {
      _grantKey(_recipients[i], _expirationTimestamps[i]);
    }
  }

  /**
   * Give a key to the given user
   */
  function _grantKey(address _recipient, uint _expirationTimestamp) private {
    require(_recipient != address(0), "INVALID_ADDRESS");

    Key storage toKey = _getKeyFor(_recipient);
    require(
      _expirationTimestamp > toKey.expirationTimestamp,
      "ALREADY_OWNS_KEY"
    );

    _assignNewTokenId(toKey);
    _recordOwner(_recipient, toKey.tokenId);
    toKey.expirationTimestamp = _expirationTimestamp;

    // trigger event
    emit Transfer(
      address(0), // This is a creation.
      _recipient,
      toKey.tokenId
    );
  }
}

// File contracts/UnlockUtils.sol

pragma solidity 0.5.7;

// This contract provides some utility methods for use with the unlock protocol smart contracts.
// Borrowed from:
// https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol#L943

contract UnlockUtils {
  function strConcat(
    string memory _a,
    string memory _b,
    string memory _c,
    string memory _d
  ) public pure returns (string memory _concatenatedString) {
    bytes memory _ba = bytes(_a);
    bytes memory _bb = bytes(_b);
    bytes memory _bc = bytes(_c);
    bytes memory _bd = bytes(_d);
    string memory abcd = new string(
      _ba.length + _bb.length + _bc.length + _bd.length
    );
    bytes memory babcd = bytes(abcd);
    uint k = 0;
    uint i = 0;
    for (i = 0; i < _ba.length; i++) {
      babcd[k++] = _ba[i];
    }
    for (i = 0; i < _bb.length; i++) {
      babcd[k++] = _bb[i];
    }
    for (i = 0; i < _bc.length; i++) {
      babcd[k++] = _bc[i];
    }
    for (i = 0; i < _bd.length; i++) {
      babcd[k++] = _bd[i];
    }
    return string(babcd);
  }

  function uint2Str(uint _i) public pure returns (string memory _uintAsString) {
    // make a copy of the param to avoid security/no-assign-params error
    uint c = _i;
    if (_i == 0) {
      return "0";
    }
    uint j = _i;
    uint len;
    while (j != 0) {
      len++;
      j /= 10;
    }
    bytes memory bstr = new bytes(len);
    uint k = len - 1;
    while (c != 0) {
      bstr[k--] = bytes1(uint8(48 + (c % 10)));
      c /= 10;
    }
    return string(bstr);
  }

  function address2Str(address _addr) public pure returns (string memory) {
    bytes32 value = bytes32(uint256(_addr));
    bytes memory alphabet = "0123456789abcdef";
    bytes memory str = new bytes(42);
    str[0] = "0";
    str[1] = "x";
    for (uint i = 0; i < 20; i++) {
      str[2 + i * 2] = alphabet[uint8(value[i + 12] >> 4)];
      str[3 + i * 2] = alphabet[uint8(value[i + 12] & 0x0f)];
    }
    return string(str);
  }
}

// File contracts/mixins/MixinLockMetadata.sol

pragma solidity 0.5.7;

/**
 * @title Mixin for metadata about the Lock.
 * @author HardlyDifficult
 * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
 * separates logically groupings of code to ease readability.
 */
contract MixinLockMetadata is
  IERC721,
  ERC165,
  Ownable,
  MixinLockCore,
  UnlockUtils,
  MixinKeys
{
  /// A descriptive name for a collection of NFTs in this contract.Defaults to "Unlock-Protocol" but is settable by lock owner
  string private lockName;

  /// An abbreviated name for NFTs in this contract. Defaults to "KEY" but is settable by lock owner
  string private lockSymbol;

  // the base Token URI for this Lock. If not set by lock owner, the global URI stored in Unlock is used.
  string private baseTokenURI;

  event NewLockSymbol(string symbol);

  constructor(string memory _lockName) internal {
    lockName = _lockName;
    // registering the optional erc721 metadata interface with ERC165.sol using
    // the ID specified in the standard: https://eips.ethereum.org/EIPS/eip-721
    _registerInterface(0x5b5e139f);
  }

  /**
   * Allows the Lock owner to assign a descriptive name for this Lock.
   */
  function updateLockName(string calldata _lockName) external onlyOwner {
    lockName = _lockName;
  }

  /**
   * @dev Gets the token name
   * @return string representing the token name
   */
  function name() external view returns (string memory) {
    return lockName;
  }

  /**
   * Allows the Lock owner to assign a Symbol for this Lock.
   */
  function updateLockSymbol(string calldata _lockSymbol) external onlyOwner {
    lockSymbol = _lockSymbol;
    emit NewLockSymbol(_lockSymbol);
  }

  /**
   * @dev Gets the token symbol
   * @return string representing the token name
   */
  function symbol() external view returns (string memory) {
    if (bytes(lockSymbol).length == 0) {
      return unlockProtocol.getGlobalTokenSymbol();
    } else {
      return lockSymbol;
    }
  }

  /**
   * Allows the Lock owner to update the baseTokenURI for this Lock.
   */
  function setBaseTokenURI(string calldata _baseTokenURI) external onlyOwner {
    baseTokenURI = _baseTokenURI;
  }

  /**  @notice A distinct Uniform Resource Identifier (URI) for a given asset.
   * @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
   *  3986. The URI may point to a JSON file that conforms to the "ERC721
   *  Metadata JSON Schema".
   * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
   */
  function tokenURI(
    uint256 _tokenId
  ) external view isKey(_tokenId) returns (string memory) {
    string memory URI;
    if (bytes(baseTokenURI).length == 0) {
      URI = unlockProtocol.getGlobalBaseTokenURI();
    } else {
      URI = baseTokenURI;
    }

    return
      UnlockUtils.strConcat(
        URI,
        UnlockUtils.address2Str(address(this)),
        "/",
        UnlockUtils.uint2Str(_tokenId)
      );
  }
}

// File contracts/mixins/MixinNoFallback.sol

pragma solidity 0.5.7;

/**
 * @title Mixin for the fallback function implementation, which simply reverts.
 * @author HardlyDifficult
 * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
 * separates logically groupings of code to ease readability.
 */
contract MixinNoFallback {
  /**
   * @dev the fallback function should not be used.  This explicitly reverts
   * to ensure it's never used.
   */
  function() external {
    revert("NO_FALLBACK");
  }
}

// File openzeppelin-solidity/contracts/math/SafeMath.sol@v2.2.0

pragma solidity ^0.5.2;

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
  /**
   * @dev Multiplies two unsigned integers, reverts on overflow.
   */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b);

    return c;
  }

  /**
   * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
   */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // Solidity only automatically asserts when dividing by 0
    require(b > 0);
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
   * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
   */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;

    return c;
  }

  /**
   * @dev Adds two unsigned integers, reverts on overflow.
   */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);

    return c;
  }

  /**
   * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
   * reverts when dividing by zero.
   */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}

// File contracts/mixins/MixinPurchase.sol

pragma solidity 0.5.7;

/**
 * @title Mixin for the purchase-related functions.
 * @author HardlyDifficult
 * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
 * separates logically groupings of code to ease readability.
 */
contract MixinPurchase is
  MixinFunds,
  MixinDisableAndDestroy,
  MixinLockCore,
  MixinKeys
{
  using SafeMath for uint;

  /**
   * @dev Purchase function, public version, with no referrer.
   * @param _recipient address of the recipient of the purchased key
   */
  function purchaseFor(address _recipient) external payable onlyIfAlive {
    return _purchaseFor(_recipient, address(0));
  }

  /**
   * @dev Purchase function, public version, with referrer.
   * @param _recipient address of the recipient of the purchased key
   * @param _referrer address of the user making the referral
   */
  function purchaseForFrom(
    address _recipient,
    address _referrer
  ) external payable onlyIfAlive hasValidKey(_referrer) {
    return _purchaseFor(_recipient, _referrer);
  }

  /**
   * @dev Purchase function: this lets a user purchase a key from the lock for another user
   * @param _recipient address of the recipient of the purchased key
   * This will fail if
   *  - the keyReleaseMechanism is private
   *  - the keyReleaseMechanism is Approved and the recipient has not been previously approved
   *  - the amount value is smaller than the price
   *  - the recipient already owns a key
   * TODO: next version of solidity will allow for message to be added to require.
   */
  function _purchaseFor(
    address _recipient,
    address _referrer
  ) private notSoldOut {
    // solhint-disable-line function-max-lines
    require(_recipient != address(0), "INVALID_ADDRESS");

    // Let's get the actual price for the key from the Unlock smart contract
    uint discount;
    uint tokens;
    uint inMemoryKeyPrice = keyPrice;
    (discount, tokens) = unlockProtocol.computeAvailableDiscountFor(
      _recipient,
      inMemoryKeyPrice
    );
    uint netPrice = inMemoryKeyPrice;
    if (discount > inMemoryKeyPrice) {
      netPrice = 0;
    } else {
      // SafeSub not required as the if statement already confirmed `inMemoryKeyPrice - discount` cannot underflow
      netPrice = inMemoryKeyPrice - discount;
    }

    // We explicitly allow for greater amounts of ETH to allow 'donations'
    _chargeAtLeast(netPrice);

    // Assign the key
    Key storage toKey = _getKeyFor(_recipient);
    uint previousExpiration = toKey.expirationTimestamp;
    if (toKey.tokenId == 0) {
      _assignNewTokenId(toKey);
      _recordOwner(_recipient, toKey.tokenId);
      // SafeAdd is not required here since expirationDuration is capped to a tiny value
      // (relative to the size of a uint)
      toKey.expirationTimestamp = block.timestamp + expirationDuration;
    } else {
      // This is an existing owner trying to extend their key
      toKey.expirationTimestamp = previousExpiration.add(expirationDuration);
    }

    if (discount > 0) {
      unlockProtocol.recordConsumedDiscount(discount, tokens);
    }

    unlockProtocol.recordKeyPurchase(netPrice, _referrer);

    // trigger event
    emit Transfer(
      address(0), // This is a creation.
      _recipient,
      numberOfKeysSold
    );
  }
}

// File openzeppelin-solidity/contracts/cryptography/ECDSA.sol@v2.2.0

pragma solidity ^0.5.2;

/**
 * @title Elliptic curve signature operations
 * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
 * TODO Remove this library once solidity supports passing a signature to ecrecover.
 * See https://github.com/ethereum/solidity/issues/864
 */

library ECDSA {
  /**
   * @dev Recover signer address from a message by using their signature
   * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
   * @param signature bytes signature, the signature is generated using web3.eth.sign()
   */
  function recover(
    bytes32 hash,
    bytes memory signature
  ) internal pure returns (address) {
    // Check the signature length
    if (signature.length != 65) {
      return (address(0));
    }

    // Divide the signature in r, s and v variables
    bytes32 r;
    bytes32 s;
    uint8 v;

    // ecrecover takes the signature parameters, and the only way to get them
    // currently is to use assembly.
    // solhint-disable-next-line no-inline-assembly
    assembly {
      r := mload(add(signature, 0x20))
      s := mload(add(signature, 0x40))
      v := byte(0, mload(add(signature, 0x60)))
    }

    // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
    // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
    // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
    // signatures from current libraries generate a unique signature with an s-value in the lower half order.
    //
    // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
    // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
    // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
    // these malleable signatures as well.
    if (
      uint256(s) >
      0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
    ) {
      return address(0);
    }

    if (v != 27 && v != 28) {
      return address(0);
    }

    // If the signature is valid (and not malleable), return the signer address
    return ecrecover(hash, v, r, s);
  }

  /**
   * toEthSignedMessageHash
   * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
   * and hash the result
   */
  function toEthSignedMessageHash(
    bytes32 hash
  ) internal pure returns (bytes32) {
    // 32 is the length in bytes of hash,
    // enforced by the type signature above
    return
      keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
  }
}

// File contracts/mixins/MixinRefunds.sol

pragma solidity 0.5.7;

contract MixinRefunds is Ownable, MixinFunds, MixinLockCore, MixinKeys {
  using SafeMath for uint;

  // CancelAndRefund will return funds based on time remaining minus this penalty.
  // This is calculated as `proRatedRefund * refundPenaltyNumerator / refundPenaltyDenominator`.
  uint public refundPenaltyNumerator = 1;
  uint public refundPenaltyDenominator = 10;

  // Stores a nonce per user to use for signed messages
  mapping(address => uint) public keyOwnerToNonce;

  event CancelKey(
    uint indexed tokenId,
    address indexed owner,
    address indexed sendTo,
    uint refund
  );

  event RefundPenaltyChanged(
    uint oldRefundPenaltyNumerator,
    uint oldRefundPenaltyDenominator,
    uint refundPenaltyNumerator,
    uint refundPenaltyDenominator
  );

  /**
   * @dev Destroys the user's key and sends a refund based on the amount of time remaining.
   */
  function cancelAndRefund() external {
    _cancelAndRefund(msg.sender);
  }

  /**
   * @dev Cancels a key owned by a different user and sends the funds to the msg.sender.
   * @param _keyOwner this user's key will be canceled
   * @param _signature getCancelAndRefundApprovalHash signed by the _keyOwner
   */
  function cancelAndRefundFor(
    address _keyOwner,
    bytes calldata _signature
  ) external {
    require(
      ECDSA.recover(
        ECDSA.toEthSignedMessageHash(
          getCancelAndRefundApprovalHash(_keyOwner, msg.sender)
        ),
        _signature
      ) == _keyOwner,
      "INVALID_SIGNATURE"
    );

    keyOwnerToNonce[_keyOwner]++;
    _cancelAndRefund(_keyOwner);
  }

  /**
   * @dev Increments the current nonce for the msg.sender.
   * This can be used to invalidate a previously signed message.
   */
  function incrementNonce() external {
    keyOwnerToNonce[msg.sender]++;
  }

  /**
   * Allow the owner to change the refund penalty.
   */
  function updateRefundPenalty(
    uint _refundPenaltyNumerator,
    uint _refundPenaltyDenominator
  ) external onlyOwner {
    require(_refundPenaltyDenominator != 0, "INVALID_RATE");

    emit RefundPenaltyChanged(
      refundPenaltyNumerator,
      refundPenaltyDenominator,
      _refundPenaltyNumerator,
      _refundPenaltyDenominator
    );
    refundPenaltyNumerator = _refundPenaltyNumerator;
    refundPenaltyDenominator = _refundPenaltyDenominator;
  }

  /**
   * @dev Determines how much of a refund a key owner would receive if they issued
   * a cancelAndRefund block.timestamp.
   * Note that due to the time required to mine a tx, the actual refund amount will be lower
   * than what the user reads from this call.
   */
  function getCancelAndRefundValueFor(
    address _owner
  ) external view returns (uint refund) {
    return _getCancelAndRefundValue(_owner);
  }

  /**
   * @dev returns the hash to sign in order to allow another user to cancel on your behalf.
   */
  function getCancelAndRefundApprovalHash(
    address _keyOwner,
    address _txSender
  ) public view returns (bytes32 approvalHash) {
    return
      keccak256(
        abi.encodePacked(
          // Approval is specific to this Lock
          address(this),
          // Approval enables only one cancel call
          keyOwnerToNonce[_keyOwner],
          // Approval allows only one account to broadcast the tx
          _txSender
        )
      );
  }

  /**
   * @dev cancels the key for the given keyOwner and sends the refund to the msg.sender.
   */
  function _cancelAndRefund(address _keyOwner) internal {
    Key storage key = _getKeyFor(_keyOwner);

    uint refund = _getCancelAndRefundValue(_keyOwner);

    emit CancelKey(key.tokenId, _keyOwner, msg.sender, refund);
    // expirationTimestamp is a proxy for hasKey, setting this to `block.timestamp` instead
    // of 0 so that we can still differentiate hasKey from hasValidKey.
    key.expirationTimestamp = block.timestamp;

    if (refund > 0) {
      // Security: doing this last to avoid re-entrancy concerns
      _transfer(msg.sender, refund);
    }
  }

  /**
   * @dev Determines how much of a refund a key owner would receive if they issued
   * a cancelAndRefund now.
   * @param _owner The owner of the key check the refund value for.
   */
  function _getCancelAndRefundValue(
    address _owner
  ) private view hasValidKey(_owner) returns (uint refund) {
    Key storage key = _getKeyFor(_owner);
    // Math: safeSub is not required since `hasValidKey` confirms timeRemaining is positive
    uint timeRemaining = key.expirationTimestamp - block.timestamp;
    if (timeRemaining >= expirationDuration) {
      refund = keyPrice;
    } else {
      // Math: using safeMul in case keyPrice or timeRemaining is very large
      refund = keyPrice.mul(timeRemaining) / expirationDuration;
    }
    uint penalty = keyPrice.mul(refundPenaltyNumerator) /
      refundPenaltyDenominator;
    if (refund > penalty) {
      // Math: safeSub is not required since the if confirms this won't underflow
      refund -= penalty;
    } else {
      refund = 0;
    }
  }
}

// File openzeppelin-solidity/contracts/utils/Address.sol@v2.2.0

pragma solidity ^0.5.2;

/**
 * Utility library of inline functions on addresses
 */
library Address {
  /**
   * Returns whether the target address is a contract
   * @dev This function will return false if invoked during the constructor of a contract,
   * as the code is not actually created until after the constructor finishes.
   * @param account address of the account to check
   * @return whether the target address is a contract
   */
  function isContract(address account) internal view returns (bool) {
    uint256 size;
    // XXX Currently there is no better way to check if there is a contract in an address
    // than to check the size of the code at that address.
    // See https://ethereum.stackexchange.com/a/14016/36603
    // for more details about how this works.
    // TODO Check this again before the Serenity release, because all addresses will be
    // contracts then.
    // solhint-disable-next-line no-inline-assembly
    assembly {
      size := extcodesize(account)
    }
    return size > 0;
  }
}

// File contracts/mixins/MixinTransfer.sol

pragma solidity 0.5.7;

/**
 * @title Mixin for the transfer-related functions needed to meet the ERC721
 * standard.
 * @dev `Mixins` are a design pattern seen in the 0x contracts.  It simply
 * separates logically groupings of code to ease readability.
 */

contract MixinTransfer is MixinFunds, MixinLockCore, MixinKeys, MixinApproval {
  using SafeMath for uint;
  using Address for address;

  event TransferFeeChanged(
    uint oldTransferFeeNumerator,
    uint oldTransferFeeDenominator,
    uint transferFeeNumerator,
    uint transferFeeDenominator
  );

  // 0x150b7a02 == bytes4(keccak256('onERC721Received(address,address,uint256,bytes)'))
  bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

  // The fee relative to keyPrice to charge when transfering a Key to another account
  // (potentially on a 0x marketplace).
  // This is calculated as `keyPrice * transferFeeNumerator / transferFeeDenominator`.
  uint public transferFeeNumerator = 0;
  uint public transferFeeDenominator = 100;

  /**
   * This is payable because at some point we want to allow the LOCK to capture a fee on 2ndary
   * market transactions...
   */
  function transferFrom(
    address _from,
    address _recipient,
    uint _tokenId
  )
    public
    payable
    onlyIfAlive
    hasValidKey(_from)
    onlyKeyOwnerOrApproved(_tokenId)
  {
    require(_recipient != address(0), "INVALID_ADDRESS");
    _chargeAtLeast(getTransferFee(_from));

    Key storage fromKey = _getKeyFor(_from);
    Key storage toKey = _getKeyFor(_recipient);

    uint previousExpiration = toKey.expirationTimestamp;

    if (toKey.tokenId == 0) {
      toKey.tokenId = fromKey.tokenId;
      _recordOwner(_recipient, toKey.tokenId);
    }

    if (previousExpiration <= block.timestamp) {
      // The recipient did not have a key, or had a key but it expired. The new expiration is the
      // sender's key expiration
      // an expired key is no longer a valid key, so the new tokenID is the sender's tokenID
      toKey.expirationTimestamp = fromKey.expirationTimestamp;
      toKey.tokenId = fromKey.tokenId;
      _recordOwner(_recipient, _tokenId);
    } else {
      // The recipient has a non expired key. We just add them the corresponding remaining time
      // SafeSub is not required since the if confirms `previousExpiration - block.timestamp` cannot underflow
      toKey.expirationTimestamp = fromKey.expirationTimestamp.add(
        previousExpiration - block.timestamp
      );
    }

    // Effectively expiring the key for the previous owner
    fromKey.expirationTimestamp = block.timestamp;

    // Set the tokenID to 0 for the previous owner to avoid duplicates
    fromKey.tokenId = 0;

    // Clear any previous approvals
    _clearApproval(_tokenId);

    // trigger event
    emit Transfer(_from, _recipient, _tokenId);
  }

  /**
   * @notice Transfers the ownership of an NFT from one address to another address
   * @dev This works identically to the other function with an extra data parameter,
   *  except this function just sets data to ''
   * @param _from The current owner of the NFT
   * @param _to The new owner
   * @param _tokenId The NFT to transfer
   */
  function safeTransferFrom(
    address _from,
    address _to,
    uint _tokenId
  ) external payable {
    safeTransferFrom(_from, _to, _tokenId, "");
  }

  /**
   * @notice Transfers the ownership of an NFT from one address to another address.
   * When transfer is complete, this functions
   *  checks if `_to` is a smart contract (code size > 0). If so, it calls
   *  `onERC721Received` on `_to` and throws if the return value is not
   *  `bytes4(keccak256('onERC721Received(address,address,uint,bytes)'))`.
   * @param _from The current owner of the NFT
   * @param _to The new owner
   * @param _tokenId The NFT to transfer
   * @param _data Additional data with no specified format, sent in call to `_to`
   */
  function safeTransferFrom(
    address _from,
    address _to,
    uint _tokenId,
    bytes memory _data
  )
    public
    payable
    onlyIfAlive
    onlyKeyOwnerOrApproved(_tokenId)
    hasValidKey(ownerOf(_tokenId))
  {
    transferFrom(_from, _to, _tokenId);
    require(
      _checkOnERC721Received(_from, _to, _tokenId, _data),
      "NON_COMPLIANT_ERC721_RECEIVER"
    );
  }

  /**
   * Allow the Lock owner to change the transfer fee.
   */
  function updateTransferFee(
    uint _transferFeeNumerator,
    uint _transferFeeDenominator
  ) external onlyOwner {
    require(_transferFeeDenominator != 0, "INVALID_RATE");
    emit TransferFeeChanged(
      transferFeeNumerator,
      transferFeeDenominator,
      _transferFeeNumerator,
      _transferFeeDenominator
    );
    transferFeeNumerator = _transferFeeNumerator;
    transferFeeDenominator = _transferFeeDenominator;
  }

  /**
   * Determines how much of a fee a key owner would need to pay in order to
   * transfer the key to another account.  This is pro-rated so the fee goes down
   * overtime.
   * @param _owner The owner of the key check the transfer fee for.
   */
  function getTransferFee(
    address _owner
  ) public view hasValidKey(_owner) returns (uint) {
    Key storage key = _getKeyFor(_owner);
    // Math: safeSub is not required since `hasValidKey` confirms timeRemaining is positive
    uint timeRemaining = key.expirationTimestamp - block.timestamp;
    uint fee;
    if (timeRemaining >= expirationDuration) {
      // Max the potential impact of this fee for keys with long durations remaining
      fee = keyPrice;
    } else {
      // Math: using safeMul in case keyPrice or timeRemaining is very large
      fee = keyPrice.mul(timeRemaining) / expirationDuration;
    }
    return fee.mul(transferFeeNumerator) / transferFeeDenominator;
  }

  /**
   * @dev Internal function to invoke `onERC721Received` on a target address
   * The call is not executed if the target address is not a contract
   * @param from address representing the previous owner of the given token ID
   * @param to target address that will receive the tokens
   * @param tokenId uint256 ID of the token to be transferred
   * @param _data bytes optional data to send along with the call
   * @return whether the call correctly returned the expected magic value
   */
  function _checkOnERC721Received(
    address from,
    address to,
    uint256 tokenId,
    bytes memory _data
  ) internal returns (bool) {
    if (!to.isContract()) {
      return true;
    }
    bytes4 retval = IERC721Receiver(to).onERC721Received(
      msg.sender,
      from,
      tokenId,
      _data
    );
    return (retval == _ERC721_RECEIVED);
  }
}

// File contracts/PublicLock.sol

pragma solidity 0.5.7;

/**
 * @title The Lock contract
 * @author Julien Genestoux (unlock-protocol.com)
 * Eventually: implement ERC721.
 * @dev ERC165 allows our contract to be queried to determine whether it implements a given interface.
 * Every ERC-721 compliant contract must implement the ERC165 interface.
 * https://eips.ethereum.org/EIPS/eip-721
 */
contract PublicLock is
  IERC721,
  MixinNoFallback,
  ERC165,
  Ownable,
  ERC721Holder,
  MixinFunds,
  MixinDisableAndDestroy,
  MixinLockCore,
  MixinKeys,
  MixinLockMetadata,
  MixinGrantKeys,
  MixinPurchase,
  MixinApproval,
  MixinTransfer,
  MixinRefunds
{
  constructor(
    address _owner,
    uint _expirationDuration,
    address _tokenAddress,
    uint _keyPrice,
    uint _maxNumberOfKeys,
    string memory _lockName
  )
    public
    MixinFunds(_tokenAddress)
    MixinLockCore(_expirationDuration, _keyPrice, _maxNumberOfKeys)
    MixinLockMetadata(_lockName)
  {
    // registering the interface for erc721 with ERC165.sol using
    // the ID specified in the standard: https://eips.ethereum.org/EIPS/eip-721
    _registerInterface(0x80ac58cd);
    // We must manually initialize Ownable.sol
    Ownable.initialize(_owner);
  }

  // The version number of the current implementation on this network
  function publicLockVersion() external pure returns (uint16) {
    return 3;
  }
}

// File contracts/Unlock.sol

pragma solidity 0.5.7;

/**
 * @title The Unlock contract
 * @author Julien Genestoux (unlock-protocol.com)
 * This smart contract has 3 main roles:
 *  1. Distribute discounts to discount token holders
 *  2. Grant dicount tokens to users making referrals and/or publishers granting discounts.
 *  3. Create & deploy Public Lock contracts.
 * In order to achieve these 3 elements, it keeps track of several things such as
 *  a. Deployed locks addresses and balances of discount tokens granted by each lock.
 *  b. The total network product (sum of all key sales, net of discounts)
 *  c. Total of discounts granted
 *  d. Balances of discount tokens, including 'frozen' tokens (which have been used to claim
 * discounts and cannot be used/transfered for a given period)
 *  e. Growth rate of Network Product
 *  f. Growth rate of Discount tokens supply
 * The smart contract has an owner who only can perform the following
 *  - Upgrades
 *  - Change in golden rules (20% of GDP available in discounts, and supply growth rate is at most
 * 50% of GNP growth rate)
 * NOTE: This smart contract is partially implemented for now until enough Locks are deployed and
 * in the wild.
 * The partial implementation includes the following features:
 *  a. Keeping track of deployed locks
 *  b. Keeping track of GNP
 */

/// @dev Must list the direct base contracts in the order from “most base-like” to “most derived”.
/// https://solidity.readthedocs.io/en/latest/contracts.html#multiple-inheritance-and-linearization
contract Unlock is IUnlock, MixinNoFallback, Initializable, Ownable {
  /**
   * The struct for a lock
   * We use deployed to keep track of deployments.
   * This is required because both totalSales and yieldedDiscountTokens are 0 when initialized,
   * which would be the same values when the lock is not set.
   */
  struct LockBalances {
    bool deployed;
    uint totalSales; // This is in wei
    uint yieldedDiscountTokens;
  }

  modifier onlyFromDeployedLock() {
    require(locks[msg.sender].deployed, "ONLY_LOCKS");
    _;
  }

  uint public grossNetworkProduct;

  uint public totalDiscountGranted;

  // We keep track of deployed locks to ensure that callers are all deployed locks.
  mapping(address => LockBalances) public locks;

  // global base token URI
  // Used by locks where the owner has not set a custom base URI.
  string private globalBaseTokenURI;

  // global base token symbol
  // Used by locks where the owner has not set a custom symbol
  string private globalTokenSymbol;

  // Events
  event NewLock(address indexed lockOwner, address indexed newLockAddress);

  event NewTokenURI(string tokenURI);

  event NewGlobalTokenSymbol(string tokenSymbol);

  // Use initialize instead of a constructor to support proxies (for upgradeability via zos).
  function initialize(address _owner) public initializer {
    // We must manually initialize Ownable.sol
    Ownable.initialize(_owner);
  }

  /**
   * @dev Create lock
   * This deploys a lock for a creator. It also keeps track of the deployed lock.
   * @param _tokenAddress set to the ERC20 token address, or 0 for ETH.
   */
  function createLock(
    uint _expirationDuration,
    address _tokenAddress,
    uint _keyPrice,
    uint _maxNumberOfKeys,
    string memory _lockName
  ) public {
    // create lock
    address newLock = address(
      new PublicLock(
        msg.sender,
        _expirationDuration,
        _tokenAddress,
        _keyPrice,
        _maxNumberOfKeys,
        _lockName
      )
    );

    // Assign the new Lock
    locks[newLock] = LockBalances({
      deployed: true,
      totalSales: 0,
      yieldedDiscountTokens: 0
    });

    // trigger event
    emit NewLock(msg.sender, newLock);
  }

  /**
   * This function returns the discount available for a user, when purchasing a
   * a key from a lock.
   * This does not modify the state. It returns both the discount and the number of tokens
   * consumed to grant that discount.
   * TODO: actually implement this.
   */
  function computeAvailableDiscountFor(
    address _purchaser, // solhint-disable-line no-unused-vars
    uint _keyPrice // solhint-disable-line no-unused-vars
  ) public view returns (uint discount, uint tokens) {
    // TODO: implement me
    return (0, 0);
  }

  /**
   * This function keeps track of the added GDP, as well as grants of discount tokens
   * to the referrer, if applicable.
   * The number of discount tokens granted is based on the value of the referal,
   * the current growth rate and the lock's discount token distribution rate
   * This function is invoked by a previously deployed lock only.
   * TODO: actually implement
   */
  function recordKeyPurchase(
    uint _value,
    address _referrer // solhint-disable-line no-unused-vars
  ) public onlyFromDeployedLock {
    // TODO: implement me (discount tokens)
    grossNetworkProduct += _value;
    locks[msg.sender].totalSales += _value;
  }

  /**
   * This function will keep track of consumed discounts by a given user.
   * It will also grant discount tokens to the creator who is granting the discount based on the
   * amount of discount and compensation rate.
   * This function is invoked by a previously deployed lock only.
   */
  function recordConsumedDiscount(
    uint _discount,
    uint _tokens // solhint-disable-line no-unused-vars
  ) public onlyFromDeployedLock {
    // TODO: implement me
    totalDiscountGranted += _discount;
    return;
  }

  // The version number of the current Unlock implementation on this network
  function unlockVersion() external pure returns (uint16) {
    return 3;
  }

  // function to read the globalTokenURI field.
  function getGlobalBaseTokenURI() external view returns (string memory) {
    return globalBaseTokenURI;
  }

  // function to set the globalTokenURI field.
  function setGlobalBaseTokenURI(string calldata _URI) external onlyOwner {
    globalBaseTokenURI = _URI;
    emit NewTokenURI(_URI);
  }

  // function to read the globalTokenSymbol field.
  function getGlobalTokenSymbol() external view returns (string memory) {
    return globalTokenSymbol;
  }

  // function to set the globalTokenSymbol field.
  function setGlobalTokenSymbol(string calldata _symbol) external onlyOwner {
    globalTokenSymbol = _symbol;
    emit NewGlobalTokenSymbol(_symbol);
  }
}
