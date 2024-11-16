
// File: @flarenetwork/flare-periphery-contracts/coston2/IFlareContractRegistry.sol


pragma solidity >=0.7.6 <0.9;
pragma abicoder v2;

interface IFlareContractRegistry {
    /**
     * @notice Returns contract address for the given name - might be address(0)
     * @param _name             name of the contract
     */
    function getContractAddressByName(string calldata _name) external view returns(address);

    /**
     * @notice Returns contract address for the given name hash - might be address(0)
     * @param _nameHash         hash of the contract name (keccak256(abi.encode(name))
     */
    function getContractAddressByHash(bytes32 _nameHash) external view returns(address);

    /**
     * @notice Returns contract addresses for the given names - might be address(0)
     * @param _names            names of the contracts
     */
    function getContractAddressesByName(string[] calldata _names) external view returns(address[] memory);

    /**
     * @notice Returns contract addresses for the given name hashes - might be address(0)
     * @param _nameHashes       hashes of the contract names (keccak256(abi.encode(name))
     */
    function getContractAddressesByHash(bytes32[] calldata _nameHashes) external view returns(address[] memory);

    /**
     * @notice Returns all contract names and corresponding addresses
     */
    function getAllContracts() external view returns(string[] memory _names, address[] memory _addresses);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/genesis/interface/IFtsoGenesis.sol


pragma solidity >=0.7.6 <0.9;


interface IFtsoGenesis {

    /**
     * @notice Reveals submitted price during epoch reveal period - only price submitter
     * @param _voter                Voter address
     * @param _epochId              Id of the epoch in which the price hash was submitted
     * @param _price                Submitted price in USD
     * @notice The hash of _price and _random must be equal to the submitted hash
     * @notice Emits PriceRevealed event
     */
    function revealPriceSubmitter(
        address _voter,
        uint256 _epochId,
        uint256 _price,
        uint256 _wNatVP
    ) external;

    /**
     * @notice Get (and cache) wNat vote power for specified voter and given epoch id
     * @param _voter                Voter address
     * @param _epochId              Id of the epoch in which the price hash was submitted
     * @return wNat vote power
     */
    function wNatVotePowerCached(address _voter, uint256 _epochId) external returns (uint256);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/genesis/interface/IFtsoRegistryGenesis.sol


pragma solidity >=0.7.6 <0.9;



interface IFtsoRegistryGenesis {

    function getFtsos(uint256[] memory _indices) external view returns(IFtsoGenesis[] memory _ftsos);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/genesis/interface/IFtsoManagerGenesis.sol


pragma solidity >=0.7.6 <0.9;


interface IFtsoManagerGenesis {

    function getCurrentPriceEpochId() external view returns (uint256 _priceEpochId);

}

// File: @flarenetwork/flare-periphery-contracts/coston2/IPriceSubmitter.sol


pragma solidity >=0.7.6 <0.9;




interface IPriceSubmitter {
    /**
     * Event emitted when hash was submitted through PriceSubmitter.
     * @param submitter the address of the sender
     * @param epochId current price epoch id
     * @param hash the submitted hash
     * @param timestamp current block timestamp
     */
    event HashSubmitted(
        address indexed submitter,
        uint256 indexed epochId,
        bytes32 hash,
        uint256 timestamp
    );

    /**
     * Event emitted when prices were revealed through PriceSubmitter.
     * @param voter the address of the sender
     * @param epochId id of the epoch in which the price hash was submitted
     * @param ftsos array of ftsos that correspond to the indexes in the call
     * @param prices the submitted prices
     * @param timestamp current block timestamp
     */
    event PricesRevealed(
        address indexed voter,
        uint256 indexed epochId,
        IFtsoGenesis[] ftsos,
        uint256[] prices,
        uint256 random,
        uint256 timestamp
    );
    
    /**
     * @notice Submits hash for current epoch
     * @param _epochId              Target epoch id to which hash is submitted
     * @param _hash                 Hash of ftso indices, prices, random number and voter address
     * @notice Emits HashSubmitted event
     */
    function submitHash(
        uint256 _epochId,
        bytes32 _hash
    ) external;

    /**
     * @notice Reveals submitted prices during epoch reveal period
     * @param _epochId              Id of the epoch in which the price hashes was submitted
     * @param _ftsoIndices          List of increasing ftso indices
     * @param _prices               List of submitted prices in USD
     * @param _random               Submitted random number
     * @notice The hash of ftso indices, prices, random number and voter address must be equal to the submitted hash
     * @notice Emits PricesRevealed event
     */
    function revealPrices(
        uint256 _epochId,
        uint256[] memory _ftsoIndices,
        uint256[] memory _prices,
        uint256 _random
    ) external;

    /**
     * Returns bitmap of all ftso's for which `_voter` is allowed to submit prices/hashes.
     * If voter is allowed to vote for ftso at index (see *_FTSO_INDEX), the corrsponding
     * bit in the result will be 1.
     */    
    function voterWhitelistBitmap(address _voter) external view returns (uint256);

    function getVoterWhitelister() external view returns (address);
    function getFtsoRegistry() external view returns (IFtsoRegistryGenesis);
    function getFtsoManager() external view returns (IFtsoManagerGenesis);

    /**
     * @notice Returns current random number
     */
    function getCurrentRandom() external view returns (uint256);
    
    /**
     * @notice Returns random number of the specified epoch
     * @param _epochId              Id of the epoch
     */
    function getRandom(uint256 _epochId) external view returns (uint256);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IGovernanceSettings.sol


pragma solidity >=0.7.6 <0.9;


/**
 * A special contract that holds Flare governance address.
 * This contract enables updating governance address and timelock only by hard forking the network,
 * meaning only by updating validator code.
 */
interface IGovernanceSettings {
    /**
     * Get the governance account address.
     * The governance address can only be changed by a hardfork.
     */
    function getGovernanceAddress() external view returns (address);
    
    /**
     * Get the time in seconds that must pass between a governance call and execution.
     * The timelock value can only be changed by a hardfork.
     */
    function getTimelock() external view returns (uint256);
    
    /**
     * Get the addresses of the accounts that are allowed to execute the timelocked governance calls
     * once the timelock period expires.
     * Executors can be changed without a hardfork, via a normal governance call.
     */
    function getExecutors() external view returns (address[] memory);
    
    /**
     * Check whether an address is one of the executors.
     */
    function isExecutor(address _address) external view returns (bool);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IFtsoRewardManager.sol


pragma solidity >=0.7.6 <0.9;

interface IFtsoRewardManager {

    event RewardClaimed(
        address indexed dataProvider,
        address indexed whoClaimed,
        address indexed sentTo,
        uint256 rewardEpoch, 
        uint256 amount
    );

    event UnearnedRewardsAccrued(
        uint256 epochId,
        uint256 reward
    );

    event RewardsDistributed(
        address indexed ftso,
        uint256 epochId,
        address[] addresses,
        uint256[] rewards
    );

    event RewardClaimsEnabled(
        uint256 rewardEpochId
    ); 

    event FeePercentageChanged(
        address indexed dataProvider,
        uint256 value,
        uint256 validFromEpoch
    );

    event RewardClaimsExpired(
        uint256 rewardEpochId
    );    

    event FtsoRewardManagerActivated(address ftsoRewardManager);
    event FtsoRewardManagerDeactivated(address ftsoRewardManager);

    /**
     * @notice Allows a percentage delegator to claim rewards.
     * @notice This function is intended to be used to claim rewards in case of delegation by percentage.
     * @param _recipient            address to transfer funds to
     * @param _rewardEpochs         array of reward epoch numbers to claim for
     * @return _rewardAmount        amount of total claimed rewards
     * @dev Reverts if `msg.sender` is delegating by amount
     * @dev Claims for all unclaimed reward epochs to the 'max(_rewardEpochs)'.
     * @dev Retained for backward compatibility.
     * @dev This function is deprecated - use `claim` instead.
     */
    function claimReward(
        address payable _recipient,
        uint256[] calldata _rewardEpochs
    )
        external returns (uint256 _rewardAmount);

    /**
     * @notice Allows the sender to claim or wrap rewards for reward owner.
     * @notice This function is intended to be used to claim rewards in case of delegation by percentage.
     * @notice The caller does not have to be the owner, but must be approved by the owner to claim on his behalf,
     *   this approval is done by calling `setClaimExecutors`.
     * @notice It is actually safe for this to be called by anybody (nothing can be stolen), but by limiting who can
     *   call, we allow the owner to control the timing of the calls.
     * @notice Reward owner can claim to any `_recipient`, while the executor can only claim to the reward owner,
     *   reward owners's personal delegation account or one of the addresses set by `setAllowedClaimRecipients`.
     * @param _rewardOwner          address of the reward owner
     * @param _recipient            address to transfer funds to
     * @param _rewardEpoch          last reward epoch to claim for
     * @param _wrap                 should reward be wrapped immediately
     * @return _rewardAmount        amount of total claimed rewards
     * @dev Reverts if `msg.sender` is delegating by amount
     */
    function claim(
        address _rewardOwner,
        address payable _recipient,
        uint256 _rewardEpoch,
        bool _wrap
    )
        external returns (uint256 _rewardAmount);
    
    /**
     * @notice Allows the sender to claim rewards from specified data providers.
     * @notice This function is intended to be used to claim rewards in case of delegation by amount.
     * @param _recipient            address to transfer funds to
     * @param _rewardEpochs         array of reward epoch numbers to claim for
     * @param _dataProviders        array of addresses representing data providers to claim the reward from
     * @return _rewardAmount        amount of total claimed rewards
     * @dev Function can only be used for explicit delegations.
     * @dev This function is deprecated - use `claimFromDataProviders` instead.
     */
    function claimRewardFromDataProviders(
        address payable _recipient,
        uint256[] calldata _rewardEpochs,
        address[] calldata _dataProviders
    )
        external returns (uint256 _rewardAmount);

    /**
     * @notice Allows the sender to claim or wrap rewards for reward owner from specified data providers.
     * @notice This function is intended to be used to claim rewards in case of delegation by amount.
     * @notice The caller does not have to be the owner, but must be approved by the owner to claim on his behalf,
     *   this approval is done by calling `setClaimExecutors`.
     * @notice It is actually safe for this to be called by anybody (nothing can be stolen), but by limiting who can
     *   call, we allow the owner to control the timing of the calls.
     * @notice Reward owner can claim to any `_recipient`, while the executor can only claim to the reward owner,
     *   reward owners's personal delegation account or one of the addresses set by `setAllowedClaimRecipients`.
     * @param _rewardOwner          address of the reward owner
     * @param _recipient            address to transfer funds to
     * @param _rewardEpochs         array of reward epoch numbers to claim for
     * @param _dataProviders        array of addresses representing data providers to claim the reward from
     * @param _wrap                 should reward be wrapped immediately
     * @return _rewardAmount        amount of total claimed rewards
     * @dev Function can only be used for explicit delegations.
     */
    function claimFromDataProviders(
        address _rewardOwner,
        address payable _recipient,
        uint256[] calldata _rewardEpochs,
        address[] calldata _dataProviders,
        bool _wrap
    )
        external returns (uint256 _rewardAmount);

    /**
     * @notice Allows batch claiming for the list of '_rewardOwners' and for all unclaimed epochs <= '_rewardEpoch'.
     * @notice If reward owner has enabled delegation account, rewards are also claimed for that delegation account and
     *   total claimed amount is sent to that delegation account, otherwise claimed amount is sent to owner's account.
     * @notice Claimed amount is automatically wrapped.
     * @notice Method can be used by reward owner or executor. If executor is registered with fee > 0,
     *   then fee is paid to executor for each claimed address from the list.
     * @param _rewardOwners         list of reward owners to claim for
     * @param _rewardEpoch          last reward epoch to claim for
     */
    function autoClaim(address[] calldata _rewardOwners, uint256 _rewardEpoch) external;
    
    /**
     * @notice Allows data provider to set (or update last) fee percentage.
     * @param _feePercentageBIPS    number representing fee percentage in BIPS
     * @return _validFromEpoch      reward epoch number when the setting becomes effective.
     */
    function setDataProviderFeePercentage(uint256 _feePercentageBIPS)
        external returns (uint256 _validFromEpoch);

    /**
     * @notice Allows reward claiming
     */
    function active() external view returns (bool);

    /**
     * @notice Returns the current fee percentage of `_dataProvider`
     * @param _dataProvider         address representing data provider
     */
    function getDataProviderCurrentFeePercentage(address _dataProvider)
        external view returns (uint256 _feePercentageBIPS);

    /**
     * @notice Returns the fee percentage of `_dataProvider` at `_rewardEpoch`
     * @param _dataProvider         address representing data provider
     * @param _rewardEpoch          reward epoch number
     */
    function getDataProviderFeePercentage(
        address _dataProvider,
        uint256 _rewardEpoch
    )
        external view
        returns (uint256 _feePercentageBIPS);

    /**
     * @notice Returns the scheduled fee percentage changes of `_dataProvider`
     * @param _dataProvider         address representing data provider
     * @return _feePercentageBIPS   positional array of fee percentages in BIPS
     * @return _validFromEpoch      positional array of block numbers the fee settings are effective from
     * @return _fixed               positional array of boolean values indicating if settings are subjected to change
     */
    function getDataProviderScheduledFeePercentageChanges(address _dataProvider) external view 
        returns (
            uint256[] memory _feePercentageBIPS,
            uint256[] memory _validFromEpoch,
            bool[] memory _fixed
        );

    /**
     * @notice Returns information on epoch reward
     * @param _rewardEpoch          reward epoch number
     * @return _totalReward         number representing the total epoch reward
     * @return _claimedReward       number representing the amount of total epoch reward that has been claimed
     */
    function getEpochReward(uint256 _rewardEpoch) external view
        returns (uint256 _totalReward, uint256 _claimedReward);

    /**
     * @notice Returns the state of rewards for `_beneficiary` at `_rewardEpoch`
     * @param _beneficiary          address of reward beneficiary
     * @param _rewardEpoch          reward epoch number
     * @return _dataProviders       positional array of addresses representing data providers
     * @return _rewardAmounts       positional array of reward amounts
     * @return _claimed             positional array of boolean values indicating if reward is claimed
     * @return _claimable           boolean value indicating if rewards are claimable
     * @dev Reverts when queried with `_beneficiary` delegating by amount
     */
    function getStateOfRewards(
        address _beneficiary,
        uint256 _rewardEpoch
    )
        external view 
        returns (
            address[] memory _dataProviders,
            uint256[] memory _rewardAmounts,
            bool[] memory _claimed,
            bool _claimable
        );

    /**
     * @notice Returns the state of rewards for `_beneficiary` at `_rewardEpoch` from `_dataProviders`
     * @param _beneficiary          address of reward beneficiary
     * @param _rewardEpoch          reward epoch number
     * @param _dataProviders        positional array of addresses representing data providers
     * @return _rewardAmounts       positional array of reward amounts
     * @return _claimed             positional array of boolean values indicating if reward is claimed
     * @return _claimable           boolean value indicating if rewards are claimable
     */
    function getStateOfRewardsFromDataProviders(
        address _beneficiary,
        uint256 _rewardEpoch,
        address[] calldata _dataProviders
    )
        external view
        returns (
            uint256[] memory _rewardAmounts,
            bool[] memory _claimed,
            bool _claimable
        );

    /**
     * @notice Returns the start and the end of the reward epoch range for which the reward is claimable
     * @param _startEpochId         the oldest epoch id that allows reward claiming
     * @param _endEpochId           the newest epoch id that allows reward claiming
     */
    function getEpochsWithClaimableRewards() external view 
        returns (
            uint256 _startEpochId,
            uint256 _endEpochId
        );

    /**
     * @notice Returns the next claimable reward epoch for '_rewardOwner'.
     * @param _rewardOwner          address of the reward owner
     */
    function nextClaimableRewardEpoch(address _rewardOwner) external view returns (uint256);

    /**
     * @notice Returns the array of claimable epoch ids for which the reward has not yet been claimed
     * @param _beneficiary          address of reward beneficiary
     * @return _epochIds            array of epoch ids
     * @dev Reverts when queried with `_beneficiary` delegating by amount
     */
    function getEpochsWithUnclaimedRewards(address _beneficiary) external view returns (
        uint256[] memory _epochIds
    );

    /**
     * @notice Returns the information on claimed reward of `_dataProvider` for `_rewardEpoch` by `_claimer`
     * @param _rewardEpoch          reward epoch number
     * @param _dataProvider         address representing the data provider
     * @param _claimer              address representing the claimer
     * @return _claimed             boolean indicating if reward has been claimed
     * @return _amount              number representing the claimed amount
     */
    function getClaimedReward(
        uint256 _rewardEpoch,
        address _dataProvider,
        address _claimer
    )
        external view
        returns (
            bool _claimed,
            uint256 _amount
        );

    /**
     * @notice Return reward epoch that will expire, when new reward epoch will start
     * @return Reward epoch id that will expire next
     */
    function getRewardEpochToExpireNext() external view returns (uint256);

    /**
     * @notice Return reward epoch vote power block
     * @param _rewardEpoch          reward epoch number
     */
    function getRewardEpochVotePowerBlock(uint256 _rewardEpoch) external view returns (uint256);

    /**
     * @notice Return current reward epoch number
     */
    function getCurrentRewardEpoch() external view returns (uint256);

    /**
     * @notice Return initial reward epoch number
     */
    function getInitialRewardEpoch() external view returns (uint256);

    /**
     * @notice Returns the information on rewards and initial vote power of `_dataProvider` for `_rewardEpoch`
     * @param _rewardEpoch                      reward epoch number
     * @param _dataProvider                     address representing the data provider
     * @return _rewardAmount                    number representing the amount of rewards
     * @return _votePowerIgnoringRevocation     number representing the vote power ignoring revocations
     */
    function getDataProviderPerformanceInfo(
        uint256 _rewardEpoch,
        address _dataProvider
    )
        external view 
        returns (
            uint256 _rewardAmount,
            uint256 _votePowerIgnoringRevocation
        );
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IFtso.sol


pragma solidity >=0.7.6 <0.9;

interface IFtso {
    enum PriceFinalizationType {
        // initial state
        NOT_FINALIZED,
        // median calculation used to find price
        WEIGHTED_MEDIAN,
        // low turnout - price calculated from median of trusted addresses
        TRUSTED_ADDRESSES,
        // low turnout + no votes from trusted addresses - price copied from previous epoch
        PREVIOUS_PRICE_COPIED,
        // price calculated from median of trusted addresses - triggered due to an exception
        TRUSTED_ADDRESSES_EXCEPTION,
        // previous price copied - triggered due to an exception
        PREVIOUS_PRICE_COPIED_EXCEPTION
    }

    event PriceRevealed(
        address indexed voter, uint256 indexed epochId, uint256 price, uint256 timestamp,
        uint256 votePowerNat, uint256 votePowerAsset
    );

    event PriceFinalized(
        uint256 indexed epochId, uint256 price, bool rewardedFtso,
        uint256 lowIQRRewardPrice, uint256 highIQRRewardPrice,
        uint256 lowElasticBandRewardPrice, uint256 highElasticBandRewardPrice, 
        PriceFinalizationType finalizationType, uint256 timestamp
    );

    event PriceEpochInitializedOnFtso(
        uint256 indexed epochId, uint256 endTime, uint256 timestamp
    );

    event LowTurnout(
        uint256 indexed epochId,
        uint256 natTurnout,
        uint256 lowNatTurnoutThresholdBIPS,
        uint256 timestamp
    );

    /**
     * @notice Returns if FTSO is active
     */
    function active() external view returns (bool);

    /**
     * @notice Returns the FTSO symbol
     */
    function symbol() external view returns (string memory);

    /**
     * @notice Returns current epoch id
     */
    function getCurrentEpochId() external view returns (uint256);

    /**
     * @notice Returns id of the epoch which was opened for price submission at the specified timestamp
     * @param _timestamp            Timestamp as seconds from unix epoch
     */
    function getEpochId(uint256 _timestamp) external view returns (uint256);
    
    /**
     * @notice Returns random number of the specified epoch
     * @param _epochId              Id of the epoch
     */
    function getRandom(uint256 _epochId) external view returns (uint256);

    /**
     * @notice Returns asset price consented in specific epoch
     * @param _epochId              Id of the epoch
     * @return Price in USD multiplied by ASSET_PRICE_USD_DECIMALS
     */
    function getEpochPrice(uint256 _epochId) external view returns (uint256);

    /**
     * @notice Returns current epoch data
     * @return _epochId                 Current epoch id
     * @return _epochSubmitEndTime      End time of the current epoch price submission as seconds from unix epoch
     * @return _epochRevealEndTime      End time of the current epoch price reveal as seconds from unix epoch
     * @return _votePowerBlock          Vote power block for the current epoch
     * @return _fallbackMode            Current epoch in fallback mode - only votes from trusted addresses will be used
     * @dev half-closed intervals - end time not included
     */
    function getPriceEpochData() external view returns (
        uint256 _epochId,
        uint256 _epochSubmitEndTime,
        uint256 _epochRevealEndTime,
        uint256 _votePowerBlock,
        bool _fallbackMode
    );

    /**
     * @notice Returns current epoch data
     * @return _firstEpochStartTs           First epoch start timestamp
     * @return _submitPeriodSeconds         Submit period in seconds
     * @return _revealPeriodSeconds         Reveal period in seconds
     */
    function getPriceEpochConfiguration() external view returns (
        uint256 _firstEpochStartTs,
        uint256 _submitPeriodSeconds,
        uint256 _revealPeriodSeconds
    );
    
    /**
     * @notice Returns asset price submitted by voter in specific epoch
     * @param _epochId              Id of the epoch
     * @param _voter                Address of the voter
     * @return Price in USD multiplied by ASSET_PRICE_USD_DECIMALS
     */
    function getEpochPriceForVoter(uint256 _epochId, address _voter) external view returns (uint256);

    /**
     * @notice Returns current asset price
     * @return _price               Price in USD multiplied by ASSET_PRICE_USD_DECIMALS
     * @return _timestamp           Time when price was updated for the last time
     */
    function getCurrentPrice() external view returns (uint256 _price, uint256 _timestamp);

    /**
     * @notice Returns current asset price and number of decimals
     * @return _price                   Price in USD multiplied by ASSET_PRICE_USD_DECIMALS
     * @return _timestamp               Time when price was updated for the last time
     * @return _assetPriceUsdDecimals   Number of decimals used for USD price
     */
    function getCurrentPriceWithDecimals() external view returns (
        uint256 _price,
        uint256 _timestamp,
        uint256 _assetPriceUsdDecimals
    );
    
    /**
     * @notice Returns current asset price calculated from trusted providers
     * @return _price               Price in USD multiplied by ASSET_PRICE_USD_DECIMALS
     * @return _timestamp           Time when price was updated for the last time
     */
    function getCurrentPriceFromTrustedProviders() external view returns (uint256 _price, uint256 _timestamp);

    /**
     * @notice Returns current asset price calculated from trusted providers and number of decimals
     * @return _price                   Price in USD multiplied by ASSET_PRICE_USD_DECIMALS
     * @return _timestamp               Time when price was updated for the last time
     * @return _assetPriceUsdDecimals   Number of decimals used for USD price
     */
    function getCurrentPriceWithDecimalsFromTrustedProviders() external view returns (
        uint256 _price,
        uint256 _timestamp,
        uint256 _assetPriceUsdDecimals
    );

    /**
     * @notice Returns current asset price details
     * @return _price                                   Price in USD multiplied by ASSET_PRICE_USD_DECIMALS
     * @return _priceTimestamp                          Time when price was updated for the last time
     * @return _priceFinalizationType                   Finalization type when price was updated for the last time
     * @return _lastPriceEpochFinalizationTimestamp     Time when last price epoch was finalized
     * @return _lastPriceEpochFinalizationType          Finalization type of last finalized price epoch
     */
    function getCurrentPriceDetails() external view returns (
        uint256 _price,
        uint256 _priceTimestamp,
        PriceFinalizationType _priceFinalizationType,
        uint256 _lastPriceEpochFinalizationTimestamp,
        PriceFinalizationType _lastPriceEpochFinalizationType
    );

    /**
     * @notice Returns current random number
     */
    function getCurrentRandom() external view returns (uint256);
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v5.1.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface of the ERC-20 standard as defined in the ERC.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IGovernanceVotePower.sol


pragma solidity >=0.7.6 <0.9;

/**
 * Interface for contracts delegating their governance vote power.
 */
interface IGovernanceVotePower {
    /**
     * Delegates all governance vote power of `msg.sender` to address `_to`.
     * @param _to The address of the recipient.
     */
    function delegate(address _to) external;

    /**
     * Undelegates all governance vote power of `msg.sender`.
     */
    function undelegate() external;

    /**
     * Gets the governance vote power of an address at a given block number, including
     * all delegations made to it.
     * @param _who The address being queried.
     * @param _blockNumber The block number at which to fetch the vote power.
     * @return Governance vote power of `_who` at `_blockNumber`.
     */
    function votePowerOfAt(address _who, uint256 _blockNumber) external view returns(uint256);

    /**
     * Gets the governance vote power of an address at the latest block, including
     * all delegations made to it.
     * @param _who The address being queried.
     * @return Governance vote power of `account` at the lastest block.
     */
    function getVotes(address _who) external view returns (uint256);

    /**
     * Gets the address an account is delegating its governance vote power to, at a given block number.
     * @param _who The address being queried.
     * @param _blockNumber The block number at which to fetch the address.
     * @return Address where `_who` was delegating its governance vote power at block `_blockNumber`.
     */
    function getDelegateOfAt(address _who, uint256 _blockNumber) external view returns (address);

    /**
     * Gets the address an account is delegating its governance vote power to, at the latest block number.
     * @param _who The address being queried.
     * @return Address where `_who` is currently delegating its governance vote power.
     */
    function getDelegateOfAtNow(address _who) external view returns (address);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IVPContractEvents.sol


pragma solidity >=0.7.6 <0.9;

interface IVPContractEvents {
    /**
     * Event triggered when an account delegates or undelegates another account. 
     * Definition: `votePowerFromTo(from, to)` is `changed` from `priorVotePower` to `newVotePower`.
     * For undelegation, `newVotePower` is 0.
     *
     * Note: the event is always emitted from VPToken's `writeVotePowerContract`.
     */
    event Delegate(address indexed from, address indexed to, uint256 priorVotePower, uint256 newVotePower);
    
    /**
     * Event triggered only when account `delegator` revokes delegation to `delegatee`
     * for a single block in the past (typically the current vote block).
     *
     * Note: the event is always emitted from VPToken's `writeVotePowerContract` and/or `readVotePowerContract`.
     */
    event Revoke(address indexed delegator, address indexed delegatee, uint256 votePower, uint256 blockNumber);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IVPToken.sol


pragma solidity >=0.7.6 <0.9;




interface IVPToken is IERC20 {
    /**
     * @notice Delegate by percentage `_bips` of voting power to `_to` from `msg.sender`.
     * @param _to The address of the recipient
     * @param _bips The percentage of voting power to be delegated expressed in basis points (1/100 of one percent).
     *   Not cumulative - every call resets the delegation value (and value of 0 undelegates `to`).
     **/
    function delegate(address _to, uint256 _bips) external;
    
    /**
     * @notice Undelegate all percentage delegations from the sender and then delegate corresponding 
     *   `_bips` percentage of voting power from the sender to each member of `_delegatees`.
     * @param _delegatees The addresses of the new recipients.
     * @param _bips The percentages of voting power to be delegated expressed in basis points (1/100 of one percent).
     *   Total of all `_bips` values must be at most 10000.
     **/
    function batchDelegate(address[] memory _delegatees, uint256[] memory _bips) external;
        
    /**
     * @notice Explicitly delegate `_amount` of voting power to `_to` from `msg.sender`.
     * @param _to The address of the recipient
     * @param _amount An explicit vote power amount to be delegated.
     *   Not cumulative - every call resets the delegation value (and value of 0 undelegates `to`).
     **/    
    function delegateExplicit(address _to, uint _amount) external;

    /**
    * @notice Revoke all delegation from sender to `_who` at given block. 
    *    Only affects the reads via `votePowerOfAtCached()` in the block `_blockNumber`.
    *    Block `_blockNumber` must be in the past. 
    *    This method should be used only to prevent rogue delegate voting in the current voting block.
    *    To stop delegating use delegate/delegateExplicit with value of 0 or undelegateAll/undelegateAllExplicit.
    * @param _who Address of the delegatee
    * @param _blockNumber The block number at which to revoke delegation.
    */
    function revokeDelegationAt(address _who, uint _blockNumber) external;
    
    /**
     * @notice Undelegate all voting power for delegates of `msg.sender`
     *    Can only be used with percentage delegation.
     *    Does not reset delegation mode back to NOTSET.
     **/
    function undelegateAll() external;
    
    /**
     * @notice Undelegate all explicit vote power by amount delegates for `msg.sender`.
     *    Can only be used with explicit delegation.
     *    Does not reset delegation mode back to NOTSET.
     * @param _delegateAddresses Explicit delegation does not store delegatees' addresses, 
     *   so the caller must supply them.
     * @return The amount still delegated (in case the list of delegates was incomplete).
     */
    function undelegateAllExplicit(address[] memory _delegateAddresses) external returns (uint256);


    /**
     * @dev Should be compatible with ERC20 method
     */
    function name() external view returns (string memory);

    /**
     * @dev Should be compatible with ERC20 method
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Should be compatible with ERC20 method
     */
    function decimals() external view returns (uint8);
    

    /**
     * @notice Total amount of tokens at a specific `_blockNumber`.
     * @param _blockNumber The block number when the totalSupply is queried
     * @return The total amount of tokens at `_blockNumber`
     **/
    function totalSupplyAt(uint _blockNumber) external view returns(uint256);

    /**
     * @dev Queries the token balance of `_owner` at a specific `_blockNumber`.
     * @param _owner The address from which the balance will be retrieved.
     * @param _blockNumber The block number when the balance is queried.
     * @return The balance at `_blockNumber`.
     **/
    function balanceOfAt(address _owner, uint _blockNumber) external view returns (uint256);

    
    /**
     * @notice Get the current total vote power.
     * @return The current total vote power (sum of all accounts' vote powers).
     */
    function totalVotePower() external view returns(uint256);
    
    /**
    * @notice Get the total vote power at block `_blockNumber`
    * @param _blockNumber The block number at which to fetch.
    * @return The total vote power at the block  (sum of all accounts' vote powers).
    */
    function totalVotePowerAt(uint _blockNumber) external view returns(uint256);

    /**
     * @notice Get the current vote power of `_owner`.
     * @param _owner The address to get voting power.
     * @return Current vote power of `_owner`.
     */
    function votePowerOf(address _owner) external view returns(uint256);
    
    /**
    * @notice Get the vote power of `_owner` at block `_blockNumber`
    * @param _owner The address to get voting power.
    * @param _blockNumber The block number at which to fetch.
    * @return Vote power of `_owner` at `_blockNumber`.
    */
    function votePowerOfAt(address _owner, uint256 _blockNumber) external view returns(uint256);

    /**
    * @notice Get the vote power of `_owner` at block `_blockNumber`, ignoring revocation information (and cache).
    * @param _owner The address to get voting power.
    * @param _blockNumber The block number at which to fetch.
    * @return Vote power of `_owner` at `_blockNumber`. Result doesn't change if vote power is revoked.
    */
    function votePowerOfAtIgnoringRevocation(address _owner, uint256 _blockNumber) external view returns(uint256);

    /**
     * @notice Get the delegation mode for '_who'. This mode determines whether vote power is
     *  allocated by percentage or by explicit value. Once the delegation mode is set, 
     *  it never changes, even if all delegations are removed.
     * @param _who The address to get delegation mode.
     * @return delegation mode: 0 = NOTSET, 1 = PERCENTAGE, 2 = AMOUNT (i.e. explicit)
     */
    function delegationModeOf(address _who) external view returns(uint256);
        
    /**
    * @notice Get current delegated vote power `_from` delegator delegated `_to` delegatee.
    * @param _from Address of delegator
    * @param _to Address of delegatee
    * @return The delegated vote power.
    */
    function votePowerFromTo(address _from, address _to) external view returns(uint256);
    
    /**
    * @notice Get delegated the vote power `_from` delegator delegated `_to` delegatee at `_blockNumber`.
    * @param _from Address of delegator
    * @param _to Address of delegatee
    * @param _blockNumber The block number at which to fetch.
    * @return The delegated vote power.
    */
    function votePowerFromToAt(address _from, address _to, uint _blockNumber) external view returns(uint256);
    
    /**
     * @notice Compute the current undelegated vote power of `_owner`
     * @param _owner The address to get undelegated voting power.
     * @return The unallocated vote power of `_owner`
     */
    function undelegatedVotePowerOf(address _owner) external view returns(uint256);
    
    /**
     * @notice Get the undelegated vote power of `_owner` at given block.
     * @param _owner The address to get undelegated voting power.
     * @param _blockNumber The block number at which to fetch.
     * @return The undelegated vote power of `_owner` (= owner's own balance minus all delegations from owner)
     */
    function undelegatedVotePowerOfAt(address _owner, uint256 _blockNumber) external view returns(uint256);
    
    /**
    * @notice Get the vote power delegation `delegationAddresses` 
    *  and `_bips` of `_who`. Returned in two separate positional arrays.
    * @param _who The address to get delegations.
    * @return _delegateAddresses Positional array of delegation addresses.
    * @return _bips Positional array of delegation percents specified in basis points (1/100 or 1 percent)
    * @return _count The number of delegates.
    * @return _delegationMode The mode of the delegation (NOTSET=0, PERCENTAGE=1, AMOUNT=2).
    */
    function delegatesOf(address _who)
        external view 
        returns (
            address[] memory _delegateAddresses,
            uint256[] memory _bips,
            uint256 _count, 
            uint256 _delegationMode
        );
        
    /**
    * @notice Get the vote power delegation `delegationAddresses` 
    *  and `pcts` of `_who`. Returned in two separate positional arrays.
    * @param _who The address to get delegations.
    * @param _blockNumber The block for which we want to know the delegations.
    * @return _delegateAddresses Positional array of delegation addresses.
    * @return _bips Positional array of delegation percents specified in basis points (1/100 or 1 percent)
    * @return _count The number of delegates.
    * @return _delegationMode The mode of the delegation (NOTSET=0, PERCENTAGE=1, AMOUNT=2).
    */
    function delegatesOfAt(address _who, uint256 _blockNumber)
        external view 
        returns (
            address[] memory _delegateAddresses, 
            uint256[] memory _bips, 
            uint256 _count, 
            uint256 _delegationMode
        );

    /**
     * Returns VPContract used for readonly operations (view methods).
     * The only non-view method that might be called on it is `revokeDelegationAt`.
     *
     * @notice `readVotePowerContract` is almost always equal to `writeVotePowerContract`
     * except during upgrade from one VPContract to a new version (which should happen
     * rarely or never and will be anounced before).
     *
     * @notice You shouldn't call any methods on VPContract directly, all are exposed
     * via VPToken (and state changing methods are forbidden from direct calls). 
     * This is the reason why this method returns `IVPContractEvents` - it should only be used
     * for listening to events (`Revoke` only).
     */
    function readVotePowerContract() external view returns (IVPContractEvents);

    /**
     * Returns VPContract used for state changing operations (non-view methods).
     * The only non-view method that might be called on it is `revokeDelegationAt`.
     *
     * @notice `writeVotePowerContract` is almost always equal to `readVotePowerContract`
     * except during upgrade from one VPContract to a new version (which should happen
     * rarely or never and will be anounced before). In the case of upgrade,
     * `writeVotePowerContract` will be replaced first to establish delegations, and
     * after some perio (e.g. after a reward epoch ends) `readVotePowerContract` will be set equal to it.
     *
     * @notice You shouldn't call any methods on VPContract directly, all are exposed
     * via VPToken (and state changing methods are forbidden from direct calls). 
     * This is the reason why this method returns `IVPContractEvents` - it should only be used
     * for listening to events (`Delegate` and `Revoke` only).
     */
    function writeVotePowerContract() external view returns (IVPContractEvents);
    
    /**
     * When set, allows token owners to participate in governance voting
     * and delegate governance vote power.
     */
    function governanceVotePower() external view returns (IGovernanceVotePower);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/token/interface/IICleanable.sol


pragma solidity >=0.7.6 <0.9;

interface IICleanable {
    /**
     * Set the contract that is allowed to call history cleaning methods.
     */
    function setCleanerContract(address _cleanerContract) external;
    
    /**
     * Set the cleanup block number.
     * Historic data for the blocks before `cleanupBlockNumber` can be erased,
     * history before that block should never be used since it can be inconsistent.
     * In particular, cleanup block number must be before current vote power block.
     * @param _blockNumber The new cleanup block number.
     */
    function setCleanupBlockNumber(uint256 _blockNumber) external;
    
    /**
     * Get the current cleanup block number.
     */
    function cleanupBlockNumber() external view returns (uint256);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/token/interface/IIVPContract.sol


pragma solidity >=0.7.6 <0.9;




interface IIVPContract is IICleanable, IVPContractEvents {
    /**
     * Update vote powers when tokens are transfered.
     * Also update delegated vote powers for percentage delegation
     * and check for enough funds for explicit delegations.
     **/
    function updateAtTokenTransfer(
        address _from, 
        address _to, 
        uint256 _fromBalance,
        uint256 _toBalance,
        uint256 _amount
    ) external;

    /**
     * @notice Delegate `_bips` percentage of voting power to `_to` from `_from`
     * @param _from The address of the delegator
     * @param _to The address of the recipient
     * @param _balance The delegator's current balance
     * @param _bips The percentage of voting power to be delegated expressed in basis points (1/100 of one percent).
     *   Not cumulative - every call resets the delegation value (and value of 0 revokes delegation).
     **/
    function delegate(
        address _from, 
        address _to, 
        uint256 _balance, 
        uint256 _bips
    ) external;
    
    /**
     * @notice Explicitly delegate `_amount` of voting power to `_to` from `msg.sender`.
     * @param _from The address of the delegator
     * @param _to The address of the recipient
     * @param _balance The delegator's current balance
     * @param _amount An explicit vote power amount to be delegated.
     *   Not cumulative - every call resets the delegation value (and value of 0 undelegates `to`).
     **/    
    function delegateExplicit(
        address _from, 
        address _to, 
        uint256 _balance, 
        uint _amount
    ) external;    

    /**
     * @notice Revoke all delegation from sender to `_who` at given block. 
     *    Only affects the reads via `votePowerOfAtCached()` in the block `_blockNumber`.
     *    Block `_blockNumber` must be in the past. 
     *    This method should be used only to prevent rogue delegate voting in the current voting block.
     *    To stop delegating use delegate/delegateExplicit with value of 0 or undelegateAll/undelegateAllExplicit.
     * @param _from The address of the delegator
     * @param _who Address of the delegatee
     * @param _balance The delegator's current balance
     * @param _blockNumber The block number at which to revoke delegation.
     **/
    function revokeDelegationAt(
        address _from, 
        address _who, 
        uint256 _balance,
        uint _blockNumber
    ) external;
    
        /**
     * @notice Undelegate all voting power for delegates of `msg.sender`
     *    Can only be used with percentage delegation.
     *    Does not reset delegation mode back to NOTSET.
     * @param _from The address of the delegator
     **/
    function undelegateAll(
        address _from,
        uint256 _balance
    ) external;
    
    /**
     * @notice Undelegate all explicit vote power by amount delegates for `msg.sender`.
     *    Can only be used with explicit delegation.
     *    Does not reset delegation mode back to NOTSET.
     * @param _from The address of the delegator
     * @param _delegateAddresses Explicit delegation does not store delegatees' addresses, 
     *   so the caller must supply them.
     * @return The amount still delegated (in case the list of delegates was incomplete).
     */
    function undelegateAllExplicit(
        address _from, 
        address[] memory _delegateAddresses
    ) external returns (uint256);
    
    /**
    * @notice Get the vote power of `_who` at block `_blockNumber`
    *   Reads/updates cache and upholds revocations.
    * @param _who The address to get voting power.
    * @param _blockNumber The block number at which to fetch.
    * @return Vote power of `_who` at `_blockNumber`.
    */
    function votePowerOfAtCached(address _who, uint256 _blockNumber) external returns(uint256);
    
    /**
     * @notice Get the current vote power of `_who`.
     * @param _who The address to get voting power.
     * @return Current vote power of `_who`.
     */
    function votePowerOf(address _who) external view returns(uint256);
    
    /**
    * @notice Get the vote power of `_who` at block `_blockNumber`
    * @param _who The address to get voting power.
    * @param _blockNumber The block number at which to fetch.
    * @return Vote power of `_who` at `_blockNumber`.
    */
    function votePowerOfAt(address _who, uint256 _blockNumber) external view returns(uint256);

    /**
    * @notice Get the vote power of `_who` at block `_blockNumber`, ignoring revocation information (and cache).
    * @param _who The address to get voting power.
    * @param _blockNumber The block number at which to fetch.
    * @return Vote power of `_who` at `_blockNumber`. Result doesn't change if vote power is revoked.
    */
    function votePowerOfAtIgnoringRevocation(address _who, uint256 _blockNumber) external view returns(uint256);

    /**
     * Return vote powers for several addresses in a batch.
     * @param _owners The list of addresses to fetch vote power of.
     * @param _blockNumber The block number at which to fetch.
     * @return A list of vote powers.
     */    
    function batchVotePowerOfAt(
        address[] memory _owners, 
        uint256 _blockNumber
    )
        external view returns(uint256[] memory);

    /**
    * @notice Get current delegated vote power `_from` delegator delegated `_to` delegatee.
    * @param _from Address of delegator
    * @param _to Address of delegatee
    * @param _balance The delegator's current balance
    * @return The delegated vote power.
    */
    function votePowerFromTo(
        address _from, 
        address _to, 
        uint256 _balance
    ) external view returns(uint256);
    
    /**
    * @notice Get delegated the vote power `_from` delegator delegated `_to` delegatee at `_blockNumber`.
    * @param _from Address of delegator
    * @param _to Address of delegatee
    * @param _balance The delegator's current balance
    * @param _blockNumber The block number at which to fetch.
    * @return The delegated vote power.
    */
    function votePowerFromToAt(
        address _from, 
        address _to, 
        uint256 _balance,
        uint _blockNumber
    ) external view returns(uint256);

    /**
     * @notice Compute the current undelegated vote power of `_owner`
     * @param _owner The address to get undelegated voting power.
     * @param _balance Owner's current balance
     * @return The unallocated vote power of `_owner`
     */
    function undelegatedVotePowerOf(
        address _owner,
        uint256 _balance
    ) external view returns(uint256);

    /**
     * @notice Get the undelegated vote power of `_owner` at given block.
     * @param _owner The address to get undelegated voting power.
     * @param _blockNumber The block number at which to fetch.
     * @return The undelegated vote power of `_owner` (= owner's own balance minus all delegations from owner)
     */
    function undelegatedVotePowerOfAt(
        address _owner, 
        uint256 _balance,
        uint256 _blockNumber
    ) external view returns(uint256);

    /**
     * @notice Get the delegation mode for '_who'. This mode determines whether vote power is
     *  allocated by percentage or by explicit value.
     * @param _who The address to get delegation mode.
     * @return Delegation mode (NOTSET=0, PERCENTAGE=1, AMOUNT=2))
     */
    function delegationModeOf(address _who) external view returns (uint256);
    
    /**
    * @notice Get the vote power delegation `_delegateAddresses` 
    *  and `pcts` of an `_owner`. Returned in two separate positional arrays.
    * @param _owner The address to get delegations.
    * @return _delegateAddresses Positional array of delegation addresses.
    * @return _bips Positional array of delegation percents specified in basis points (1/100 or 1 percent)
    * @return _count The number of delegates.
    * @return _delegationMode The mode of the delegation (NOTSET=0, PERCENTAGE=1, AMOUNT=2).
    */
    function delegatesOf(
        address _owner
    )
        external view 
        returns (
            address[] memory _delegateAddresses, 
            uint256[] memory _bips,
            uint256 _count,
            uint256 _delegationMode
        );

    /**
    * @notice Get the vote power delegation `delegationAddresses` 
    *  and `pcts` of an `_owner`. Returned in two separate positional arrays.
    * @param _owner The address to get delegations.
    * @param _blockNumber The block for which we want to know the delegations.
    * @return _delegateAddresses Positional array of delegation addresses.
    * @return _bips Positional array of delegation percents specified in basis points (1/100 or 1 percent)
    * @return _count The number of delegates.
    * @return _delegationMode The mode of the delegation (NOTSET=0, PERCENTAGE=1, AMOUNT=2).
    */
    function delegatesOfAt(
        address _owner,
        uint256 _blockNumber
    )
        external view 
        returns (
            address[] memory _delegateAddresses, 
            uint256[] memory _bips,
            uint256 _count,
            uint256 _delegationMode
        );

    /**
     * The VPToken (or some other contract) that owns this VPContract.
     * All state changing methods may be called only from this address.
     * This is because original msg.sender is sent in `_from` parameter
     * and we must be sure that it cannot be faked by directly calling VPContract.
     * Owner token is also used in case of replacement to recover vote powers from balances.
     */
    function ownerToken() external view returns (IVPToken);
    
    /**
     * Return true if this IIVPContract is configured to be used as a replacement for other contract.
     * It means that vote powers are not necessarily correct at the initialization, therefore
     * every method that reads vote power must check whether it is initialized for that address and block.
     */
    function isReplacement() external view returns (bool);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IPChainVotePower.sol


pragma solidity >=0.7.6 <0.9;

/**
 * Interface for the vote power part of the `PChainStakeMirror` contract.
 */
interface IPChainVotePower {

    /**
     * Event triggered when a stake is confirmed or at the time it ends.
     * Definition: `votePowerFromTo(owner, nodeId)` is `changed` from `priorVotePower` to `newVotePower`.
     * @param owner The account that has changed the amount of vote power it is staking.
     * @param nodeId The node id whose received vote power has changed.
     * @param priorVotePower The vote power originally on that node id.
     * @param newVotePower The new vote power that triggered this event.
     */
    event VotePowerChanged(
        address indexed owner,
        bytes20 indexed nodeId,
        uint256 priorVotePower,
        uint256 newVotePower
    );

    /**
     * Emitted when a vote power cache entry is created.
     * Allows history cleaners to track vote power cache cleanup opportunities off-chain.
     * @param nodeId The node id whose vote power has just been cached.
     * @param blockNumber The block number at which the vote power has been cached.
     */
    event VotePowerCacheCreated(bytes20 nodeId, uint256 blockNumber);

    /**
    * Get the vote power of `_owner` at block `_blockNumber` using cache.
    *   It tries to read the cached value and if not found, reads the actual value and stores it in cache.
    *   Can only be used if _blockNumber is in the past, otherwise reverts.
    * @param _owner The node id to get voting power.
    * @param _blockNumber The block number at which to fetch.
    * @return Vote power of `_owner` at `_blockNumber`.
    */
    function votePowerOfAtCached(bytes20 _owner, uint256 _blockNumber) external returns(uint256);

    /**
    * Get the total vote power at block `_blockNumber` using cache.
    *   It tries to read the cached value and if not found, reads the actual value and stores it in cache.
    *   Can only be used if `_blockNumber` is in the past, otherwise reverts.
    * @param _blockNumber The block number at which to fetch.
    * @return The total vote power at the block (sum of all accounts' vote powers).
    */
    function totalVotePowerAtCached(uint256 _blockNumber) external returns(uint256);

    /**
     * Get the current total vote power.
     * @return The current total vote power (sum of all accounts' vote powers).
     */
    function totalVotePower() external view returns(uint256);

    /**
    * Get the total vote power at block `_blockNumber`
    * @param _blockNumber The block number at which to fetch.
    * @return The total vote power at the block  (sum of all accounts' vote powers).
    */
    function totalVotePowerAt(uint _blockNumber) external view returns(uint256);

    /**
     * Get the amounts and node ids being staked to by a vote power owner.
     * @param _owner The address being queried.
     * @return _nodeIds Array of node ids.
     * @return _amounts Array of staked amounts, for each node id.
     */
    function stakesOf(address _owner)
        external view
        returns (
            bytes20[] memory _nodeIds,
            uint256[] memory _amounts
        );

    /**
     * Get the amounts and node ids being staked to by a vote power owner,
     * at a given block.
     * @param _owner The address being queried.
     * @param _blockNumber The block number being queried.
     * @return _nodeIds Array of node ids.
     * @return _amounts Array of staked amounts, for each node id.
     */
    function stakesOfAt(
        address _owner,
        uint256 _blockNumber
    )
        external view
        returns (
            bytes20[] memory _nodeIds,
            uint256[] memory _amounts
        );

    /**
     * Get the current vote power of `_nodeId`.
     * @param _nodeId The node id to get voting power.
     * @return Current vote power of `_nodeId`.
     */
    function votePowerOf(bytes20 _nodeId) external view returns(uint256);

    /**
    * Get the vote power of `_nodeId` at block `_blockNumber`
    * @param _nodeId The node id to get voting power.
    * @param _blockNumber The block number at which to fetch.
    * @return Vote power of `_nodeId` at `_blockNumber`.
    */
    function votePowerOfAt(bytes20 _nodeId, uint256 _blockNumber) external view returns(uint256);

    /**
    * Get current staked vote power from `_owner` staked to `_nodeId`.
    * @param _owner Address of vote power owner.
    * @param _nodeId Node id.
    * @return The staked vote power.
    */
    function votePowerFromTo(address _owner, bytes20 _nodeId) external view returns(uint256);

    /**
    * Get current staked vote power from `_owner` staked to `_nodeId` at `_blockNumber`.
    * @param _owner Address of vote power owner.
    * @param _nodeId Node id.
    * @param _blockNumber The block number at which to fetch.
    * @return The staked vote power.
    */
    function votePowerFromToAt(address _owner, bytes20 _nodeId, uint _blockNumber) external view returns(uint256);

    /**
     * Return vote powers for several node ids in a batch.
     * @param _nodeIds The list of node ids to fetch vote power of.
     * @param _blockNumber The block number at which to fetch.
     * @return A list of vote powers.
     */
    function batchVotePowerOfAt(
        bytes20[] memory _nodeIds,
        uint256 _blockNumber
    ) external view returns(uint256[] memory);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IPChainStakeMirrorVerifier.sol


pragma solidity >=0.7.6 <0.9;
pragma abicoder v2;

/**
 * Interface with structure for P-chain stake mirror verifications.
 */
interface IPChainStakeMirrorVerifier {

    /**
     * Structure describing the P-chain stake.
     */
    struct PChainStake {
        // Hash of the transaction on the underlying chain.
        bytes32 txId;
        // Type of the staking/delegation transaction: '0' for 'ADD_VALIDATOR_TX' and '1' for 'ADD_DELEGATOR_TX'.
        uint8 stakingType;
        // Input address that triggered the staking or delegation transaction.
        // See https://support.avax.network/en/articles/4596397-what-is-an-address for address definition for P-chain.
        bytes20 inputAddress;
        // NodeID to which staking or delegation is done.
        // For definitions, see https://github.com/ava-labs/avalanchego/blob/master/ids/node_id.go.
        bytes20 nodeId;
        // Start time of the staking/delegation in seconds (Unix epoch).
        uint64 startTime;
        // End time of the staking/delegation in seconds (Unix epoch).
        uint64 endTime;
        // Staked or delegated amount in Gwei (nano FLR).
        uint64 weight;
    }
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IPChainStakeMirror.sol


pragma solidity >=0.7.6 <0.9;
pragma abicoder v2;




/**
 * Interface for the `PChainStakeMirror` contract.
 */
interface IPChainStakeMirror is IPChainVotePower {

    /**
     * Event emitted when max updates per block is set.
     * @param maxUpdatesPerBlock new number of max updated per block
     */
    event MaxUpdatesPerBlockSet(uint256 maxUpdatesPerBlock);

    /**
     * Event emitted when the stake is confirmed.
     * @param owner The address who opened the stake.
     * @param nodeId Node id to which the stake was added.
     * @param txHash Unique tx hash - keccak256(abi.encode(PChainStake.txId, PChainStake.inputAddress));
     * @param amountWei Stake amount (in wei).
     * @param pChainTxId P-chain transaction id.
     */
    event StakeConfirmed(
        address indexed owner,
        bytes20 indexed nodeId,
        bytes32 indexed txHash,
        uint256 amountWei,
        bytes32 pChainTxId
    );

    /**
     * Event emitted when the stake has ended.
     * @param owner The address whose stake has ended.
     * @param nodeId Node id from which the stake was removed.
     * @param txHash Unique tx hash - keccak256(abi.encode(PChainStake.txId, PChainStake.inputAddress));
     * @param amountWei Stake amount (in wei).
     */
    event StakeEnded(
        address indexed owner,
        bytes20 indexed nodeId,
        bytes32 indexed txHash,
        uint256 amountWei
    );

    /**
     * Event emitted when the stake was revoked.
     * @param owner The address whose stake has ended.
     * @param nodeId Node id from which the stake was removed.
     * @param txHash Unique tx hash - keccak256(abi.encode(PChainStake.txId, PChainStake.inputAddress));
     * @param amountWei Stake amount (in wei).
     */
    event StakeRevoked(
        address indexed owner,
        bytes20 indexed nodeId,
        bytes32 indexed txHash,
        uint256 amountWei
    );

    /**
     * Method for P-chain stake mirroring using `PChainStake` data and Merkle proof.
     * @param _stakeData Information about P-chain stake.
     * @param _merkleProof Merkle proof that should be used to prove the P-chain stake.
     */
    function mirrorStake(
        IPChainStakeMirrorVerifier.PChainStake calldata _stakeData,
        bytes32[] calldata _merkleProof
    )
        external;

    /**
     * Method for checking if active stake (stake start time <= block.timestamp < stake end time) was already mirrored.
     * @param _txId P-chain stake transaction id.
     * @param _inputAddress P-chain address that opened stake.
     * @return True if stake is active and mirrored.
     */
    function isActiveStakeMirrored(bytes32 _txId, bytes20 _inputAddress) external view returns(bool);

    /**
     * Total amount of tokens at current block.
     * @return The current total amount of tokens.
     **/
    function totalSupply() external view returns (uint256);

    /**
     * Total amount of tokens at a specific `_blockNumber`.
     * @param _blockNumber The block number when the totalSupply is queried.
     * @return The total amount of tokens at `_blockNumber`.
     **/
    function totalSupplyAt(uint _blockNumber) external view returns(uint256);

    /**
     * Queries the token balance of `_owner` at current block.
     * @param _owner The address from which the balance will be retrieved.
     * @return The current balance.
     **/
    function balanceOf(address _owner) external view returns (uint256);

    /**
     * Queries the token balance of `_owner` at a specific `_blockNumber`.
     * @param _owner The address from which the balance will be retrieved.
     * @param _blockNumber The block number when the balance is queried.
     * @return The balance at `_blockNumber`.
     **/
    function balanceOfAt(address _owner, uint _blockNumber) external view returns (uint256);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/token/interface/IIGovernanceVotePower.sol


pragma solidity >=0.7.6 <0.9;




/**
 * Internal interface for contracts delegating their governance vote power.
 */
interface IIGovernanceVotePower is IGovernanceVotePower {
    /**
     * Emitted when a delegate's vote power changes, as a result of a new delegation
     * or a token transfer, for example.
     *
     * The event is always emitted from a `GovernanceVotePower` contract.
     * @param delegate The account receiving the changing delegated vote power.
     * @param previousBalance Delegated vote power before the change.
     * @param newBalance Delegated vote power after the change.
     */
    event DelegateVotesChanged(
        address indexed delegate,
        uint256 previousBalance,
        uint256 newBalance
    );

    /**
     * Emitted when an account starts delegating vote power or switches its delegation
     * to another address.
     *
     * The event is always emitted from a `GovernanceVotePower` contract.
     * @param delegator Account delegating its vote power.
     * @param fromDelegate Account receiving the delegation before the change.
     * Can be address(0) if there was no previous delegation.
     * @param toDelegate Account receiving the delegation after the change.
     * Can be address(0) if `delegator` just undelegated all its vote power.
     */
    event DelegateChanged(
        address indexed delegator,
        address indexed fromDelegate,
        address indexed toDelegate
    );

    /**
     * Update governance vote power of all involved delegates after tokens are transferred.
     *
     * This function **MUST** be called after each governance token transfer for the
     * delegates to reflect the correct balance.
     * @param _from Source address of the transfer.
     * @param _to Destination address of the transfer.
     * @param _fromBalance _Ignored._
     * @param _toBalance _Ignored._
     * @param _amount Amount being transferred.
     */
    function updateAtTokenTransfer(
        address _from,
        address _to,
        uint256 _fromBalance,
        uint256 _toBalance,
        uint256 _amount
    ) external;

    /**
     * Set the cleanup block number.
     * Historic data for the blocks before `cleanupBlockNumber` can be erased.
     * History before that block should never be used since it can be inconsistent.
     * In particular, cleanup block number must be lower than the current vote power block.
     * @param _blockNumber The new cleanup block number.
     */
    function setCleanupBlockNumber(uint256 _blockNumber) external;

    /**
     * Set the contract that is allowed to call history cleaning methods.
     * @param _cleanerContract Address of the cleanup contract.
     * Usually this will be an instance of `CleanupBlockNumberManager`.
     */
    function setCleanerContract(address _cleanerContract) external;

    /**
     * Get the token that this governance vote power contract belongs to.
     * @return The IVPToken interface owning this contract.
     */
    function ownerToken() external view returns (IVPToken);

    /**
     * Get the stake mirror contract that this governance vote power contract belongs to.
     * @return The IPChainStakeMirror interface owning this contract.
     */
    function pChainStakeMirror() external view returns (IPChainStakeMirror);

    /**
     * Get the current cleanup block number set with `setCleanupBlockNumber()`.
     * @return The currently set cleanup block number.
     */
    function getCleanupBlockNumber() external view returns(uint256);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/token/interface/IIVPToken.sol


pragma solidity >=0.7.6 <0.9;






interface IIVPToken is IVPToken, IICleanable {
    /**
     * Set the contract that is allowed to set cleanupBlockNumber.
     * Usually this will be an instance of CleanupBlockNumberManager.
     */
    function setCleanupBlockNumberManager(address _cleanupBlockNumberManager) external;
    
    /**
     * Sets new governance vote power contract that allows token owners to participate in governance voting
     * and delegate governance vote power. 
     */
    function setGovernanceVotePower(IIGovernanceVotePower _governanceVotePower) external;
    
    /**
    * @notice Get the total vote power at block `_blockNumber` using cache.
    *   It tries to read the cached value and if not found, reads the actual value and stores it in cache.
    *   Can only be used if `_blockNumber` is in the past, otherwise reverts.    
    * @param _blockNumber The block number at which to fetch.
    * @return The total vote power at the block (sum of all accounts' vote powers).
    */
    function totalVotePowerAtCached(uint256 _blockNumber) external returns(uint256);
    
    /**
    * @notice Get the vote power of `_owner` at block `_blockNumber` using cache.
    *   It tries to read the cached value and if not found, reads the actual value and stores it in cache.
    *   Can only be used if _blockNumber is in the past, otherwise reverts.    
    * @param _owner The address to get voting power.
    * @param _blockNumber The block number at which to fetch.
    * @return Vote power of `_owner` at `_blockNumber`.
    */
    function votePowerOfAtCached(address _owner, uint256 _blockNumber) external returns(uint256);

    /**
     * Return vote powers for several addresses in a batch.
     * @param _owners The list of addresses to fetch vote power of.
     * @param _blockNumber The block number at which to fetch.
     * @return A list of vote powers.
     */    
    function batchVotePowerOfAt(
        address[] memory _owners, 
        uint256 _blockNumber
    ) external view returns(uint256[] memory);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/ftso/interface/IIFtso.sol


pragma solidity >=0.7.6 <0.9;





interface IIFtso is IFtso, IFtsoGenesis {

    /// function finalizePriceReveal
    /// called by reward manager only on correct timing.
    /// if price reveal period for epoch x ended. finalize.
    /// iterate list of price submissions
    /// find weighted median
    /// find adjucant 50% of price submissions.
    /// Allocate reward for any price submission which is same as a "winning" submission
    function finalizePriceEpoch(uint256 _epochId, bool _returnRewardData) external
        returns(
            address[] memory _eligibleAddresses,
            uint256[] memory _natWeights,
            uint256 _totalNatWeight
        );

    function fallbackFinalizePriceEpoch(uint256 _epochId) external;

    function forceFinalizePriceEpoch(uint256 _epochId) external;

    // activateFtso will be called by ftso manager once ftso is added 
    // before this is done, FTSO can't run
    function activateFtso(
        uint256 _firstEpochStartTs,
        uint256 _submitPeriodSeconds,
        uint256 _revealPeriodSeconds
    ) external;

    function deactivateFtso() external;

    // update initial price and timestamp - only if not active
    function updateInitialPrice(uint256 _initialPriceUSD, uint256 _initialPriceTimestamp) external;

    function configureEpochs(
        uint256 _maxVotePowerNatThresholdFraction,
        uint256 _maxVotePowerAssetThresholdFraction,
        uint256 _lowAssetUSDThreshold,
        uint256 _highAssetUSDThreshold,
        uint256 _highAssetTurnoutThresholdBIPS,
        uint256 _lowNatTurnoutThresholdBIPS,
        uint256 _elasticBandRewardBIPS,
        uint256 _elasticBandWidthPPM,
        address[] memory _trustedAddresses
    ) external;

    function setAsset(IIVPToken _asset) external;

    function setAssetFtsos(IIFtso[] memory _assetFtsos) external;

    // current vote power block will update per reward epoch. 
    // the FTSO doesn't have notion of reward epochs.
    // reward manager only can set this data. 
    function setVotePowerBlock(uint256 _blockNumber) external;

    function initializeCurrentEpochStateForReveal(uint256 _circulatingSupplyNat, bool _fallbackMode) external;
  
    /**
     * @notice Returns ftso manager address
     */
    function ftsoManager() external view returns (address);

    /**
     * @notice Returns the FTSO asset
     * @dev Asset is null in case of multi-asset FTSO
     */
    function getAsset() external view returns (IIVPToken);

    /**
     * @notice Returns the Asset FTSOs
     * @dev AssetFtsos is not null only in case of multi-asset FTSO
     */
    function getAssetFtsos() external view returns (IIFtso[] memory);

    /**
     * @notice Returns current configuration of epoch state
     * @return _maxVotePowerNatThresholdFraction        High threshold for native token vote power per voter
     * @return _maxVotePowerAssetThresholdFraction      High threshold for asset vote power per voter
     * @return _lowAssetUSDThreshold            Threshold for low asset vote power
     * @return _highAssetUSDThreshold           Threshold for high asset vote power
     * @return _highAssetTurnoutThresholdBIPS   Threshold for high asset turnout
     * @return _lowNatTurnoutThresholdBIPS      Threshold for low nat turnout
     * @return _elasticBandRewardBIPS           Hybrid reward band, where _elasticBandRewardBIPS goes to the 
        elastic band (prices within _elasticBandWidthPPM of the median) 
        and 10000 - elasticBandRewardBIPS to the IQR 
     * @return _elasticBandWidthPPM             Prices within _elasticBandWidthPPM of median are rewarded
     * @return _trustedAddresses                Trusted addresses - use their prices if low nat turnout is not achieved
     */
    function epochsConfiguration() external view 
        returns (
            uint256 _maxVotePowerNatThresholdFraction,
            uint256 _maxVotePowerAssetThresholdFraction,
            uint256 _lowAssetUSDThreshold,
            uint256 _highAssetUSDThreshold,
            uint256 _highAssetTurnoutThresholdBIPS,
            uint256 _lowNatTurnoutThresholdBIPS,
            uint256 _elasticBandRewardBIPS,
            uint256 _elasticBandWidthPPM,
            address[] memory _trustedAddresses
        );

    /**
     * @notice Returns parameters necessary for approximately replicating vote weighting.
     * @return _assets                  the list of Assets that are accounted in vote
     * @return _assetMultipliers        weight of each asset in (multiasset) ftso, mutiplied by TERA
     * @return _totalVotePowerNat       total native token vote power at block
     * @return _totalVotePowerAsset     total combined asset vote power at block
     * @return _assetWeightRatio        ratio of combined asset vp vs. native token vp (in BIPS)
     * @return _votePowerBlock          vote powewr block for given epoch
     */
    function getVoteWeightingParameters() external view 
        returns (
            IIVPToken[] memory _assets,
            uint256[] memory _assetMultipliers,
            uint256 _totalVotePowerNat,
            uint256 _totalVotePowerAsset,
            uint256 _assetWeightRatio,
            uint256 _votePowerBlock
        );

    function wNat() external view returns (IIVPToken);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IFtsoRegistry.sol


pragma solidity >=0.7.6 <0.9;
pragma abicoder v2;



interface IFtsoRegistry is IFtsoRegistryGenesis {

    struct PriceInfo {
        uint256 ftsoIndex;
        uint256 price;
        uint256 decimals;
        uint256 timestamp;
    }

    function getFtso(uint256 _ftsoIndex) external view returns(IIFtso _activeFtsoAddress);
    function getFtsoBySymbol(string memory _symbol) external view returns(IIFtso _activeFtsoAddress);
    function getSupportedIndices() external view returns(uint256[] memory _supportedIndices);
    function getSupportedSymbols() external view returns(string[] memory _supportedSymbols);
    function getSupportedFtsos() external view returns(IIFtso[] memory _ftsos);
    function getFtsoIndex(string memory _symbol) external view returns (uint256 _assetIndex);
    function getFtsoSymbol(uint256 _ftsoIndex) external view returns (string memory _symbol);
    function getCurrentPrice(uint256 _ftsoIndex) external view returns(uint256 _price, uint256 _timestamp);
    function getCurrentPrice(string memory _symbol) external view returns(uint256 _price, uint256 _timestamp);
    function getCurrentPriceWithDecimals(uint256 _assetIndex) external view
        returns(uint256 _price, uint256 _timestamp, uint256 _assetPriceUsdDecimals);
    function getCurrentPriceWithDecimals(string memory _symbol) external view
        returns(uint256 _price, uint256 _timestamp, uint256 _assetPriceUsdDecimals);

    function getAllCurrentPrices() external view returns (PriceInfo[] memory);
    function getCurrentPricesByIndices(uint256[] memory _indices) external view returns (PriceInfo[] memory);
    function getCurrentPricesBySymbols(string[] memory _symbols) external view returns (PriceInfo[] memory);

    function getSupportedIndicesAndFtsos() external view 
        returns(uint256[] memory _supportedIndices, IIFtso[] memory _ftsos);

    function getSupportedSymbolsAndFtsos() external view 
        returns(string[] memory _supportedSymbols, IIFtso[] memory _ftsos);

    function getSupportedIndicesAndSymbols() external view 
        returns(uint256[] memory _supportedIndices, string[] memory _supportedSymbols);

    function getSupportedIndicesSymbolsAndFtsos() external view 
        returns(uint256[] memory _supportedIndices, string[] memory _supportedSymbols, IIFtso[] memory _ftsos);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IVoterWhitelister.sol


pragma solidity >=0.7.6 <0.9;

interface IVoterWhitelister {
    /**
     * Raised when an account is removed from the voter whitelist.
     */
    event VoterWhitelisted(address voter, uint256 ftsoIndex);
    
    /**
     * Raised when an account is removed from the voter whitelist.
     */
    event VoterRemovedFromWhitelist(address voter, uint256 ftsoIndex);

    /**
     * Raised when an account is chilled from the voter whitelist.
     */
    event VoterChilled(address voter, uint256 untilRewardEpoch);

    /**
     * Request to whitelist `_voter` account to ftso at `_ftsoIndex`. Will revert if vote power too low.
     * May be called by any address.
     */
    function requestWhitelistingVoter(address _voter, uint256 _ftsoIndex) external;

    /**
     * Request to whitelist `_voter` account to all active ftsos.
     * May be called by any address.
     * It returns an array of supported ftso indices and success flag per index.
     */
    function requestFullVoterWhitelisting(
        address _voter
    ) 
        external 
        returns (
            uint256[] memory _supportedIndices,
            bool[] memory _success
        );

    /**
     * Maximum number of voters in the whitelist for a new FTSO.
     */
    function defaultMaxVotersForFtso() external view returns (uint256);
    
    /**
     * Maximum number of voters in the whitelist for FTSO at index `_ftsoIndex`.
     */
    function maxVotersForFtso(uint256 _ftsoIndex) external view returns (uint256);

    /**
     * Get whitelisted price providers for ftso with `_symbol`
     */
    function getFtsoWhitelistedPriceProvidersBySymbol(string memory _symbol) external view returns (address[] memory);

    /**
     * Get whitelisted price providers for ftso at `_ftsoIndex`
     */
    function getFtsoWhitelistedPriceProviders(uint256 _ftsoIndex) external view returns (address[] memory);

    /**
     * In case of providing bad prices (e.g. collusion), the voter can be chilled for a few reward epochs.
     * A voter can whitelist again from a returned reward epoch onwards.
     */
    function chilledUntilRewardEpoch(address _voter) external view returns (uint256);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IDistributionToDelegators.sol


pragma solidity >=0.7.6 <0.9;
pragma abicoder v2;

interface IDistributionToDelegators {
    // Events
    event UseGoodRandomSet(bool useGoodRandom, uint256 maxWaitForGoodRandomSeconds);
    event EntitlementStart(uint256 entitlementStartTs);
    event AccountClaimed(address indexed whoClaimed, address indexed sentTo, uint256 month, uint256 amountWei);
    event AccountOptOut(address indexed theAccount, bool confirmed);


    // Methods
    /**
     * @notice Allows the sender to claim or wrap rewards for reward owner.
     * @notice The caller does not have to be the owner, but must be approved by the owner to claim on his behalf,
     *   this approval is done by calling `setClaimExecutors`.
     * @notice It is actually safe for this to be called by anybody (nothing can be stolen), but by limiting who can
     *   call, we allow the owner to control the timing of the calls.
     * @notice Reward owner can claim to any `_recipient`, while the executor can only claim to the reward owner,
     *   reward owners's personal delegation account or one of the addresses set by `setAllowedClaimRecipients`.
     * @param _rewardOwner          address of the reward owner
     * @param _recipient            address to transfer funds to
     * @param _month                last month to claim for
     * @param _wrap                 should reward be wrapped immediately
     * @return _rewardAmount        amount of total claimed rewards
     */
    function claim(address _rewardOwner, address _recipient, uint256 _month, bool _wrap)
        external returns(uint256 _rewardAmount);

    /**
     * @notice Allows batch claiming for the list of '_rewardOwners' up to given '_month'.
     * @notice If reward owner has enabled delegation account, rewards are also claimed for that delegation account and
     *   total claimed amount is sent to that delegation account, otherwise claimed amount is sent to owner's account.
     * @notice Claimed amount is automatically wrapped.
     * @notice Method can be used by reward owner or executor. If executor is registered with fee > 0,
     *   then fee is paid to executor for each claimed address from the list.
     * @param _rewardOwners         list of reward owners to claim for
     * @param _month                last month to claim for
     */
    function autoClaim(address[] calldata _rewardOwners, uint256 _month) external;
    
    /**
     * @notice Method to opt-out of receiving airdrop rewards
     */
    function optOutOfAirdrop() external;
    
    /**
     * @notice Returns the next claimable month for '_rewardOwner'.
     * @param _rewardOwner          address of the reward owner
     */
    function nextClaimableMonth(address _rewardOwner) external view returns (uint256);

    /**
     * @notice get claimable amount of wei for requesting account for specified month
     * @param _month month of interest
     * @return _amountWei amount of wei available for this account and provided month
     */
    function getClaimableAmount(uint256 _month) external view returns(uint256 _amountWei);

    /**
     * @notice get claimable amount of wei for account for specified month
     * @param _account the address of an account we want to get the claimable amount of wei
     * @param _month month of interest
     * @return _amountWei amount of wei available for provided account and month
     */
    function getClaimableAmountOf(address _account, uint256 _month) external view returns(uint256 _amountWei);

    /**
     * @notice Returns the current month
     * @return _currentMonth Current month, 0 before entitlementStartTs
     */
    function getCurrentMonth() external view returns (uint256 _currentMonth);

    /**
     * @notice Returns the month that will expire next
     * @return _monthToExpireNext Month that will expire next, 1100 when last month expired
     */
    function getMonthToExpireNext() external view returns (uint256 _monthToExpireNext);

    /**
     * @notice Returns claimable months - reverts if none
     * @return _startMonth first claimable month
     * @return _endMonth last claimable month
     */
    function getClaimableMonths() external view returns(uint256 _startMonth, uint256 _endMonth);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IFtsoManager.sol


pragma solidity >=0.7.6 <0.9;



interface IFtsoManager is IFtsoManagerGenesis {

    event FtsoAdded(IIFtso ftso, bool add);
    event FallbackMode(bool fallbackMode);
    event FtsoFallbackMode(IIFtso ftso, bool fallbackMode);
    event RewardEpochFinalized(uint256 votepowerBlock, uint256 startBlock);
    event PriceEpochFinalized(address chosenFtso, uint256 rewardEpochId);
    event InitializingCurrentEpochStateForRevealFailed(IIFtso ftso, uint256 epochId);
    event FinalizingPriceEpochFailed(IIFtso ftso, uint256 epochId, IFtso.PriceFinalizationType failingType);
    event DistributingRewardsFailed(address ftso, uint256 epochId);
    event AccruingUnearnedRewardsFailed(uint256 epochId);
    event UseGoodRandomSet(bool useGoodRandom, uint256 maxWaitForGoodRandomSeconds);

    function active() external view returns (bool);

    function getCurrentRewardEpoch() external view returns (uint256);

    function getRewardEpochVotePowerBlock(uint256 _rewardEpoch) external view returns (uint256);

    function getRewardEpochToExpireNext() external view returns (uint256);
    
    function getCurrentPriceEpochData() external view 
        returns (
            uint256 _priceEpochId,
            uint256 _priceEpochStartTimestamp,
            uint256 _priceEpochEndTimestamp,
            uint256 _priceEpochRevealEndTimestamp,
            uint256 _currentTimestamp
        );

    function getFtsos() external view returns (IIFtso[] memory _ftsos);

    function getPriceEpochConfiguration() external view 
        returns (
            uint256 _firstPriceEpochStartTs,
            uint256 _priceEpochDurationSeconds,
            uint256 _revealEpochDurationSeconds
        );

    function getRewardEpochConfiguration() external view 
        returns (
            uint256 _firstRewardEpochStartTs,
            uint256 _rewardEpochDurationSeconds
        );

    function getFallbackMode() external view 
        returns (
            bool _fallbackMode,
            IIFtso[] memory _ftsos,
            bool[] memory _ftsoInFallbackMode
        );
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IWNat.sol


pragma solidity >=0.7.6 <0.9;




/**
 * @title Wrapped Native token
 * Accept native token deposits and mint ERC20 WNAT (wrapped native) tokens 1-1.
 */
interface IWNat is IVPToken, IICleanable {
    /**
     * Deposit Native and mint wNat ERC20.
     */
    function deposit() external payable;

    /**
     * Deposit Native from msg.sender and mints WNAT ERC20 to recipient address.
     * @param recipient An address to receive minted WNAT.
     */
    function depositTo(address recipient) external payable;

    /**
     * Withdraw Native and burn WNAT ERC20.
     * @param amount The amount to withdraw.
     */
    function withdraw(uint256 amount) external;

    /**
     * Withdraw WNAT from an owner and send native tokens to msg.sender given an allowance.
     * @param owner An address spending the Native tokens.
     * @param amount The amount to spend.
     *
     * Requirements:
     *
     * - `owner` must have a balance of at least `amount`.
     * - the caller must have allowance for `owners`'s tokens of at least
     * `amount`.
     */
    function withdrawFrom(address owner, uint256 amount) external;
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IDelegationAccount.sol


pragma solidity >=0.7.6 <0.9;



interface IDelegationAccount {

    event DelegateFtso(address to, uint256 bips);
    event RevokeFtso(address to, uint256 blockNumber);
    event UndelegateAllFtso();
    event DelegateGovernance(address to);
    event UndelegateGovernance();
    event WithdrawToOwner(uint256 amount);
    event ExternalTokenTransferred(IERC20 token, uint256 amount);
    event ExecutorFeePaid(address executor, uint256 amount);
    event Initialize(address owner, IClaimSetupManager manager);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IClaimSetupManager.sol


pragma solidity >=0.7.6 <0.9;



interface IClaimSetupManager {

    event DelegationAccountCreated(address owner, IDelegationAccount delegationAccount);
    event DelegationAccountUpdated(address owner, IDelegationAccount delegationAccount, bool enabled);
    event ClaimExecutorsChanged(address owner, address[] executors);
    event AllowedClaimRecipientsChanged(address owner, address[] recipients);
    event ClaimExecutorFeeValueChanged(address executor, uint256 validFromRewardEpoch, uint256 feeValueWei);
    event ExecutorRegistered(address executor);
    event ExecutorUnregistered(address executor, uint256 validFromRewardEpoch);
    event MinFeeSet(uint256 minFeeValueWei);
    event MaxFeeSet(uint256 maxFeeValueWei);
    event RegisterExecutorFeeSet(uint256 registerExecutorFeeValueWei);
    event SetExecutorsExcessAmountRefunded(address owner, uint256 excessAmount);

    /**
     * @notice Sets the addresses of executors and optionally enables (creates) delegation account.
     * @notice If setting registered executors some fee must be paid to them.
     * @param _executors        The new executors. All old executors will be deleted and replaced by these.
     */
    function setAutoClaiming(address[] memory _executors, bool _enableDelegationAccount) external payable;

    /**
     * @notice Sets the addresses of executors.
     * @notice If setting registered executors some fee must be paid to them.
     * @param _executors        The new executors. All old executors will be deleted and replaced by these.
     */ 
    function setClaimExecutors(address[] memory _executors) external payable;

    /**
     * Set the addresses of allowed recipients.
     * Apart from these, the owner is always an allowed recipient.
     * @param _recipients The new allowed recipients. All old recipients will be deleted and replaced by these.
     */    
    function setAllowedClaimRecipients(address[] memory _recipients) external;

    /**
     * @notice Enables (creates) delegation account contract,
     * i.e. all airdrop and ftso rewards will be send to delegation account when using automatic claiming.
     * @return Address of delegation account contract.
     */
    function enableDelegationAccount() external returns (IDelegationAccount);

    /**
     * @notice Disables delegation account contract,
     * i.e. all airdrop and ftso rewards will be send to owner's account when using automatic claiming.
     * @notice Automatic claiming will not claim airdrop and ftso rewards for delegation account anymore.
     * @dev Reverts if there is no delegation account
     */
    function disableDelegationAccount() external;

    /**
     * @notice Allows executor to register and set initial fee value.
     * If executor was already registered before (has fee set), only update fee after `feeValueUpdateOffset`.
     * @notice Executor must pay fee in order to register - `registerExecutorFeeValueWei`.
     * @param _feeValue    number representing fee value
     * @return Returns the reward epoch number when the setting becomes effective.
     */
    function registerExecutor(uint256 _feeValue) external payable returns (uint256);

    /**
     * @notice Allows executor to unregister.
     * @return Returns the reward epoch number when the setting becomes effective.
     */
    function unregisterExecutor() external returns (uint256);

    /**
     * @notice Allows registered executor to set (or update last scheduled) fee value.
     * @param _feeValue    number representing fee value
     * @return Returns the reward epoch number when the setting becomes effective.
     */
    function updateExecutorFeeValue(uint256 _feeValue) external returns(uint256);

    /**
     * @notice Delegate `_bips` of voting power to `_to` from msg.sender's delegation account
     * @param _to The address of the recipient
     * @param _bips The percentage of voting power to be delegated expressed in basis points (1/100 of one percent).
     *   Not cumulative - every call resets the delegation value (and value of 0 revokes delegation).
     */
    function delegate(address _to, uint256 _bips) external;

    /**
     * @notice Undelegate all percentage delegations from the msg.sender's delegation account and then delegate 
     *   corresponding `_bips` percentage of voting power to each member of `_delegatees`.
     * @param _delegatees The addresses of the new recipients.
     * @param _bips The percentages of voting power to be delegated expressed in basis points (1/100 of one percent).
     *   Total of all `_bips` values must be at most 10000.
     */
    function batchDelegate(address[] memory _delegatees, uint256[] memory _bips) external;

    /**
     * @notice Undelegate all voting power for delegates of msg.sender's delegation account
     */
    function undelegateAll() external;

    /**
     * @notice Revoke all delegation from msg.sender's delegation account to `_who` at given block. 
     *    Only affects the reads via `votePowerOfAtCached()` in the block `_blockNumber`.
     *    Block `_blockNumber` must be in the past. 
     *    This method should be used only to prevent rogue delegate voting in the current voting block.
     *    To stop delegating use delegate with value of 0 or undelegateAll.
     */
    function revokeDelegationAt(address _who, uint256 _blockNumber) external;

    /**
     * @notice Delegate all governance vote power of msg.sender's delegation account to `_to`.
     * @param _to The address of the recipient
     */
    function delegateGovernance(address _to) external;

    /**
     * @notice Undelegate governance vote power for delegate of msg.sender's delegation account
     */
    function undelegateGovernance() external;

    /**
     * @notice Allows user to transfer WNat to owner's account.
     * @param _amount           Amount of tokens to transfer
     */
    function withdraw(uint256 _amount) external;

    /**
     * @notice Allows user to transfer balance of ERC20 tokens owned by the personal delegation contract.
     The main use case is to transfer tokens/NFTs that were received as part of an airdrop or register 
     as participant in such airdrop.
     * @param _token            Target token contract address
     * @param _amount           Amount of tokens to transfer
     * @dev Reverts if target token is WNat contract - use method `withdraw` for that
     */
    function transferExternalToken(IERC20 _token, uint256 _amount) external;

    /**
     * @notice Gets the delegation account of the `_owner`. Returns address(0) if not created yet.
     */
    function accountToDelegationAccount(address _owner) external view returns (address);

    /**
     * @notice Gets the delegation account data for the `_owner`. Returns address(0) if not created yet.
     * @param _owner                        owner's address
     * @return _delegationAccount           owner's delegation account address - could be address(0)
     * @return _enabled                     indicates if delegation account is enabled
     */
    function getDelegationAccountData(
        address _owner
    )
        external view
        returns (IDelegationAccount _delegationAccount, bool _enabled);

    /**
     * @notice Get the addresses of executors.
     */    
    function claimExecutors(address _owner) external view returns (address[] memory);

    /**
     * Get the addresses of allowed recipients.
     * Apart from these, the owner is always an allowed recipient.
     */    
    function allowedClaimRecipients(address _rewardOwner) external view returns (address[] memory);

    /**
     * @notice Returns info if `_executor` is allowed to execute calls for `_owner`
     */
    function isClaimExecutor(address _owner, address _executor) external view returns(bool);

    /**
     * @notice Get registered executors
     */
    function getRegisteredExecutors(
        uint256 _start, 
        uint256 _end
    ) 
        external view
        returns (address[] memory _registeredExecutors, uint256 _totalLength);

    /**
     * @notice Returns some info about the `_executor`
     * @param _executor             address representing executor
     * @return _registered          information if executor is registered
     * @return _currentFeeValue     executor's current fee value
     */
    function getExecutorInfo(address _executor) external view returns (bool _registered, uint256 _currentFeeValue);

    /**
     * @notice Returns the current fee value of `_executor`
     * @param _executor             address representing executor
     */
    function getExecutorCurrentFeeValue(address _executor) external view  returns (uint256);

    /**
     * @notice Returns the fee value of `_executor` at `_rewardEpoch`
     * @param _executor             address representing executor
     * @param _rewardEpoch          reward epoch number
     */
    function getExecutorFeeValue(address _executor, uint256 _rewardEpoch) external view returns (uint256);

    /**
     * @notice Returns the scheduled fee value changes of `_executor`
     * @param _executor             address representing executor
     * @return _feeValue            positional array of fee values
     * @return _validFromEpoch      positional array of reward epochs the fee settings are effective from
     * @return _fixed               positional array of boolean values indicating if settings are subjected to change
     */
    function getExecutorScheduledFeeValueChanges(address _executor)
        external view
        returns (
            uint256[] memory _feeValue,
            uint256[] memory _validFromEpoch,
            bool[] memory _fixed
        );
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IGenericRewardManager.sol


pragma solidity >=0.7.6 <0.9;

interface IGenericRewardManager {

    event RewardClaimed(
        address indexed beneficiary,
        address indexed sentTo,
        uint256 amount
    );

    event RewardsDistributed(
        address[] addresses,
        uint256[] rewards
    );

    event ClaimExecutorsChanged(
        address rewardOwner,
        address[] executors
    );

    event AllowedClaimRecipientsChanged(
        address rewardOwner,
        address[] recipients
    );

    event RewardManagerActivated(address rewardManager);
    event RewardManagerDeactivated(address rewardManager);


    /**
     * @notice Allows the sender to claim or wrap rewards for reward owner.
     * @notice The caller does not have to be the owner, but must be approved by the owner to claim on his behalf.
     *   this approval is done by calling `setClaimExecutors`.
     * @notice It is actually safe for this to be called by anybody (nothing can be stolen), but by limiting who can
     *   call, we allow the owner to control the timing of the calls.
     * @notice Reward owner can claim to any `_recipient`, while the executor can only claim to the reward owner or
     *   one of the addresses set by `setAllowedClaimRecipients`.
     * @param _rewardOwner          address of the reward owner
     * @param _recipient            address to transfer funds to
     * @param _rewardAmount         amount of rewards to claim
     * @param _wrap                 should reward be wrapped immediately
     */
    function claim(address _rewardOwner, address payable _recipient, uint256 _rewardAmount, bool _wrap) external;

    /**
     * Set the addresses of executors, who are allowed to call `claim`.
     * @param _executors The new executors. All old executors will be deleted and replaced by these.
     */    
    function setClaimExecutors(address[] memory _executors) external;

    /**
     * Set the addresses of allowed recipients in the methods `claim`.
     * Apart from these, the reward owner is always an allowed recipient.
     * @param _recipients The new allowed recipients. All old recipients will be deleted and replaced by these.
     */    
    function setAllowedClaimRecipients(address[] memory _recipients) external;

    /**
     * @notice Allows reward claiming
     */
    function active() external view returns (bool);

    /**
     * @notice Returns information of beneficiary rewards
     * @param _beneficiary          beneficiary address
     * @return _totalReward         number representing the total reward
     * @return _claimedReward       number representing the amount of total reward that has been claimed
     */
    function getStateOfRewards(
        address _beneficiary
    )
        external view 
        returns (
            uint256 _totalReward,
            uint256 _claimedReward
        );

    /**
     * Get the addresses of executors, who are allowed to call `claim`.
     */    
    function claimExecutors(address _rewardOwner) external view returns (address[] memory);
    
    /**
     * Get the addresses of allowed recipients in the methods `claim`.
     * Apart from these, the reward owner is always an allowed recipient.
     */    
    function allowedClaimRecipients(address _rewardOwner) external view returns (address[] memory);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IFlareAssetRegistry.sol


pragma solidity >=0.7.6 <0.9;
pragma abicoder v2;


interface IFlareAssetRegistry {

    /**
     * @notice Returns if the token is a Flare Asset
     * @dev All other methods that accept token address will fail if this method returns false
     * @param token The token to be checked
     */
    function isFlareAsset(address token) external view returns (bool);

    /**
     * Return the asset type of the token. Asset type is a hash uniquely identifying the asset type.
     * For example, for wrapped native token, the type is `keccak256("wrapped native")`,
     * and for all f-assets the type will be `keccak256("f-asset")`.
     */
    function assetType(address _token) external view returns (bytes32);
    
     /**
     * @notice Returns the address of the Flare Asset with the selected symbol
     * @param symbol The token's symbol
     */
    function assetBySymbol(string calldata symbol) external view returns (address);

    /**
     * @notice Returns if the Flare Asset supports delegation via IVPToken interface
     * @param token The token to be checked
     */
    function supportsFtsoDelegation(address token) external view returns (bool);

    /**
     * @notice Returns the maximum allowed number of delegates by percent for the selected token
     * @param token The token to be checked
     */
    function maxDelegatesByPercent(address token) external view returns (uint256);

    /**
     * @notice Returns the incentive pool address for the selected token
     * @param token The token to be checked
     */
    function incentivePoolFor(address token) external view returns (address);

    /**
     * @notice Returns the addresses of all Flare Assets
     */
    function allAssets() external view returns (address[] memory);

    /**
     * @notice Returns the addresses and associated symbols of all Flare Assets
     */
    function allAssetsWithSymbols() external view returns (address[] memory, string[] memory);

    /**
     * @notice Returns all asset types.
     */
    function allAssetTypes() external view returns (bytes32[] memory);
        
    /**
     * @notice Returns the addresses of all Flare Assets of given type.
     * @param _assetType a type hash, all returned assets will have this assetType
     */
    function allAssetsOfType(bytes32 _assetType) external view returns (address[] memory);
    
    /**
     * @notice Returns the addresses and associated symbols of all Flare Assets of given type.
     * @param _assetType a type hash, all returned assets will have this assetType
     */
    function allAssetsOfTypeWithSymbols(bytes32 _assetType) external view returns (address[] memory, string[] memory);

     /**
     * @notice Returns a generic asset attribute value.
     * @param token The token's address
     * @param nameHash attributes name's hash
     * @return defined true if the attribute is defined for this token
     * @return value attribute value, may have to be cast into some other type
     */
    function getAttribute(address token, bytes32 nameHash) external view returns (bool defined, bytes32 value);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IValidatorRegistry.sol


pragma solidity >=0.7.6 <0.9;


/**
 * @title Validator registry contract
 * @notice This contract is used as a mapping from data provider's address to {node id, P-Chain public key}
 * @notice In order to get the ability to become a validator, data provider must register using this contract
 * @dev Only whitelisted data provider can register
 */
interface IValidatorRegistry {

    event DataProviderRegistered(address indexed dataProvider, string nodeId, string pChainPublicKey);
    event DataProviderUnregistered(address indexed dataProvider);

    /**
     * @notice Register data provider's address as a validator - emits DataProviderRegistered event
     * @param _nodeId Data provider's node id
     * @param _pChainPublicKey Data provider's P-Chain public key
     * @dev Data provider must be whitelisted
     * @dev `_nodeId` and `_pChainPublicKey` should not be already in use by some other data provider
     */
    function registerDataProvider(string memory _nodeId, string memory _pChainPublicKey) external;

    /**
     * @notice Unregister data provider's address as a validator - emits DataProviderUnregistered event
     */
    function unregisterDataProvider() external;

    /**
     * @notice Returns data provider's node id and P-Chain public key
     * @param _dataProvider Data provider's address
     * @return _nodeId Data provider's node id
     * @return _pChainPublicKey Data provider's P-Chain public key
     */
    function getDataProviderInfo(address _dataProvider)
        external view returns (string memory _nodeId, string memory _pChainPublicKey);

    /**
     * @notice Returns data provider's address that was registered with given node id
     * @param _nodeId Data provider's node id hash
     * @return _dataProvider Data provider's address
     */
    function getDataProviderForNodeId(bytes32 _nodeId) 
        external view returns (address _dataProvider);

    /**
     * @notice Returns data provider's address that was registered with given P-Chain public key
     * @param _pChainPublicKey Data provider's P-Chain public key hash
     * @return _dataProvider Data provider's address
     */
    function getDataProviderForPChainPublicKey(bytes32 _pChainPublicKey) 
        external view returns (address _dataProvider);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IPollingFtso.sol


pragma solidity >=0.7.6 <0.9;


interface IPollingFtso {

    /**
     * Struct holding the information about proposal properties.
     */
    struct Proposal {
        uint256 rewardEpochId;              // reward epoch id in which the proposal was created
        string description;                 // description of the proposal
        address proposer;                   // address of the proposer
        bool canceled;                      // flag indicating if proposal has been canceled
        uint256 voteStartTime;              // start time of voting window (in seconds from epoch)
        uint256 voteEndTime;                // end time of voting window (in seconds from epoch)
        uint256 thresholdConditionBIPS;     // percentage in BIPS of the total vote power required for proposal quorum
        uint256 majorityConditionBIPS;      // percentage in BIPS of the proper relation between FOR and AGAINST votes
        uint256 totalWeight;                // total weight of all eligible voters
    }

    /**
     * Struct holding the information about proposal voting.
     */
    struct ProposalVoting {
        uint256 againstVotePower;           // accumulated vote power against the proposal
        uint256 forVotePower;               // accumulated vote power for the proposal
        mapping(address => bool) hasVoted;  // flag if a voter has cast a vote
    }

    /**
     * Enum describing a proposal state.
     */
    enum ProposalState {
        Canceled,
        Pending,
        Active,
        Defeated,
        Succeeded
    }

    /**
     * Enum that determines vote (support) type.
     * 0 = Against, 1 = For.
     */
    enum VoteType {
        Against,
        For
    }

    /**
     * Event emitted when a proposal is created.
     */
    event FtsoProposalCreated(
        uint256 indexed proposalId,
        uint256 indexed rewardEpochId,
        address proposer,
        string description,
        uint256 voteStartTime,
        uint256 voteEndTime,
        uint256 threshold,
        uint256 majorityConditionBIPS,
        uint256 totalWeight
    );

    /**
     * Event emitted when a vote is cast.
     */
    event VoteCast(
        address indexed voter,
        uint256 indexed proposalId,
        uint8 support,
        uint256 forVotePower,
        uint256 againstVotePower
    );

    /**
     * Event emitted when a proposal is canceled.
     */
    event ProposalCanceled(uint256 indexed proposalId);

    /**
     * Event emitted when parameters are set.
     */
    event ParametersSet(
        uint256 votingDelaySeconds,
        uint256 votingPeriodSeconds,
        uint256 thresholdConditionBIPS,
        uint256 majorityConditionBIPS,
        uint256 proposalFeeValueWei
    );

    /**
     * Event emitted when maintainer is set.
     */
    event MaintainerSet(address newMaintainer);

    /**
     * Event emitted when proxy voter is set.
     */
    event ProxyVoterSet(address account, address proxyVoter);

    /**
     * Sets (or changes) contract's parameters. It is called after deployment of the contract
     * and every time one of the parameters changes.
     * @param _votingDelaySeconds Period between proposal creation and start of the vote, in seconds.
     * @param _votingPeriodSeconds Length of voting period, in seconds.
     * @param _thresholdConditionBIPS Share of total vote power (in BIPS) required to participate in vote
     * for proposal to pass.
     * @param _majorityConditionBIPS Share of participating vote power (in BIPS) required to vote in favor.
     * @param _proposalFeeValueWei Fee value (in wei) that proposer must pay to submit a proposal.
     */
    function setParameters(
        uint256 _votingDelaySeconds,
        uint256 _votingPeriodSeconds,
        uint256 _thresholdConditionBIPS,
        uint256 _majorityConditionBIPS,
        uint256 _proposalFeeValueWei
    )
    external;

    /**
     * Cancels an existing proposal.
     * @param _proposalId Unique identifier of a proposal.
     * Emits a ProposalCanceled event.
     */
    function cancel(uint256 _proposalId) external;

    /**
     * Creates a new proposal.
     * @param _description String description of the proposal.
     * @return _proposalId Unique identifier of the proposal.
     * Emits a FtsoProposalCreated event.
     */
    function propose(
        string memory _description
    ) external payable returns (uint256);

    /**
     * Casts a vote on a proposal.
     * @param _proposalId Id of the proposal.
     * @param _support A value indicating vote type (against, for).
     * Emits a VoteCast event.
     */
    function castVote(uint256 _proposalId, uint8 _support) external;

    /**
     * Sets a proxy voter for a voter (i.e. address that can vote in its name).
     * @param _proxyVoter Address to register as a proxy (use address(0) to remove proxy).
     * Emits a ProxyVoterSet event.
     */
    function setProxyVoter(address _proxyVoter) external;

    /**
     * Returns the current state of a proposal.
     * @param _proposalId Id of the proposal.
     * @return ProposalState enum.
     */
    function state(uint256 _proposalId) external view returns (ProposalState);

    /**
     * Returns whether a voter has cast a vote on a specific proposal.
     * @param _proposalId Id of the proposal.
     * @param _voter Address of the voter.
     * @return True if the voter has cast a vote on the proposal, and false otherwise.
     */
    function hasVoted(uint256 _proposalId, address _voter) external view returns (bool);

    /**
     * Returns information about the specified proposal.
     * @param _proposalId Id of the proposal.
     * @return _rewardEpochId Reward epoch id.
     * @return _description Description of the proposal.
     * @return _proposer Address of the proposal submitter.
     * @return _voteStartTime Start time (in seconds from epoch) of the proposal voting.
     * @return _voteEndTime End time (in seconds from epoch) of the proposal voting.
     * @return _thresholdConditionBIPS Number of votes (voter power) cast required for the proposal to pass.
     * @return _majorityConditionBIPS Number of FOR votes, as a percentage in BIPS of the.
     * @return _totalWeight Total weight of all eligible voters.
     */
    function getProposalInfo(
        uint256 _proposalId
    )
        external view
        returns (
            uint256 _rewardEpochId,
            string memory _description,
            address _proposer,
            uint256 _voteStartTime,
            uint256 _voteEndTime,
            uint256 _thresholdConditionBIPS,
            uint256 _majorityConditionBIPS,
            uint256 _totalWeight
        );

    /**
     * Returns the description string that was supplied when the specified proposal was created.
     * @param _proposalId Id of the proposal.
     * @return _description Description of the proposal.
     */
    function getProposalDescription(uint256 _proposalId) external view
        returns (string memory _description);

    /**
     * Returns id and description of the last created proposal.
     * @return _proposalId Id of the last proposal.
     * @return _description Description of the last proposal.
     */
    function getLastProposal() external view
        returns ( uint256 _proposalId, string memory _description);

    /**
     * Returns number of votes for and against the specified proposal.
     * @param _proposalId Id of the proposal.
     * @return _for Accumulated vote power for the proposal.
     * @return _against Accumulated vote power against the proposal.
     */
    function getProposalVotes(
        uint256 _proposalId
    )
        external view
        returns (
            uint256 _for,
            uint256 _against
        );

    /**
     * Returns whether an account can create proposals.
     * An address can make proposals if it is registered voter,
     * its proxy or the maintainer of the contract.
     * @param _account Address of the queried account.
     * @return True if the queried account can create a proposal, false otherwise.
     */
    function canPropose(address _account) external view returns (bool);

    /**
     * Returns whether an account can vote for a given proposal.
     * @param _account Address of the queried account.
     * @param _proposalId Id of the queried proposal.
     * @return True if account is eligible to vote, false otherwise.
     */
    function canVote(address _account, uint256 _proposalId) external view returns (bool);

}

// File: @flarenetwork/flare-periphery-contracts/coston2/IAddressBinder.sol


pragma solidity >=0.7.6 <0.9;

/**
 * Interface for the `AddressBinder` contract.
 */
interface IAddressBinder {

    /**
     * @notice Event emitted when c-chan and P-chain addresses are registered
     */
    event AddressesRegistered(bytes publicKey, bytes20 pAddress, address cAddress);

    /**
     * Register P-chain and C-chain addresses.
     * @param _publicKey Public key from which addresses to register are derived from.
     * @param _pAddress P-chain address to register.
     * @param _cAddress C-chain address to register.
     */
    function registerAddresses(bytes calldata _publicKey, bytes20 _pAddress, address _cAddress) external;

    /**
     * Register P-chain and C-chain addresses derived from given public key.
     * @param _publicKey Public key from which addresses to register are derived from.
     * @return _pAddress Registered P-chain address.
     * @return _cAddress Registered C-chain address.
     */
    function registerPublicKey(bytes calldata _publicKey) external returns(bytes20 _pAddress, address _cAddress);

    /**
     * @dev Queries the C-chain address for given P-chain address.
     * @param _pAddress The P-chain address for which corresponding C-chain address will be retrieved.
     * @return _cAddress The corresponding c-address.
     **/
    function pAddressToCAddress(bytes20 _pAddress) external view returns(address _cAddress);

    /**
     * @dev Queries the P-chain address for given C-chain address.
     * @param _cAddress The C-chain address for which corresponding P-chain address will be retrieved.
     * @return _pAddress The corresponding p-address.
     **/
    function cAddressToPAddress(address _cAddress) external view returns(bytes20 _pAddress);
}
// File: @flarenetwork/flare-periphery-contracts/coston2/IPChainStakeMirrorMultiSigVoting.sol


pragma solidity >=0.7.6 <0.9;
pragma abicoder v2;

/**
 * Interface for the `PChainStakeMirrorMultiSigVoting` contract.
 */
interface IPChainStakeMirrorMultiSigVoting {

    /**
     * Structure describing votes.
     */
    struct PChainVotes {
        bytes32 merkleRoot;
        address[] votes;
    }

    /**
     * Event emitted when voting for specific epoch is reset.
     * @param epochId Epoch id.
     */
    event PChainStakeMirrorVotingReset(uint256 epochId);

    /**
     * Event emitted when voting threshold is updated.
     * @param votingThreshold New voting threshold.
     */
    event PChainStakeMirrorVotingThresholdSet(uint256 votingThreshold);

    /**
     * Event emitted when voters are set.
     * @param voters List of new voters.
     */
    event PChainStakeMirrorVotersSet(address[] voters);

    /**
     * Event emitted when voting for specific epoch is finalized.
     * @param epochId Epoch id.
     * @param merkleRoot Voted Merkle root for that epoch id.
     */
    event PChainStakeMirrorVotingFinalized(uint256 indexed epochId, bytes32 merkleRoot);

    /**
     * Event emitted when vote for specific epoch is submitted.
     * @param epochId Epoch id.
     * @param voter Voter address.
     * @param merkleRoot Merkle root voter voted for in given epoch.
     */
    event PChainStakeMirrorVoteSubmitted(uint256 epochId, address voter, bytes32 merkleRoot);

    /**
     * Event emitted when validator uptime vote for specific reward epoch is submitted.
     * @param rewardEpochId Reward epoch id.
     * @param timestamp Timestamp of the block when the vote happened, in seconds from UNIX epoch.
     * @param voter Voter address.
     * @param nodeIds List of node ids with high enough uptime.
     */
    event PChainStakeMirrorValidatorUptimeVoteSubmitted(
        uint256 indexed rewardEpochId,
        uint256 indexed timestamp,
        address voter,
        bytes20[] nodeIds
    );

    /**
     * Method for submitting Merkle roots for given epoch.
     * @param _epochId Epoch id voter is submitting vote for.
     * @param _merkleRoot Merkle root for given epoch.
     * **NOTE**: It reverts in case voter is not eligible to vote, epoch has not ended yet or is already finalized
     *          or voter is submitting vote for the second time for the same Merkle root
                (voter can submit a vote for a different Merkle root even if voted already).
     */
    function submitVote(uint256 _epochId, bytes32 _merkleRoot) external;

    /**
     * Method for submitting node ids of those validators that have high enough uptime in given reward epoch.
     * @param _rewardEpochId Reward epoch id voter is submitting vote for.
     * @param _nodeIds List of validators (node ids) with high enough uptime in given reward epoch.
     * **NOTE**: Reward epochs are aligned with FTSO reward epochs.
     */
    function submitValidatorUptimeVote(uint256 _rewardEpochId, bytes20[] calldata _nodeIds) external;

    /**
     * Returns epochs configuration data.
     * @return _firstEpochStartTs First epoch start timestamp
     * @return _epochDurationSeconds Epoch duration in seconds
     */
    function getEpochConfiguration() external view
        returns (
            uint256 _firstEpochStartTs,
            uint256 _epochDurationSeconds
        );

    /**
     * Returns id of the epoch at the specified timestamp.
     * @param _timestamp Timestamp as seconds from unix epoch
     */
    function getEpochId(uint256 _timestamp) external view returns (uint256);

    /**
     * Returns Merkle root for the given `_epochId`.
     * @param _epochId Epoch id of the interest.
     * @return Merkle root for finalized epoch id and `bytes32(0)` otherwise.
     */
    function getMerkleRoot(uint256 _epochId) external view returns(bytes32);

     /**
     * Returns all votes for the given `_epochId` util epoch is finalized. Reverts later.
     * @param _epochId Epoch id of the interest.
     * @return Votes for for the given `_epochId`.
     */
    function getVotes(uint256 _epochId) external view returns(PChainVotes[] memory);

    /**
     * Checks if `_voter` should vote for the given `_epochId`.
     * @param _epochId Epoch id of the interest.
     * @param _voter Address of the voter.
     * @return False if voter is not eligible to vote, epoch already finalized or voter already voted. True otherwise.
     * **NOTE**: The method will return true even if epoch has not ended yet - `submitVote` will revert in that case.
     */
    function shouldVote(uint256 _epochId, address _voter) external view returns(bool);

    /**
     * Returns the list of all voters.
     * @return List of all voters.
     */
    function getVoters() external view returns(address[] memory);

     /**
     * Returns the voting threshold.
     * @return Voting threshold.
     */
    function getVotingThreshold() external view returns(uint256);

    /**
     * Returns current epoch id.
     * @return Current epoch id.
     */
    function getCurrentEpochId() external view returns (uint256);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IRandomProvider.sol


pragma solidity >=0.7.6 <0.9;

/**
 * Random provider interface.
 */
interface IRandomProvider {


    /**
     * Returns current random number. Method reverts if random number was not generated securely.
     * @return _randomNumber Current random number.
     */
    function getCurrentRandom() external view returns(uint256 _randomNumber);

    /**
     * Returns current random number and a flag indicating if it was securely generated.
     * It is up to the caller to decide whether to use the returned random number or not.
     * @return _randomNumber Current random number.
     * @return _isSecureRandom Indicates if current random number is secure.
     */
    function getCurrentRandomWithQuality() external view returns(uint256 _randomNumber, bool _isSecureRandom);

    /**
     * Returns current random number, a flag indicating if it was securely generated and its timestamp.
     * It is up to the caller to decide whether to use the returned random number or not.
     * @return _randomNumber Current random number.
     * @return _isSecureRandom Indicates if current random number is secure.
     * @return _randomTimestamp Random timestamp.
     */
    function getCurrentRandomWithQualityAndTimestamp()
        external view
        returns(uint256 _randomNumber, bool _isSecureRandom, uint256 _randomTimestamp);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/ISubmission.sol


pragma solidity >=0.7.6 <0.9;


/**
 * Submission interface.
 */
interface ISubmission is IRandomProvider {

    /// Event emitted when a new voting round is initiated.
    event NewVotingRoundInitiated();

    /**
     * Submit1 method. Used in multiple protocols (i.e. as FTSO commit method).
     */
    function submit1() external returns (bool);

    /**
     * Submit2 method. Used in multiple protocols (i.e. as FTSO reveal method).
     */
    function submit2() external returns (bool);

    /**
     * Submit3 method. Future usage.
     */
    function submit3() external returns (bool);

    /**
     * SubmitSignatures method. Used in multiple protocols (i.e. as FTSO submit signature method).
     */
    function submitSignatures() external returns (bool);

    /**
     * SubmitAndPass method. Future usage.
     * @param _data The data to pass to the submitAndPassContract.
     */
    function submitAndPass(bytes calldata _data) external returns (bool);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IEntityManager.sol


pragma solidity >=0.7.6 <0.9;

/**
 * EntityManager interface.
 */
interface IEntityManager {

    /// Voter addresses.
    struct VoterAddresses {
        address submitAddress;
        address submitSignaturesAddress;
        address signingPolicyAddress;
    }

    /// Event emitted when a node id is registered.
    event NodeIdRegistered(
        address indexed voter, bytes20 indexed nodeId);
    /// Event emitted when a node id is unregistered.
    event NodeIdUnregistered(
        address indexed voter, bytes20 indexed nodeId);
    /// Event emitted when a public key is registered.
    event PublicKeyRegistered(
        address indexed voter, bytes32 indexed part1, bytes32 indexed part2);
    /// Event emitted when a public key is unregistered.
    event PublicKeyUnregistered(
        address indexed voter, bytes32 indexed part1, bytes32 indexed part2);
    /// Event emitted when a delegation address is proposed.
    event DelegationAddressProposed(
        address indexed voter, address indexed delegationAddress);
    /// Event emitted when a delegation address registration is confirmed.
    event DelegationAddressRegistrationConfirmed(
        address indexed voter, address indexed delegationAddress);
    /// Event emitted when a submit address is proposed.
    event SubmitAddressProposed(
        address indexed voter, address indexed submitAddress);
    /// Event emitted when a submit address registration is confirmed.
    event SubmitAddressRegistrationConfirmed(
        address indexed voter, address indexed submitAddress);
    /// Event emitted when a submit signatures address is proposed.
    event SubmitSignaturesAddressProposed(
        address indexed voter, address indexed submitSignaturesAddress);
    /// Event emitted when a submit signatures address registration is confirmed.
    event SubmitSignaturesAddressRegistrationConfirmed(
        address indexed voter, address indexed submitSignaturesAddress);
    /// Event emitted when a signing policy address is proposed.
    event SigningPolicyAddressProposed(
        address indexed voter, address indexed signingPolicyAddress);
    /// Event emitted when a signing policy address registration is confirmed.
    event SigningPolicyAddressRegistrationConfirmed(
        address indexed voter, address indexed signingPolicyAddress);
    /// Event emitted when the maximum number of node ids per entity is set.
    event MaxNodeIdsPerEntitySet(
        uint256 maxNodeIdsPerEntity);

    /**
     * Registers a node id.
     * @param _nodeId Node id.
     * @param _certificateRaw Certificate in raw format.
     * @param _signature Signature.
     */
    function registerNodeId(bytes20 _nodeId, bytes calldata _certificateRaw, bytes calldata _signature) external;

    /**
     * Unregisters a node id.
     * @param _nodeId Node id.
     */
    function unregisterNodeId(bytes20 _nodeId) external;

    /**
     * Registers a public key.
     * @param _part1 First part of the public key.
     * @param _part2 Second part of the public key.
     * @param _verificationData Additional data used to verify the public key.
     */
    function registerPublicKey(bytes32 _part1, bytes32 _part2, bytes calldata _verificationData) external;

    /**
     * Unregisters a public key.
     */
    function unregisterPublicKey() external;

    /**
     * Proposes a delegation address (called by the voter).
     * @param _delegationAddress Delegation address.
     */
    function proposeDelegationAddress(address _delegationAddress) external;

    /**
     * Confirms a delegation address registration (called by the delegation address).
     * @param _voter Voter address.
     */
    function confirmDelegationAddressRegistration(address _voter) external;

    /**
     * Proposes a submit address (called by the voter).
     * @param _submitAddress Submit address.
     */
    function proposeSubmitAddress(address _submitAddress) external;

    /**
     * Confirms a submit address registration (called by the submit address).
     * @param _voter Voter address.
     */
    function confirmSubmitAddressRegistration(address _voter) external;

    /**
     * Proposes a submit signatures address (called by the voter).
     * @param _submitSignaturesAddress Submit signatures address.
     */
    function proposeSubmitSignaturesAddress(address _submitSignaturesAddress) external;

    /**
     * Confirms a submit signatures address registration (called by the submit signatures address).
     * @param _voter Voter address.
     */
    function confirmSubmitSignaturesAddressRegistration(address _voter) external;

    /**
     * Proposes a signing policy address (called by the voter).
     * @param _signingPolicyAddress Signing policy address.
     */
    function proposeSigningPolicyAddress(address _signingPolicyAddress) external;

    /**
     * Confirms a signing policy address registration (called by the signing policy address).
     * @param _voter Voter address.
     */
    function confirmSigningPolicyAddressRegistration(address _voter) external;

    /**
     * Gets the delegation address of a voter at a specific block number.
     * @param _voter Voter address.
     * @param _blockNumber Block number.
     * @return Public key.
     */
    function getDelegationAddressOfAt(address _voter, uint256 _blockNumber) external view returns(address);

    /**
     * Gets the delegation address of a voter at the current block number.
     * @param _voter Voter address.
     * @return Public key.
     */
    function getDelegationAddressOf(address _voter) external view returns(address);

    /**
     * Gets the node ids of a voter at a specific block number.
     * @param _voter Voter address.
     * @param _blockNumber Block number.
     * @return Node ids.
     */
    function getNodeIdsOfAt(address _voter, uint256 _blockNumber) external view returns (bytes20[] memory);

    /**
     * Gets the node ids of a voter at the current block number.
     * @param _voter Voter address.
     * @return Node ids.
     */
    function getNodeIdsOf(address _voter) external view returns (bytes20[] memory);

    /**
     * Gets the public key of a voter at a specific block number.
     * @param _voter Voter address.
     * @param _blockNumber Block number.
     * @return Public key.
     */
    function getPublicKeyOfAt(address _voter, uint256 _blockNumber) external view returns(bytes32, bytes32);

    /**
     * Gets the public key of a voter at the current block number.
     * @param _voter Voter address.
     * @return Public key.
     */
    function getPublicKeyOf(address _voter) external view returns(bytes32, bytes32);

    /**
     * Gets voter's addresses at a specific block number.
     * @param _voter Voter address.
     * @param _blockNumber Block number.
     * @return _addresses Voter addresses.
     */
    function getVoterAddressesAt(address _voter, uint256 _blockNumber)
        external view
        returns (VoterAddresses memory _addresses);

    /**
     * Gets voter's addresses at the current block number.
     * @param _voter Voter address.
     * @return _addresses Voter addresses.
     */
    function getVoterAddresses(address _voter)
        external view
        returns (VoterAddresses memory _addresses);

    /**
     * Gets voter's address for a node id at a specific block number.
     * @param _nodeId Node id.
     * @param _blockNumber Block number.
     * @return _voter Voter address.
     */
    function getVoterForNodeId(bytes20 _nodeId, uint256 _blockNumber)
        external view
        returns (address _voter);

    /**
     * Gets voter's address for a public key at a specific block number.
     * @param _part1 First part of the public key.
     * @param _part2 Second part of the public key.
     * @param _blockNumber Block number.
     * @return _voter Voter address.
     */
    function getVoterForPublicKey(bytes32 _part1, bytes32 _part2, uint256 _blockNumber)
        external view
        returns (address _voter);

    /**
     * Gets voter's address for a delegation address at a specific block number.
     * @param _delegationAddress Delegation address.
     * @param _blockNumber Block number.
     * @return _voter Voter address.
     */
    function getVoterForDelegationAddress(address _delegationAddress, uint256 _blockNumber)
        external view
        returns (address _voter);

    /**
     * Gets voter's address for a submit address at a specific block number.
     * @param _submitAddress Submit address.
     * @param _blockNumber Block number.
     * @return _voter Voter address.
     */
    function getVoterForSubmitAddress(address _submitAddress, uint256 _blockNumber)
        external view
        returns (address _voter);

    /**
     * Gets voter's address for a submit signatures address at a specific block number.
     * @param _submitSignaturesAddress Submit signatures address.
     * @param _blockNumber Block number.
     * @return _voter Voter address.
     */
    function getVoterForSubmitSignaturesAddress(address _submitSignaturesAddress, uint256 _blockNumber)
        external view
        returns (address _voter);

    /**
     * Gets voter's address for a signing policy address at a specific block number.
     * @param _signingPolicyAddress Signing policy address.
     * @param _blockNumber Block number.
     * @return _voter Voter address.
     */
    function getVoterForSigningPolicyAddress(address _signingPolicyAddress, uint256 _blockNumber)
        external view
        returns (address _voter);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IVoterRegistry.sol


pragma solidity >=0.7.6 <0.9;

/**
 * VoterRegistry interface.
 */
interface IVoterRegistry {

    /// Signature data.
    struct Signature {
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    /// Event emitted when a beneficiary (c-chain address or node id) is chilled.
    event BeneficiaryChilled(bytes20 indexed beneficiary, uint256 untilRewardEpochId);

    /// Event emitted when a voter is removed.
    event VoterRemoved(address indexed voter, uint256 indexed rewardEpochId);

    /// Event emitted when a voter is registered.
    event VoterRegistered(
        address indexed voter,
        uint24 indexed rewardEpochId,
        address indexed signingPolicyAddress,
        address submitAddress,
        address submitSignaturesAddress,
        bytes32 publicKeyPart1,
        bytes32 publicKeyPart2,
        uint256 registrationWeight
    );

    /**
     * Registers a voter if the weight is high enough.
     * @param _voter The voter address.
     * @param _signature The signature.
     */
    function registerVoter(address _voter, Signature calldata _signature) external;

    /**
     * Maximum number of voters in one reward epoch.
     */
    function maxVoters() external view returns (uint256);

    /**
     * In case of providing bad votes (e.g. ftso collusion), the beneficiary can be chilled for a few reward epochs.
     * If beneficiary is chilled, the vote power assigned to it is zero.
     * @param _beneficiary The beneficiary (c-chain address or node id).
     * @return _rewardEpochId The reward epoch id until which the voter is chilled.
     */
    function chilledUntilRewardEpochId(bytes20 _beneficiary) external view returns (uint256 _rewardEpochId);

    /**
     * Returns the block number of the start of the new signing policy initialisation for a given reward epoch.
     * It is a snaphost block of the voters' addresses (it is zero if the reward epoch is not supported).
     * @param _rewardEpochId The reward epoch id.
     */
    function newSigningPolicyInitializationStartBlockNumber(uint256 _rewardEpochId) external view returns (uint256);

    /**
     * Indicates if the voter must have the public key set when registering.
     */
    function publicKeyRequired() external view returns (bool);

    /**
     * Returns the list of registered voters for a given reward epoch.
     * List can be empty if the reward epoch is not supported (before initial reward epoch or future reward epoch).
     * List for the next reward epoch can still change until the signing policy snapshot is created.
     * @param _rewardEpochId The reward epoch id.
     */
    function getRegisteredVoters(uint256 _rewardEpochId) external view returns (address[] memory);

    /**
     * Returns the number of registered voters for a given reward epoch.
     * Size can be zero if the reward epoch is not supported (before initial reward epoch or future reward epoch).
     * Size for the next reward epoch can still change until the signing policy snapshot is created.
     * @param _rewardEpochId The reward epoch id.
     */
    function getNumberOfRegisteredVoters(uint256 _rewardEpochId) external view returns (uint256);

    /**
     * Returns true if a voter was (is currently) registered in a given reward epoch.
     * @param _voter The voter address.
     * @param _rewardEpochId The reward epoch id.
     */
    function isVoterRegistered(address _voter, uint256 _rewardEpochId) external view returns(bool);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IFlareSystemsCalculator.sol


pragma solidity >=0.7.6 <0.9;


/**
 * FlareSystemsCalculator interface.
 */
interface IFlareSystemsCalculator {

    /// Event emitted when the registration weight of a voter is calculated.
    event VoterRegistrationInfo(
        address indexed voter,
        uint24 indexed rewardEpochId,
        address delegationAddress,
        uint16 delegationFeeBIPS,
        uint256 wNatWeight,
        uint256 wNatCappedWeight,
        bytes20[] nodeIds,
        uint256[] nodeWeights
    );

    /// WNat cap used in signing policy weight.
    function wNatCapPPM() external view returns (uint24);
    /// Non-punishable time to sign new signing policy.
    function signingPolicySignNonPunishableDurationSeconds() external view returns (uint64);
    /// Number of non-punishable blocks to sign new signing policy.
    function signingPolicySignNonPunishableDurationBlocks() external view returns (uint64);
    /// Number of blocks (in addition to non-punishable blocks) after which all rewards are burned.
    function signingPolicySignNoRewardsDurationBlocks() external view returns (uint64);

}

// File: @flarenetwork/flare-periphery-contracts/coston2/ProtocolsV2Interface.sol


pragma solidity >=0.7.6 <0.9;

/**
 * Protocols V2 long term support interface.
 */
interface ProtocolsV2Interface {

    /**
     * Timestamp when the first reward epoch started, in seconds since UNIX epoch.
     */
    function firstRewardEpochStartTs() external view returns (uint64);

    /**
     * Duration of reward epoch, in seconds.
     */
    function rewardEpochDurationSeconds() external view returns (uint64);

    /**
     * Timestamp when the first voting epoch started, in seconds since UNIX epoch.
     */
    function firstVotingRoundStartTs() external view returns (uint64);

    /**
     * Duration of voting epoch, in seconds.
     */
    function votingEpochDurationSeconds() external view returns (uint64);

    /**
     * Returns the vote power block for given reward epoch id.
     */
    function getVotePowerBlock(uint256 _rewardEpochId)
        external view
        returns(uint64 _votePowerBlock);

    /**
     * Returns the start voting round id for given reward epoch id.
     */
    function getStartVotingRoundId(uint256 _rewardEpochId)
        external view
        returns(uint32);

    /**
     * Returns the current reward epoch id.
     */
    function getCurrentRewardEpochId() external view returns(uint24);

    /**
     * Returns the current voting epoch id.
     */
    function getCurrentVotingEpochId() external view returns(uint32);

}
// File: @flarenetwork/flare-periphery-contracts/coston2/IFlareSystemsManager.sol


pragma solidity >=0.7.6 <0.9;


/**
 * FlareSystemsManager interface.
 */
interface IFlareSystemsManager is ProtocolsV2Interface {

    /// Signature structure
    struct Signature {
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    /// Number of weight based claims structure
    struct NumberOfWeightBasedClaims {
        uint256 rewardManagerId;
        uint256 noOfWeightBasedClaims;
    }

    /// Event emitted when random acquisition phase starts.
    event RandomAcquisitionStarted(
        uint24 indexed rewardEpochId,   // Reward epoch id
        uint64 timestamp                // Timestamp when this happened
    );

    /// Event emitted when vote power block is selected.
    event VotePowerBlockSelected(
        uint24 indexed rewardEpochId,   // Reward epoch id
        uint64 votePowerBlock,          // Vote power block for given reward epoch
        uint64 timestamp                // Timestamp when this happened
    );

    /// Event emitted when signing policy is signed.
    event SigningPolicySigned(
        uint24 indexed rewardEpochId,           // Reward epoch id
        address indexed signingPolicyAddress,   // Address which signed this
        address indexed voter,                  // Voter (entity)
        uint64 timestamp,                       // Timestamp when this happened
        bool thresholdReached                   // Indicates if signing threshold was reached
    );

    /// Event emitted when reward epoch starts.
    event RewardEpochStarted(
        uint24 indexed rewardEpochId,   // Reward epoch id
        uint32 startVotingRoundId,      // First voting round id of validity
        uint64 timestamp                // Timestamp when this happened
    );

    /// Event emitted when it is time to sign uptime vote.
    event SignUptimeVoteEnabled(
        uint24 indexed rewardEpochId,   // Reward epoch id
        uint64 timestamp                // Timestamp when this happened
    );

    /// Event emitted when uptime vote is submitted.
    event UptimeVoteSubmitted(
        uint24 indexed rewardEpochId,           // Reward epoch id
        address indexed signingPolicyAddress,   // Address which signed this
        address indexed voter,                  // Voter (entity)
        bytes20[] nodeIds,                      // Node ids with high enough uptime
        uint64 timestamp                        // Timestamp when this happened
    );

    /// Event emitted when uptime vote is signed.
    event UptimeVoteSigned(
        uint24 indexed rewardEpochId,           // Reward epoch id
        address indexed signingPolicyAddress,   // Address which signed this
        address indexed voter,                  // Voter (entity)
        bytes32 uptimeVoteHash,                 // Uptime vote hash
        uint64 timestamp,                       // Timestamp when this happened
        bool thresholdReached                   // Indicates if signing threshold was reached
    );

    /// Event emitted when rewards are signed.
    event RewardsSigned(
        uint24 indexed rewardEpochId,                       // Reward epoch id
        address indexed signingPolicyAddress,               // Address which signed this
        address indexed voter,                              // Voter (entity)
        bytes32 rewardsHash,                                // Rewards hash
        NumberOfWeightBasedClaims[] noOfWeightBasedClaims,  // Number of weight based claims list
        uint64 timestamp,                                   // Timestamp when this happened
        bool thresholdReached                               // Indicates if signing threshold was reached
    );

    /**
     * Method for collecting signatures for the new signing policy.
     * @param _rewardEpochId Reward epoch id of the new signing policy.
     * @param _newSigningPolicyHash New signing policy hash.
     * @param _signature Signature.
     */
    function signNewSigningPolicy(
        uint24 _rewardEpochId,
        bytes32 _newSigningPolicyHash,
        Signature calldata _signature
    )
        external;

    /**
     * Method for submitting node ids with high enough uptime.
     * @param _rewardEpochId Reward epoch id of the uptime vote.
     * @param _nodeIds Node ids with high enough uptime.
     * @param _signature Signature.
     */
    function submitUptimeVote(
        uint24 _rewardEpochId,
        bytes20[] calldata _nodeIds,
        Signature calldata _signature
    )
        external;

    /**
     * Method for collecting signatures for the uptime vote.
     * @param _rewardEpochId Reward epoch id of the uptime vote.
     * @param _uptimeVoteHash Uptime vote hash.
     * @param _signature Signature.
     */
    function signUptimeVote(
        uint24 _rewardEpochId,
        bytes32 _uptimeVoteHash,
        Signature calldata _signature
    )
        external;

    /**
     * Method for collecting signatures for the rewards.
     * @param _rewardEpochId Reward epoch id of the rewards.
     * @param _noOfWeightBasedClaims Number of weight based claims list.
     * @param _rewardsHash Rewards hash.
     * @param _signature Signature.
     */
    function signRewards(
        uint24 _rewardEpochId,
        NumberOfWeightBasedClaims[] calldata _noOfWeightBasedClaims,
        bytes32 _rewardsHash,
        Signature calldata _signature
    )
        external;

    /**
     * Returns the seed for given reward epoch id.
     */
    function getSeed(uint256 _rewardEpochId)
        external view
        returns(uint256);

    /**
     * Returns the threshold for given reward epoch id.
     */
    function getThreshold(uint256 _rewardEpochId)
        external view
        returns(uint16);

    /**
     * Returns voter rgistration data for given reward epoch id.
     * @param _rewardEpochId Reward epoch id.
     * @return _votePowerBlock Vote power block.
     * @return _enabled Indicates if voter registration is enabled.
     */
    function getVoterRegistrationData(
        uint256 _rewardEpochId
    )
        external view
        returns (
            uint256 _votePowerBlock,
            bool _enabled
        );

    /**
     * Indicates if voter registration is currently enabled.
     */
    function isVoterRegistrationEnabled() external view returns (bool);

    /**
     * Returns the current reward epoch id (backwards compatibility).
     */
    function getCurrentRewardEpoch() external view returns(uint256);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/RewardsV2Interface.sol


pragma solidity >=0.7.6 <0.9;

/**
 * Rewards V2 long term support interface.
 */
interface RewardsV2Interface {

    /// Claim type enum.
    enum ClaimType { DIRECT, FEE, WNAT, MIRROR, CCHAIN }

   /// Struct used for claiming rewards with Merkle proof.
    struct RewardClaimWithProof {
        bytes32[] merkleProof;
        RewardClaim body;
    }

    /// Struct used in Merkle tree for storing reward claims.
    struct RewardClaim {
        uint24 rewardEpochId;
        bytes20 beneficiary; // c-chain address or node id (bytes20) in case of type MIRROR
        uint120 amount; // in wei
        ClaimType claimType;
    }

    /// Struct used for returning state of rewards.
    struct RewardState {
        uint24 rewardEpochId;
        bytes20 beneficiary; // c-chain address or node id (bytes20) in case of type MIRROR
        uint120 amount; // in wei
        ClaimType claimType;
        bool initialised;
    }

    /**
     * Claim rewards for `_rewardOwner` and transfer them to `_recipient`.
     * It can be called by reward owner or its authorized executor.
     * @param _rewardOwner Address of the reward owner.
     * @param _recipient Address of the reward recipient.
     * @param _rewardEpochId Id of the reward epoch up to which the rewards are claimed.
     * @param _wrap Indicates if the reward should be wrapped (deposited) to the WNAT contract.
     * @param _proofs Array of reward claims with merkle proofs.
     * @return _rewardAmountWei Amount of rewarded native tokens (wei).
     */
    function claim(
        address _rewardOwner,
        address payable _recipient,
        uint24 _rewardEpochId,
        bool _wrap,
        RewardClaimWithProof[] calldata _proofs
    )
        external
        returns (uint256 _rewardAmountWei);

    /**
     * Indicates if the contract is active - claims are enabled.
     */
    function active() external view returns (bool);

    /**
     * Returns the start and the end of the reward epoch range for which the reward is claimable.
     * @return _startEpochId The oldest epoch id that allows reward claiming.
     * @return _endEpochId The newest epoch id that allows reward claiming.
     */
    function getRewardEpochIdsWithClaimableRewards()
        external view
        returns (
            uint24 _startEpochId,
            uint24 _endEpochId
        );

    /**
     * Returns the next claimable reward epoch for a reward owner.
     * @param _rewardOwner Address of the reward owner to query.
     */
    function getNextClaimableRewardEpochId(address _rewardOwner) external view returns (uint256);

    /**
     * Returns the state of rewards for a given address for all unclaimed reward epochs with claimable rewards.
     * @param _rewardOwner Address of the reward owner.
     * @return _rewardStates Array of reward states.
     */
    function getStateOfRewards(
        address _rewardOwner
    )
        external view
        returns (
            RewardState[][] memory _rewardStates
        );

}
// File: @flarenetwork/flare-periphery-contracts/coston2/IRewardManager.sol


pragma solidity >=0.7.6 <0.9;


/**
 * RewardManager interface.
 */
interface IRewardManager is RewardsV2Interface {

    /// Struct used for storing unclaimed reward data.
    struct UnclaimedRewardState {
        bool initialised;           // Information if already initialised
                                    // amount and weight might be 0 if all users already claimed
        uint120 amount;             // Total unclaimed amount.
        uint128 weight;             // Total unclaimed weight.
    }

    /**
     * Emitted when rewards are claimed.
     * @param beneficiary Address of the beneficiary (voter or node id) that accrued the reward.
     * @param rewardOwner Address that was eligible for the rewards.
     * @param recipient Address that received the reward.
     * @param rewardEpochId Id of the reward epoch where the reward was accrued.
     * @param claimType Claim type
     * @param amount Amount of rewarded native tokens (wei).
     */
    event RewardClaimed(
        address indexed beneficiary,
        address indexed rewardOwner,
        address indexed recipient,
        uint24 rewardEpochId,
        ClaimType claimType,
        uint120 amount
    );

    /**
     * Unclaimed rewards have expired and are now inaccessible.
     *
     * `getUnclaimedRewardState()` can be used to retrieve more information.
     * @param rewardEpochId Id of the reward epoch that has just expired.
     */
    event RewardClaimsExpired(uint256 indexed rewardEpochId);

    /**
     * Emitted when reward claims have been enabled.
     * @param rewardEpochId First claimable reward epoch.
     */
    event RewardClaimsEnabled(uint256 indexed rewardEpochId);

    /**
     * Claim rewards for `_rewardOwners` and their PDAs.
     * Rewards are deposited to the WNAT (to reward owner or PDA if enabled).
     * It can be called by reward owner or its authorized executor.
     * Only claiming from weight based claims is supported.
     * @param _rewardOwners Array of reward owners.
     * @param _rewardEpochId Id of the reward epoch up to which the rewards are claimed.
     * @param _proofs Array of reward claims with merkle proofs.
     */
    function autoClaim(
        address[] calldata _rewardOwners,
        uint24 _rewardEpochId,
        RewardClaimWithProof[] calldata _proofs
    )
        external;

    /**
     * Initialises weight based claims.
     * @param _proofs Array of reward claims with merkle proofs.
     */
    function initialiseWeightBasedClaims(RewardClaimWithProof[] calldata _proofs) external;

    /**
     * Returns the number of weight based claims that have been initialised.
     * @param _rewardEpochId Reward epoch id.
     */
    function noOfInitialisedWeightBasedClaims(uint256 _rewardEpochId) external view returns (uint256);

    /**
     * Get the current cleanup block number.
     * @return The currently set cleanup block number.
     */
    function cleanupBlockNumber() external view returns (uint256);

    /**
     * Returns the state of rewards for a given address at a specific reward epoch.
     * @param _rewardOwner Address of the reward owner.
     * @param _rewardEpochId Reward epoch id.
     * @return _rewardStates Array of reward states.
     */
    function getStateOfRewardsAt(
        address _rewardOwner,
        uint24 _rewardEpochId
    )
        external view
        returns (
            RewardState[] memory _rewardStates
        );

    /**
     * Gets the unclaimed reward state for a beneficiary, reward epoch id and claim type.
     * @param _beneficiary Address of the beneficiary to query.
     * @param _rewardEpochId Id of the reward epoch to query.
     * @param _claimType Claim type to query.
     * @return _state Unclaimed reward state.
     */
    function getUnclaimedRewardState(
        address _beneficiary,
        uint24 _rewardEpochId,
        ClaimType _claimType
    )
        external view
        returns (
            UnclaimedRewardState memory _state
        );

    /**
     * Returns totals.
     * @return _totalRewardsWei Total rewards (wei).
     * @return _totalInflationRewardsWei Total inflation rewards (wei).
     * @return _totalClaimedWei Total claimed rewards (wei).
     * @return _totalBurnedWei Total burned rewards (wei).
     */
    function getTotals()
        external view
        returns (
            uint256 _totalRewardsWei,
            uint256 _totalInflationRewardsWei,
            uint256 _totalClaimedWei,
            uint256 _totalBurnedWei
        );

    /**
     * Returns reward epoch totals.
     * @param _rewardEpochId Reward epoch id.
     * @return _totalRewardsWei Total rewards (inflation + community) for the epoch (wei).
     * @return _totalInflationRewardsWei Total inflation rewards for the epoch (wei).
     * @return _initialisedRewardsWei Initialised rewards of all claim types for the epoch (wei).
     * @return _claimedRewardsWei Claimed rewards for the epoch (wei).
     * @return _burnedRewardsWei Burned rewards for the epoch (wei).
     */
    function getRewardEpochTotals(uint24 _rewardEpochId)
        external view
        returns (
            uint256 _totalRewardsWei,
            uint256 _totalInflationRewardsWei,
            uint256 _initialisedRewardsWei,
            uint256 _claimedRewardsWei,
            uint256 _burnedRewardsWei
        );

     /**
     * Returns current reward epoch id.
     */
    function getCurrentRewardEpochId() external view returns (uint24);

    /**
     * Returns initial reward epoch id.
     */
    function getInitialRewardEpochId() external view returns (uint256);

    /**
     * Returns the reward epoch id that will expire next once a new reward epoch starts.
     */
    function getRewardEpochIdToExpireNext() external view returns (uint256);

    /**
     * The first reward epoch id that was claimable.
     */
    function firstClaimableRewardEpochId() external view returns (uint24);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/RandomNumberV2Interface.sol


pragma solidity >=0.7.6 <0.9;

/**
 * Random number V2 long term support interface.
 */
interface RandomNumberV2Interface {
    /**
     * Returns the current random number, its timestamp and the flag indicating if it is secure.
     * @return _randomNumber The current random number.
     * @return _isSecureRandom The flag indicating if the random number is secure.
     * @return _randomTimestamp The timestamp of the random number.
     */
    function getRandomNumber()
        external view
        returns (
            uint256 _randomNumber,
            bool _isSecureRandom,
            uint256 _randomTimestamp
        );

    /**
     * Returns the historical random number for a given _votingRoundId,
     * its timestamp and the flag indicating if it is secure.
     * If no finalization in the _votingRoundId, the function reverts.
     * @param _votingRoundId The voting round id.
     * @return _randomNumber The current random number.
     * @return _isSecureRandom The flag indicating if the random number is secure.
     * @return _randomTimestamp The timestamp of the random number.
     */
    function getRandomNumberHistorical(uint256 _votingRoundId)
        external view
        returns (
            uint256 _randomNumber,
            bool _isSecureRandom,
            uint256 _randomTimestamp
        );
}
// File: @flarenetwork/flare-periphery-contracts/coston2/IRelay.sol


pragma solidity >=0.7.6 <0.9;


/**
 * Relay interface.
 */
interface IRelay is RandomNumberV2Interface {

    struct FeeConfig {
        uint8 protocolId;   // Protocol id for which the fee is set
        uint256 feeInWei;   // Fee in wei
    }

    struct RelayInitialConfig {
        uint32 initialRewardEpochId;                           // The initial reward epoch id.
        uint32 startingVotingRoundIdForInitialRewardEpochId;   // The starting voting round id for the initial
                                                               // reward epoch.
        bytes32 initialSigningPolicyHash;                      // The initial signing policy hash.
        uint8 randomNumberProtocolId;                          // The protocol id of the random number protocol.
        uint32 firstVotingRoundStartTs;                        // The timestamp of the first voting round start.
        uint8 votingEpochDurationSeconds;                      // The duration of a voting epoch in seconds.
        uint32 firstRewardEpochStartVotingRoundId;             // The start voting round id of the first reward epoch.
        uint16 rewardEpochDurationInVotingEpochs;              // The duration of a reward epoch in voting epochs.
        uint16 thresholdIncreaseBIPS;                          // The threshold increase in BIPS for signing with
                                                               // old signing policy.
        uint32 messageFinalizationWindowInRewardEpochs;        // The window of reward epochs for finalizing
                                                               // the protocol messages.
        address payable feeCollectionAddress;                  // Fee collection address
        FeeConfig[] feeConfigs;                                // Fee configurations
    }

    struct RelayGovernanceConfig {
        bytes32 descriptionHash;        // Description hash (should be keccak256("RelayGovernance")
        uint256 chainId;                // Chain id on which is the relay is deployed
        FeeConfig[] newFeeConfigs;      // Fee configurations
    }

    // Event is emitted when a new signing policy is initialized by the signing policy setter.
    event SigningPolicyInitialized(
        uint24 indexed rewardEpochId,   // Reward epoch id
        uint32 startVotingRoundId,      // First voting round id of validity.
                                        // Usually it is the first voting round of reward epoch rewardEpochId.
                                        // It can be later,
                                        // if the confirmation of the signing policy on Flare blockchain gets delayed.
        uint16 threshold,               // Confirmation threshold (absolute value of noramalised weights).
        uint256 seed,                   // Random seed.
        address[] voters,               // The list of eligible voters in the canonical order.
        uint16[] weights,               // The corresponding list of normalised signing weights of eligible voters.
                                        // Normalisation is done by compressing the weights from 32-byte values to
                                        // 2 bytes, while approximately keeping the weight relations.
        bytes signingPolicyBytes,       // The full signing policy byte encoded.
        uint64 timestamp                // Timestamp when this happened
    );

    // Event is emitted when a signing policy is relayed.
    // It contains minimalistic data in order to save gas. Data about the signing policy are
    // extractable from the calldata, assuming prefered usage of direct top-level call to relay().
    event SigningPolicyRelayed(
        uint256 indexed rewardEpochId        // Reward epoch id
    );

    // Event is emitted when a protocol message is relayed.
    event ProtocolMessageRelayed(
        uint8 indexed protocolId,           // Protocol id
        uint32 indexed votingRoundId,       // Voting round id
        bool isSecureRandom,                // Secure random flag
        bytes32 merkleRoot                  // Merkle root of the protocol message
    );

    /**
     * Checks the relay message for sufficient weight of signatures for the _messageHash
     * signed for protocol message Merkle root of the form (1, 0, 0, _messageHash).
     * If the check is successful, reward epoch id of the signing policy is returned.
     * Otherwise the function reverts.
     * @param _relayMessage The relay message.
     * @param _messageHash The hash of the message.
     * @return _rewardEpochId The reward epoch id of the signing policy.
     */
    function verifyCustomSignature(
        bytes calldata _relayMessage,
        bytes32 _messageHash
    )
        external
        returns (uint256 _rewardEpochId);

    /**
     * Checks the relay message for sufficient weight of signatures of the hash of the _config data.
     * If the check is successful, the relay contract is configured with the new _config data, which
     * in particular means that fee configurations are updated.
     * Otherwise the function reverts.
     * @param _relayMessage The relay message.
     * @param _config The new relay configuration.
     */
    function governanceFeeSetup(bytes calldata _relayMessage, RelayGovernanceConfig calldata _config) external;

    /**
     * Finalization function for new signing policies and protocol messages.
     * It can be used as finalization contract on Flare chain or as relay contract on other EVM chain.
     * Can be called in two modes. It expects calldata that is parsed in a custom manner.
     * Hence the transaction calls should assemble relevant calldata in the 'data' field.
     * Depending on the data provided, the contract operations in essentially two modes:
     * (1) Relaying signing policy. The structure of the calldata is:
     *        function signature (4 bytes) + active signing policy
     *             + 0 (1 byte) + new signing policy,
     *     total of exactly 4423 bytes.
     * (2) Relaying signed message. The structure of the calldata is:
     *        function signature (4 bytes) + signing policy
     *           + signed message (38 bytes) + ECDSA signatures with indices (67 bytes each)
     *     This case splits into two subcases:
     *     - protocolMessageId = 1: Message id must be of the form (protocolMessageId, 0, 0, merkleRoot).
     *       The validity of the signatures of sufficient weight is checked and if
     *       successful, the merkleRoot from the message is returned (32 bytes) and the
     *       reward epoch id of the signing policy as well (additional 3 bytes)
     *     - protocolMessageId > 1: The validity of the signatures of sufficient weight is checked and if
     *       it is valid, the merkleRoot is published for protocolId and votingRoundId.
     * Reverts if relaying is not successful.
     */
    function relay() external returns (bytes memory);

    /**
     * Verifies the leaf (or intermediate node) with the Merkle proof against the Merkle root
     * for given protocol id and voting round id.
     * A fee may need to be paid. It is protocol specific.
     * **NOTE:** Overpayment is not refunded.
     * @param _protocolId The protocol id.
     * @param _votingRoundId The voting round id.
     * @param _leaf The leaf (or intermediate node) to verify.
     * @param _proof The Merkle proof.
     * @return True if the verification is successful.
     */
    function verify(uint256 _protocolId, uint256 _votingRoundId, bytes32 _leaf, bytes32[] calldata _proof)
        external payable
        returns (bool);

    /**
     * Returns the signing policy hash for given reward epoch id.
     * The function is reverted if signingPolicySetter is set, hence on all
     * deployments where the contract is used as a pure relay.
     * @param _rewardEpochId The reward epoch id.
     * @return _signingPolicyHash The signing policy hash.
     */
    function toSigningPolicyHash(uint256 _rewardEpochId) external view returns (bytes32 _signingPolicyHash);

    /**
     * Returns true if there is finalization for a given protocol id and voting round id.
     * @param _protocolId The protocol id.
     * @param _votingRoundId The voting round id.
     */
    function isFinalized(uint256 _protocolId, uint256 _votingRoundId) external view returns (bool);

    /**
     * Returns the Merkle root for given protocol id and voting round id.
     * The function is reverted if signingPolicySetter is set, hence on all
     * deployments where the contract is used as a pure relay.
     * @param _protocolId The protocol id.
     * @param _votingRoundId The voting round id.
     * @return _merkleRoot The Merkle root.
     */
    function merkleRoots(uint256 _protocolId, uint256 _votingRoundId) external view returns (bytes32 _merkleRoot);

    /**
     * Returns the start voting round id for given reward epoch id.
     * @param _rewardEpochId The reward epoch id.
     * @return _startingVotingRoundId The start voting round id.
     */
    function startingVotingRoundIds(uint256 _rewardEpochId) external view returns (uint256 _startingVotingRoundId);

    /**
     * Returns the voting round id for given timestamp.
     * @param _timestamp The timestamp.
     * @return _votingRoundId The voting round id.
     */
    function getVotingRoundId(uint256 _timestamp) external view returns (uint256 _votingRoundId);

    /**
     * Returns last initialized reward epoch data.
     * @return _lastInitializedRewardEpoch Last initialized reward epoch.
     * @return _startingVotingRoundIdForLastInitializedRewardEpoch Starting voting round id for it.
     */
    function lastInitializedRewardEpochData()
        external view
        returns (
            uint32 _lastInitializedRewardEpoch,
            uint32 _startingVotingRoundIdForLastInitializedRewardEpoch
        );

    /**
     * Returns fee collection address.
     */
    function feeCollectionAddress() external view returns (address payable);

    /**
     * Returns fee in wei for one verification of a given protocol id.
     * @param _protocolId The protocol id.
     */
    function protocolFeeInWei(uint256 _protocolId) external view returns (uint256);

}

// File: @flarenetwork/flare-periphery-contracts/coston2/IWNatDelegationFee.sol


pragma solidity >=0.7.6 <0.9;

/**
 * WNatDelegationFee interface.
 */
interface IWNatDelegationFee {

    /// Event emitted when a voter fee percentage value is changed.
    event FeePercentageChanged(address indexed voter, uint16 value, uint24 validFromEpochId);

    /**
     * Allows voter to set (or update last) fee percentage.
     * @param _feePercentageBIPS Number representing fee percentage in BIPS.
     * @return Returns the reward epoch number when the value becomes effective.
     */
    function setVoterFeePercentage(uint16 _feePercentageBIPS) external returns (uint256);

    /// The offset in reward epochs for the fee percentage value to become effective.
    function feePercentageUpdateOffset() external view returns (uint24);

    /// The default fee percentage value.
    function defaultFeePercentageBIPS() external view returns (uint16);

    /**
     * Returns the current fee percentage of `_voter`.
     * @param _voter Voter address.
     */
    function getVoterCurrentFeePercentage(address _voter) external view returns (uint16);

    /**
     * Returns the fee percentage of `_voter` for given reward epoch id.
     * @param _voter Voter address.
     * @param _rewardEpochId Reward epoch id.
     * **NOTE:** fee percentage might still change for the `current + feePercentageUpdateOffset` reward epoch id
     */
    function getVoterFeePercentage(
        address _voter,
        uint256 _rewardEpochId
    )
        external view
        returns (uint16);

    /**
     * Returns the scheduled fee percentage changes of `_voter`.
     * @param _voter Voter address.
     * @return _feePercentageBIPS Positional array of fee percentages in BIPS.
     * @return _validFromEpochId Positional array of reward epoch ids the fee setings are effective from.
     * @return _fixed Positional array of boolean values indicating if settings are subjected to change.
     */
    function getVoterScheduledFeePercentageChanges(
        address _voter
    )
        external view
        returns (
            uint256[] memory _feePercentageBIPS,
            uint256[] memory _validFromEpochId,
            bool[] memory _fixed
        );
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IFtsoInflationConfigurations.sol


pragma solidity >=0.7.6 <0.9;


/**
 * FtsoInflationConfigurations interface.
 */
interface IFtsoInflationConfigurations {

    /// The FTSO configuration struct.
    struct FtsoConfiguration {
        // concatenated feed ids - i.e. category + base/quote symbol - multiple of 21 (one feedId is bytes21)
        bytes feedIds;
        // inflation share for this configuration group
        uint24 inflationShare;
        // minimal reward eligibility turnout threshold in BIPS (basis points)
        uint16 minRewardedTurnoutBIPS;
        // primary band reward share in PPM (parts per million)
        uint24 primaryBandRewardSharePPM;
        // secondary band width in PPM (parts per million) in relation to the median - multiple of 3 (uint24)
        bytes secondaryBandWidthPPMs;
        // rewards split mode (0 means equally, 1 means random,...)
        uint16 mode;
    }

    /**
     * Returns the FTSO configuration at `_index`.
     * @param _index The index of the FTSO configuration.
     */
    function getFtsoConfiguration(uint256 _index) external view returns(FtsoConfiguration memory);

    /**
     * Returns the FTSO configurations.
     */
    function getFtsoConfigurations() external view returns(FtsoConfiguration[] memory);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IFtsoRewardOffersManager.sol


pragma solidity >=0.7.6 <0.9;

/**
 * FtsoRewardOffersManager interface.
 */
interface IFtsoRewardOffersManager {

    /**
    * Defines a reward offer.
    */
    struct Offer {
        // amount (in wei) of reward in native coin
        uint120 amount;
        // feed id - i.e. category + base/quote symbol
        bytes21 feedId;
        // minimal reward eligibility turnout threshold in BIPS (basis points)
        uint16 minRewardedTurnoutBIPS;
        // primary band reward share in PPM (parts per million)
        uint24 primaryBandRewardSharePPM;
        // secondary band width in PPM (parts per million) in relation to the median
        uint24 secondaryBandWidthPPM;
        // address that can claim undistributed part of the reward (or burn address)
        address claimBackAddress;
    }

    /// Event emitted when the minimal rewards offer value is set.
    event MinimalRewardsOfferValueSet(uint256 valueWei);

    /// Event emitted when a reward offer is received.
    event RewardsOffered(
        // reward epoch id
        uint24 indexed rewardEpochId,
        // feed id - i.e. category + base/quote symbol
        bytes21 feedId,
        // number of decimals (negative exponent)
        int8 decimals,
        // amount (in wei) of reward in native coin
        uint256 amount,
        // minimal reward eligibility turnout threshold in BIPS (basis points)
        uint16 minRewardedTurnoutBIPS,
        // primary band reward share in PPM (parts per million)
        uint24 primaryBandRewardSharePPM,
        // secondary band width in PPM (parts per million) in relation to the median
        uint24 secondaryBandWidthPPM,
        // address that can claim undistributed part of the reward (or burn address)
        address claimBackAddress
    );

    /// Event emitted when inflation rewards are offered.
    event InflationRewardsOffered(
        // reward epoch id
        uint24 indexed rewardEpochId,
        // feed ids - i.e. category + base/quote symbols - multiple of 21 (one feedId is bytes21)
        bytes feedIds,
        // decimals encoded to - multiple of 1 (int8)
        bytes decimals,
        // amount (in wei) of reward in native coin
        uint256 amount,
        // minimal reward eligibility turnout threshold in BIPS (basis points)
        uint16 minRewardedTurnoutBIPS,
        // primary band reward share in PPM (parts per million)
        uint24 primaryBandRewardSharePPM,
        // secondary band width in PPM (parts per million) in relation to the median - multiple of 3 (uint24)
        bytes secondaryBandWidthPPMs,
        // rewards split mode (0 means equally, 1 means random,...)
        uint16 mode
    );

    /**
     * Allows community to offer rewards.
     * @param _nextRewardEpochId The next reward epoch id.
     * @param _offers The list of offers.
     */
    function offerRewards(
        uint24 _nextRewardEpochId,
        Offer[] calldata _offers
    )
        external payable;

    /**
     * Minimal rewards offer value (in wei).
     */
    function minimalRewardsOfferValueWei() external view returns(uint256);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IFtsoFeedDecimals.sol


pragma solidity >=0.7.6 <0.9;

/**
 * FtsoFeedDecimals interface.
 */
interface IFtsoFeedDecimals {

    /// Event emitted when a feed decimals value is changed.
    event DecimalsChanged(bytes21 indexed feedId, int8 decimals, uint24 rewardEpochId);

    /// The offset in reward epochs for the decimals value to become effective.
    function decimalsUpdateOffset() external view returns (uint24);

    /// The default decimals value.
    function defaultDecimals() external view returns (int8);

    /**
     * Returns current decimals set for `_feedId`.
     * @param _feedId Feed id.
     */
    function getCurrentDecimals(bytes21 _feedId) external view returns (int8);

    /**
     * Returns the decimals of `_feedId` for given reward epoch id.
     * @param _feedId Feed id.
     * @param _rewardEpochId Reward epoch id.
     * **NOTE:** decimals might still change for the `current + decimalsUpdateOffset` reward epoch id.
     */
    function getDecimals(
        bytes21 _feedId,
        uint256 _rewardEpochId
    )
        external view
        returns (int8);

    /**
     * Returns the scheduled decimals changes of `_feedId`.
     * @param _feedId Feed id.
     * @return _decimals Positional array of decimals.
     * @return _validFromEpochId Positional array of reward epoch ids the decimals settings are effective from.
     * @return _fixed Positional array of boolean values indicating if settings are subjected to change.
     */
    function getScheduledDecimalsChanges(
        bytes21 _feedId
    )
        external view
        returns (
            int8[] memory _decimals,
            uint256[] memory _validFromEpochId,
            bool[] memory _fixed
        );

    /**
     * Returns current decimals setting for `_feedIds`.
     * @param _feedIds Concatenated feed ids (each feedId bytes21).
     * @return _decimals Concatenated corresponding decimals (each as bytes1(uint8(int8))).
     */
    function getCurrentDecimalsBulk(
        bytes memory _feedIds
    )
        external view
        returns (bytes memory _decimals);

    /**
     * Returns decimals setting for `_feedIds` at `_rewardEpochId`.
     * @param _feedIds Concatenated feed ids (each feedId bytes21).
     * @param _rewardEpochId Reward epoch id.
     * @return _decimals Concatenated corresponding decimals (each as bytes1(uint8(int8))).
     * **NOTE:** decimals might still change for the `current + decimalsUpdateOffset` reward epoch id.
     */
    function getDecimalsBulk(
        bytes memory _feedIds,
        uint256 _rewardEpochId
    )
        external view
        returns (bytes memory _decimals);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IFtsoFeedPublisher.sol


pragma solidity >=0.7.6 <0.9;

/**
 * FtsoFeedPublisher interface.
 */
interface IFtsoFeedPublisher {

    /// The FTSO feed struct.
    struct Feed {
        uint32 votingRoundId;
        bytes21 id;
        int32 value;
        uint16 turnoutBIPS;
        int8 decimals;
    }

    /// The FTSO random struct.
    struct Random {
        uint32 votingRoundId;
        uint256 value;
        bool isSecure;
    }

    /// The FTSO feed with proof struct.
    struct FeedWithProof {
        bytes32[] merkleProof;
        Feed body;
    }

    /// Event emitted when a new feed is published.
    event FtsoFeedPublished(
        uint32 indexed votingRoundId,
        bytes21 indexed id,
        int32 value,
        uint16 turnoutBIPS,
        int8 decimals
    );

    /**
     * Publishes feeds.
     * @param _proofs The FTSO feeds with proofs to publish.
     */
    function publish(FeedWithProof[] calldata _proofs) external;

    /**
     *The FTSO protocol id.
     */
    function ftsoProtocolId() external view returns(uint8);

    /**
     * The size of the feeds history.
     */
    function feedsHistorySize() external view returns(uint256);

    /**
     * Returns the current feed.
     * @param _feedId Feed id.
     */
    function getCurrentFeed(bytes21 _feedId) external view returns(Feed memory);

    /**
     * Returns the feed for given voting round id.
     * @param _feedId Feed id.
     * @param _votingRoundId Voting round id.
     */
    function getFeed(bytes21 _feedId, uint256 _votingRoundId) external view returns(Feed memory);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IFtsoFeedIdConverter.sol


pragma solidity >=0.7.6 <0.9;

/**
 * IFtsoFeedIdConverter interface.
 */
interface IFtsoFeedIdConverter {

    /**
     * Returns the feed id for given category and name.
     * @param _category Feed category.
     * @param _name Feed name.
     * @return Feed id.
     */
    function getFeedId(uint8 _category, string memory _name) external view returns(bytes21);

    /**
     * Returns the feed category and name for given feed id.
     * @param _feedId Feed id.
     * @return _category Feed category.
     * @return _name Feed name.
     */
    function getFeedCategoryAndName(bytes21 _feedId) external pure returns(uint8 _category, string memory _name);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IFixedPointArithmetic.sol


pragma solidity >=0.7.6 <0.9;

/*
 * Opaque type synonyms to enforce arithemtic correctness.
 * All of these are internally uint256 to avert solc's restricted-bit-size internal handling.
 * Since the space is available, the fractional parts of all (except Price,
 * which is not controlled by us) are very wide.
 */

type Scale is uint256;      // 1x127
type Precision is uint256;  // 0x127; the fractional part of Scale, top bit always 0
type SampleSize is uint256; // 8x120; current gas usage and block gas limit force <32 update transactions per block
type Range is uint256;      // 8x120, with some space for >100% fluctuations
                            // (measured volatility per block is ~1e-3 at most)
type Fractional is uint256; // 0x128

type Fee is uint256;        // 128x0; same scale as currency units,restricted to bottom 128 bits
                            // (1e18 integer and fractional parts) to accommodate arithmetic

// File: @flarenetwork/flare-periphery-contracts/coston2/IFastUpdatesConfiguration.sol


pragma solidity >=0.7.6 <0.9;

/**
 * FastUpdatesConfiguration interface.
 */
interface IFastUpdatesConfiguration {

    /**
     * The feed configuration struct.
     */
    struct FeedConfiguration {
        // feed id
        bytes21 feedId;
        // reward band value (interpreted off-chain) in relation to the median
        uint32 rewardBandValue;
        // inflation share
        uint24 inflationShare;
    }

    /// Event emitted when a feed is added.
    event FeedAdded(bytes21 indexed feedId, uint32 rewardBandValue, uint24 inflationShare, uint256 index);
    /// Event emitted when a feed is updated.
    event FeedUpdated(bytes21 indexed feedId, uint32 rewardBandValue, uint24 inflationShare, uint256 index);
    /// Event emitted when a feed is removed.
    event FeedRemoved(bytes21 indexed feedId, uint256 index);

    /**
     * Returns the index of a feed.
     * @param _feedId The feed id.
     * @return _index The index of the feed.
     */
    function getFeedIndex(bytes21 _feedId) external view returns (uint256 _index);

    /**
     * Returns the feed id at a given index. Removed (unused) feed index will return bytes21(0).
     * @param _index The index.
     * @return _feedId The feed id.
     */
    function getFeedId(uint256 _index) external view returns (bytes21 _feedId);

    /**
     * Returns all feed ids. For removed (unused) feed indices, the feed id will be bytes21(0).
     */
    function getFeedIds() external view returns (bytes21[] memory);

    /**
     * Returns the number of feeds, including removed ones.
     */
    function getNumberOfFeeds() external view returns (uint256);

    /**
     * Returns the feed configurations, including removed ones.
     */
    function getFeedConfigurations() external view returns (FeedConfiguration[] memory);

    /**
     * Returns the unused indices - indices of removed feeds.
     */
    function getUnusedIndices() external view returns (uint256[] memory);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IIncreaseManager.sol


pragma solidity >=0.7.6 <0.9;

/**
 * Increase manager interface.
 */
interface IIncreaseManager {
    function getIncentiveDuration() external view returns (uint256);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IFastUpdateIncentiveManager.sol


pragma solidity >=0.7.6 <0.9;




/**
 * Fast update incentive manager interface.
 */
interface IFastUpdateIncentiveManager is IIncreaseManager {

    /// Incentive offer structure.
    struct IncentiveOffer {
        FPA.Range rangeIncrease;
        FPA.Range rangeLimit;
    }

    /// Event emitted when an incentive is offered.
    event IncentiveOffered(
        uint24 indexed rewardEpochId,
        FPA.Range rangeIncrease,
        FPA.SampleSize sampleSizeIncrease,
        FPA.Fee offerAmount
    );

    /// Event emitted when inflation rewards are offered.
    event InflationRewardsOffered(
        // reward epoch id
        uint24 indexed rewardEpochId,
        // feed configurations
        IFastUpdatesConfiguration.FeedConfiguration[] feedConfigurations,
        // amount (in wei) of reward in native coin
        uint256 amount
    );

    /**
     * The entry point for third parties to make incentive offers. It accepts a payment and, using the contents of
     * `_offer`, computes how much the expected sample size will be increased to apply the requested (but capped) range
     * increase. If the ultimate value of the range exceeds the cap, funds are returned to the sender in proportion to
     * the amount by which the increase is adjusted to reach the cap.
     * @param _offer The requested amount of per-block variation range increase,
     * along with a cap for the ultimate range.
     */
    function offerIncentive(IncentiveOffer calldata _offer) external payable;

    /// Viewer for the current value of the expected sample size.
    function getExpectedSampleSize() external view returns (FPA.SampleSize);

    /// Viewer for the current value of the unit delta's precision (the fractional part of the scale).
    function getPrecision() external view returns (FPA.Precision);

    /// Viewer for the current value of the per-block variation range.
    function getRange() external view returns (FPA.Range);

    /// Viewer for the current value of sample size increase price.
    function getCurrentSampleSizeIncreasePrice() external view returns (FPA.Fee);

    /// Viewer for the current value of the scale itself.
    function getScale() external view returns (FPA.Scale);

    /// Viewer for the base value of the scale itself.
    function getBaseScale() external view returns (FPA.Scale);

    /// The maximum amount by which the expected sample size can be increased by an incentive offer.
    /// This is controlled by governance and forces a minimum cost to increasing the sample size greatly,
    /// which would otherwise be an attack on the protocol.
    function sampleIncreaseLimit() external view returns (FPA.SampleSize);

    /// The maximum value that the range can be increased to by an incentive offer.
    function rangeIncreaseLimit() external view returns (FPA.Range);

    /// The price for increasing the per-block range of variation by 1, prorated for the actual amount of increase.
    function rangeIncreasePrice() external view returns (FPA.Fee);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IBn256.sol


pragma solidity >=0.7.6 <0.9;

// G1Point implements a point in G1 group.
struct G1Point {
  uint256 x;
  uint256 y;
}

// File: @flarenetwork/flare-periphery-contracts/coston2/ISortition.sol


pragma solidity >=0.7.6 <0.9;


struct SortitionCredential {
  uint256 replicate;
  G1Point gamma;
  uint256 c;
  uint256 s;
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IFastUpdater.sol


pragma solidity >=0.7.6 <0.9;


/**
 * Fast updater interface.
 */
interface IFastUpdater {

    /// Signature structure
    struct Signature {
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    /// Fast update structure
    struct FastUpdates {
        uint256 sortitionBlock;
        SortitionCredential sortitionCredential;
        bytes deltas;
        Signature signature;
    }

    /// Event emitted when a new set of updates is submitted.
    event FastUpdateFeedsSubmitted(
        uint32 indexed votingRoundId,
        address indexed signingPolicyAddress
    );

    /// Event emitted when a feed is added or reset.
    event FastUpdateFeedReset(
        uint256 indexed votingRoundId,
        uint256 indexed index,
        bytes21 indexed id,
        uint256 value,
        int8 decimals);

    /// Event emitted when a feed is removed.
    event FastUpdateFeedRemoved(
        uint256 indexed index);

    /// Event emitted at the start of a new voting epoch - current feeds' values and decimals.
    event FastUpdateFeeds(uint256 indexed votingEpochId, uint256[] feeds, int8[] decimals);

    /**
     * The entry point for providers to submit an update transaction.
     * @param _updates Data of an update transaction, which in addition to the actual list of updates,
     * includes the sortition credential proving the provider's eligibility to make updates in the also-included
     * sortition round, as well as a signature allowing a single registered provider to submit from multiple
     * EVM accounts.
     */
    function submitUpdates(FastUpdates calldata _updates) external;

    /**
     * Public access to the stored data of all feeds.
     * A fee (calculated by the FeeCalculator contract) may need to be paid.
     * **NOTE:** Overpayment is not refunded.
     * @return _feedIds The list of feed ids.
     * @return _feeds The list of feeds.
     * @return _decimals The list of decimal places for feeds.
     * @return _timestamp The timestamp of the last update.
     */
    function fetchAllCurrentFeeds()
        external payable
        returns (
            bytes21[] memory _feedIds,
            uint256[] memory _feeds,
            int8[] memory _decimals,
            uint64 _timestamp
        );

    /**
     * Public access to the stored data of each feed, allowing controlled batch access to the lengthy complete data.
     * Feeds should be sorted for better performance.
     * A fee (calculated by the FeeCalculator contract) may need to be paid.
     * **NOTE:** Overpayment is not refunded.
     * @param _indices Index numbers of the feeds for which data should be returned, corresponding to `feedIds` in
     * the `FastUpdatesConfiguration` contract.
     * @return _feeds The list of data for the requested feeds, in the same order as the feed indices were given
     * (which may not be their sorted order).
     * @return _decimals The list of decimal places for the requested feeds, in the same order as the feed indices were
     * given (which may not be their sorted order).
     * @return _timestamp The timestamp of the last update.
     */
    function fetchCurrentFeeds(
        uint256[] calldata _indices
    )
        external payable
        returns (
            uint256[] memory _feeds,
            int8[] memory _decimals,
            uint64 _timestamp
        );

    /**
     * Informational getter concerning the eligibility criterion for being chosen by sortition.
     * @return _cutoff The upper endpoint of the acceptable range of "scores" that providers generate for sortition.
     * A score below the cutoff indicates eligibility to submit updates in the present sortition round.
     */
    function currentScoreCutoff() external view returns (uint256 _cutoff);

    /**
     * Informational getter concerning the eligibility criterion for being chosen by sortition in a given block.
     * @param _blockNum The block for which the cutoff is requested.
     * @return _cutoff The upper endpoint of the acceptable range of "scores" that providers generate for sortition.
     * A score below the cutoff indicates eligibility to submit updates in the present sortition round.
     */
    function blockScoreCutoff(uint256 _blockNum) external view returns (uint256 _cutoff);

    /**
     * Informational getter concerning a provider's likelihood of being chosen by sortition.
     * @param _signingPolicyAddress The signing policy address of the specified provider. This is different from the
     * sender of an update transaction, due to the signature included in the `FastUpdates` type.
     * @return _weight The specified provider's weight for sortition purposes. This is derived from the provider's
     * delegation weight for the FTSO, but rescaled against a fixed number of "virtual providers", indicating how many
     * potential updates a single provider may make in a sortition round.
     */
    function currentSortitionWeight(address _signingPolicyAddress) external view returns (uint256 _weight);

    /**
     * The submission window is a number of blocks forming a "grace period" after a round of sortition starts,
     * during which providers may submit updates for that round. In other words, each block starts a new round of
     * sortition and that round lasts `submissionWindow` blocks.
     */
    function submissionWindow() external view returns (uint8);

    /**
     * Id of the current reward epoch.
     */
    function currentRewardEpochId() external view returns (uint24);

    /**
     * The number of updates submitted in each block for the last `_historySize` blocks (up to `MAX_BLOCKS_HISTORY`).
     * @param _historySize The number of blocks for which the number of updates should be returned.
     * @return _noOfUpdates The number of updates submitted in each block for the last `_historySize` blocks.
     * The array is ordered from the current block to the oldest block.
     */
    function numberOfUpdates(uint256 _historySize) external view returns (uint256[] memory _noOfUpdates);

    /**
     * The number of updates submitted in a block - available only for the last `MAX_BLOCKS_HISTORY` blocks.
     * @param _blockNumber The block number for which the number of updates should be returned.
     * @return _noOfUpdates The number of updates submitted in the specified block.
     */
    function numberOfUpdatesInBlock(uint256 _blockNumber) external view returns (uint256 _noOfUpdates);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IRNatAccount.sol


pragma solidity >=0.7.6 <0.9;



interface IRNatAccount {

    event FundsWithdrawn(uint256 amount, bool wrap);
    event LockedAmountBurned(uint256 amount);
    event ExternalTokenTransferred(IERC20 token, uint256 amount);
    event Initialized(address owner, IRNat rNat);
    event ClaimExecutorsSet(address[] executors);

    /**
     * Returns the owner of the contract.
     */
    function owner() external view returns (address);

    /**
     * Returns the `RNat` contract.
     */
    function rNat() external view returns (IRNat);

    /**
     * Returns the total amount of rewards received ever.
     */
    function receivedRewards() external view returns (uint128);

    /**
     * Returns the total amount of rewards withdrawn ever.
     */
    function withdrawnRewards() external view returns (uint128);
}

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol


// OpenZeppelin Contracts (last updated v5.1.0) (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.20;


/**
 * @dev Interface for the optional metadata functions from the ERC-20 standard.
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// File: @flarenetwork/flare-periphery-contracts/coston2/IRNat.sol


pragma solidity >=0.7.6 <0.9;




interface IRNat is IERC20Metadata {

    event RNatAccountCreated(address owner, IRNatAccount rNatAccount);
    event ProjectAdded(uint256 indexed id, string name, address distributor, bool currentMonthDistributionEnabled);
    event ProjectUpdated(uint256 indexed id, string name, address distributor, bool currentMonthDistributionEnabled);
    event RewardsAssigned(uint256 indexed projectId, uint256 indexed month, uint128 amount);
    event RewardsUnassigned(uint256 indexed projectId, uint256 indexed month, uint128 amount);
    event RewardsDistributed(
        uint256 indexed projectId,
        uint256 indexed month,
        address[] recipients,
        uint128[] amounts
    );
    event RewardsClaimed(uint256 indexed projectId, uint256 indexed month, address indexed owner, uint128 amount);
    event UnclaimedRewardsUnassigned(uint256 indexed projectId, uint256 indexed month, uint128 amount);
    event UnassignedRewardsWithdrawn(address recipient, uint128 amount);
    event DistributionPermissionUpdated(uint256[] projectIds, bool disabled);
    event ClaimingPermissionUpdated(uint256[] projectIds, bool disabled);

    /**
     * Distributes the rewards of a project for a given month to a list of recipients.
     * It must be called by the project's distributor.
     * It can only be called for the last or current month (if enabled).
     * @param _projectId The id of the project.
     * @param _month The month of the rewards.
     * @param _recipients The addresses of the recipients.
     * @param _amountsWei The amounts of rewards to distribute to each recipient (in wei).
     */
    function distributeRewards(
        uint256 _projectId,
        uint256 _month,
        address[] calldata _recipients,
        uint128[] calldata _amountsWei
    )
        external;

    /**
     * Claim rewards for a list of projects up to the given month.
     * @param _projectIds The ids of the projects.
     * @param _month The month up to which (including) rewards will be claimed.
     * @return _claimedRewardsWei The total amount of rewards claimed (in wei).
     */
    function claimRewards(
        uint256[] calldata _projectIds,
        uint256 _month
    )
        external
        returns (
            uint128 _claimedRewardsWei
        );

    /**
     * Sets the addresses of executors and adds the owner as an executor.
     *
     * If any of the executors is a registered executor, some fee needs to be paid.
     * @param _executors The new executors. All old executors will be deleted and replaced by these.
     */
    function setClaimExecutors(address[] calldata _executors) external payable;

    /**
     * Allows the caller to withdraw `WNat` wrapped tokens from their RNat account to the owner account.
     * In case there are some self-destruct native tokens left on the contract,
     * they can be transferred to the owner account using this method and `_wrap = false`.
     * @param _amount Amount of tokens to transfer (in wei).
     * @param _wrap If `true`, the tokens will be sent wrapped in `WNat`. If `false`, they will be sent as `Nat`.
     */
    function withdraw(uint128 _amount, bool _wrap) external;

    /**
     * Allows the caller to withdraw `WNat` wrapped tokens from their RNat account to the owner account.
     * If some tokens are still locked, only 50% of them will be withdrawn, the rest will be burned as a penalty.
     * In case there are some self-destruct native tokens left on the contract,
     * they can be transferred to the owner account using this method and `_wrap = false`.
     * @param _wrap If `true`, the tokens will be sent wrapped in `WNat`. If `false`, they will be sent as `Nat`.
     */
    function withdrawAll(bool _wrap) external;

    /**
     * Allows the caller to transfer ERC-20 tokens from their RNat account to the owner account.
     *
     * The main use case is to move ERC-20 tokes received by mistake (by an airdrop, for example) out of the
     * RNat account and move them into the main account, where they can be more easily managed.
     *
     * Reverts if the target token is the `WNat` contract: use method `withdraw` or `withdrawAll` for that.
     * @param _token Target token contract address.
     * @param _amount Amount of tokens to transfer.
     */
    function transferExternalToken(IERC20 _token, uint256 _amount) external;

    /**
     * Gets owner's RNat account. If it doesn't exist it reverts.
     * @param _owner Account to query.
     * @return Address of its RNat account.
     */
    function getRNatAccount(address _owner) external view returns (IRNatAccount);

    /**
     * Returns the timestamp of the start of the first month.
     */
    function firstMonthStartTs() external view returns (uint256);

    /**
     * Returns the `WNat` contract.
     */
    function wNat() external view returns(IWNat);

    /**
     * Gets the current month.
     * @return The current month.
     */
    function getCurrentMonth() external view returns (uint256);

    /**
     * Gets the total number of projects.
     * @return The total number of projects.
     */
    function getProjectsCount() external view returns (uint256);

    /**
     * Gets the basic information of all projects.
     * @return _names The names of the projects.
     * @return _claimingDisabled Whether claiming is disabled for each project.
     */
    function getProjectsBasicInfo() external view returns (string[] memory _names, bool[] memory _claimingDisabled);

    /**
     * Gets the information of a project.
     * @param _projectId The id of the project.
     * @return _name The name of the project.
     * @return _distributor The address of the distributor.
     * @return _currentMonthDistributionEnabled Whether distribution is enabled for the current month.
     * @return _distributionDisabled Whether distribution is disabled.
     * @return _claimingDisabled Whether claiming is disabled.
     * @return _totalAssignedRewards The total amount of rewards assigned to the project (in wei).
     * @return _totalDistributedRewards The total amount of rewards distributed by the project (in wei).
     * @return _totalClaimedRewards The total amount of rewards claimed from the project (in wei).
     * @return _totalUnassignedUnclaimedRewards The total amount of unassigned unclaimed rewards (in wei).
     * @return _monthsWithRewards The months with rewards.
     */
    function getProjectInfo(uint256 _projectId)
        external view
        returns (
            string memory _name,
            address _distributor,
            bool _currentMonthDistributionEnabled,
            bool _distributionDisabled,
            bool _claimingDisabled,
            uint128 _totalAssignedRewards,
            uint128 _totalDistributedRewards,
            uint128 _totalClaimedRewards,
            uint128 _totalUnassignedUnclaimedRewards,
            uint256[] memory _monthsWithRewards
        );

    /**
     * Gets the rewards information of a project for a given month.
     * @param _projectId The id of the project.
     * @param _month The month of the rewards.
     * @return _assignedRewards The amount of rewards assigned to the project for the month (in wei).
     * @return _distributedRewards The amount of rewards distributed by the project for the month (in wei).
     * @return _claimedRewards The amount of rewards claimed from the project for the month (in wei).
     * @return _unassignedUnclaimedRewards The amount of unassigned unclaimed rewards for the month (in wei).
     */
    function getProjectRewardsInfo(uint256 _projectId, uint256 _month)
        external view
        returns (
            uint128 _assignedRewards,
            uint128 _distributedRewards,
            uint128 _claimedRewards,
            uint128 _unassignedUnclaimedRewards
        );

    /**
     * Gets the rewards information of a project for a given month and owner.
     * @param _projectId The id of the project.
     * @param _month The month of the rewards.
     * @param _owner The address of the owner.
     * @return _assignedRewards The amount of rewards assigned to the owner for the month (in wei).
     * @return _claimedRewards The amount of rewards claimed by the owner for the month (in wei).
     * @return _claimable Whether the rewards are claimable by the owner.
     */
    function getOwnerRewardsInfo(uint256 _projectId, uint256 _month, address _owner)
        external view
        returns (
            uint128 _assignedRewards,
            uint128 _claimedRewards,
            bool _claimable
        );

    /**
     * Gets the claimable rewards of a project for a given owner.
     * @param _projectId The id of the project.
     * @param _owner The address of the owner.
     * @return The amount of rewards claimable by the owner (in wei).
     */
    function getClaimableRewards(uint256 _projectId, address _owner) external view returns (uint128);

    /**
     * Gets owner's balances of `WNat`, `RNat` and locked tokens.
     * @param _owner The address of the owner.
     * @return _wNatBalance The balance of `WNat` (in wei).
     * @return _rNatBalance The balance of `RNat` (in wei).
     * @return _lockedBalance The locked/vested balance (in wei).
     */
    function getBalancesOf(
        address _owner
    )
        external view
        returns (
            uint256 _wNatBalance,
            uint256 _rNatBalance,
            uint256 _lockedBalance
        );

    /**
     * Gets totals rewards information.
     * @return _totalAssignableRewards The total amount of assignable rewards (in wei).
     * @return _totalAssignedRewards The total amount of assigned rewards (in wei).
     * @return _totalClaimedRewards The total amount of claimed rewards (in wei).
     * @return _totalWithdrawnRewards The total amount of withdrawn rewards (in wei).
     * @return _totalWithdrawnAssignableRewards The total amount of withdrawn once assignable rewards (in wei).
     */
    function getRewardsInfo()
        external view
        returns (
            uint256 _totalAssignableRewards,
            uint256 _totalAssignedRewards,
            uint256 _totalClaimedRewards,
            uint256 _totalWithdrawnRewards,
            uint256 _totalWithdrawnAssignableRewards
        );
}
// File: @flarenetwork/flare-periphery-contracts/coston2/IFeeCalculator.sol


pragma solidity >=0.7.6 <0.9;


/**
 * FeeCalculator interface.
 */
interface IFeeCalculator {
    /**
     * Calculates a fee that needs to be paid to fetch feeds' data.
     * @param _feedIds List of feed ids.
    */
    function calculateFeeByIds(bytes21[] memory _feedIds) external view returns (uint256 _fee);

    /**
     * Calculates a fee that needs to be paid to fetch feeds' data.
     * @param _indices Indices of the feeds, corresponding to feed ids in
     * the FastUpdatesConfiguration contract.
    */
    function calculateFeeByIndices(uint256[] memory _indices) external view returns (uint256 _fee);
}


// File: @flarenetwork/flare-periphery-contracts/coston2/FtsoV2Interface.sol


pragma solidity >=0.7.6 <0.9;

/**
 * FtsoV2 long term support interface.
 */
interface FtsoV2Interface {

    /// Feed data structure
    struct FeedData {
        uint32 votingRoundId;
        bytes21 id;
        int32 value;
        uint16 turnoutBIPS;
        int8 decimals;
    }

    /// Feed data with proof structure
    struct FeedDataWithProof {
        bytes32[] proof;
        FeedData body;
    }

    /**
     * Returns stored data of a feed.
     * A fee (calculated by the FeeCalculator contract) may need to be paid.
     * @param _index The index of the feed, corresponding to feed id in
     * the FastUpdatesConfiguration contract.
     * @return _value The value for the requested feed.
     * @return _decimals The decimal places for the requested feed.
     * @return _timestamp The timestamp of the last update.
     */
    function getFeedByIndex(uint256 _index)
        external payable
        returns (
            uint256 _value,
            int8 _decimals,
            uint64 _timestamp
        );

    /**
     * Returns stored data of a feed.
     * A fee (calculated by the FeeCalculator contract) may need to be paid.
     * @param _feedId The id of the feed.
     * @return _value The value for the requested feed.
     * @return _decimals The decimal places for the requested feed.
     * @return _timestamp The timestamp of the last update.
     */
    function getFeedById(bytes21 _feedId)
        external payable
        returns (
            uint256 _value,
            int8 _decimals,
            uint64 _timestamp
        );

    /**
     * Returns stored data of each feed.
     * A fee (calculated by the FeeCalculator contract) may need to be paid.
     * @param _indices Indices of the feeds, corresponding to feed ids in
     * the FastUpdatesConfiguration contract.
     * @return _values The list of values for the requested feeds.
     * @return _decimals The list of decimal places for the requested feeds.
     * @return _timestamp The timestamp of the last update.
     */
    function getFeedsByIndex(uint256[] calldata _indices)
        external payable
        returns (
            uint256[] memory _values,
            int8[] memory _decimals,
            uint64 _timestamp
        );

    /**
     * Returns stored data of each feed.
     * A fee (calculated by the FeeCalculator contract) may need to be paid.
     * @param _feedIds The list of feed ids.
     * @return _values The list of values for the requested feeds.
     * @return _decimals The list of decimal places for the requested feeds.
     * @return _timestamp The timestamp of the last update.
     */
    function getFeedsById(bytes21[] calldata _feedIds)
        external payable
        returns (
            uint256[] memory _values,
            int8[] memory _decimals,
            uint64 _timestamp
        );

    /**
     * Returns value in wei and timestamp of a feed.
     * A fee (calculated by the FeeCalculator contract) may need to be paid.
     * @param _index The index of the feed, corresponding to feed id in
     * the FastUpdatesConfiguration contract.
     * @return _value The value for the requested feed in wei (i.e. with 18 decimal places).
     * @return _timestamp The timestamp of the last update.
     */
    function getFeedByIndexInWei(
        uint256 _index
    )
        external payable
        returns (
            uint256 _value,
            uint64 _timestamp
        );

    /**
     * Returns value in wei and timestamp of a feed.
     * A fee (calculated by the FeeCalculator contract) may need to be paid.
     * @param _feedId The id of the feed.
     * @return _value The value for the requested feed in wei (i.e. with 18 decimal places).
     * @return _timestamp The timestamp of the last update.
     */
    function getFeedByIdInWei(bytes21 _feedId)
        external payable
        returns (
            uint256 _value,
            uint64 _timestamp
        );

    /** Returns value in wei of each feed and a timestamp.
     * For some feeds, a fee (calculated by the FeeCalculator contract) may need to be paid.
     * @param _indices Indices of the feeds, corresponding to feed ids in
     * the FastUpdatesConfiguration contract.
     * @return _values The list of values for the requested feeds in wei (i.e. with 18 decimal places).
     * @return _timestamp The timestamp of the last update.
     */
    function getFeedsByIndexInWei(uint256[] calldata _indices)
        external payable
        returns (
            uint256[] memory _values,
            uint64 _timestamp
        );

    /** Returns value of each feed and a timestamp.
     * For some feeds, a fee (calculated by the FeeCalculator contract) may need to be paid.
     * @param _feedIds Ids of the feeds.
     * @return _values The list of values for the requested feeds in wei (i.e. with 18 decimal places).
     * @return _timestamp The timestamp of the last update.
     */
    function getFeedsByIdInWei(bytes21[] calldata _feedIds)
        external payable
        returns (
            uint256[] memory _values,
            uint64 _timestamp
        );

    /**
     * Returns the index of a feed.
     * @param _feedId The feed id.
     * @return _index The index of the feed.
     */
    function getFeedIndex(bytes21 _feedId) external view returns (uint256 _index);

    /**
     * Returns the feed id at a given index. Removed (unused) feed index will return bytes21(0).
     * @param _index The index.
     * @return _feedId The feed id.
     */
    function getFeedId(uint256 _index) external view returns (bytes21 _feedId);

    /**
     * Checks if the feed data is valid (i.e. is part of the confirmed Merkle tree).
     * @param _feedData Structure containing data about the feed (FeedData structure) and Merkle proof.
     * @return true if the feed data is valid.
     */
    function verifyFeedData(FeedDataWithProof calldata _feedData) external view returns (bool);
}
// File: @flarenetwork/flare-periphery-contracts/coston2/TestFtsoV2Interface.sol


pragma solidity >=0.7.6 <0.9;

/**
 * FtsoV2 long term support interface.
 */
interface TestFtsoV2Interface {

    /// Feed data structure
    struct FeedData {
        uint32 votingRoundId;
        bytes21 id;
        int32 value;
        uint16 turnoutBIPS;
        int8 decimals;
    }

    /// Feed data with proof structure
    struct FeedDataWithProof {
        bytes32[] proof;
        FeedData body;
    }

    /**
     * Returns stored data of a feed.
     * A fee (calculated by the FeeCalculator contract) may need to be paid.
     * @param _index The index of the feed, corresponding to feed id in
     * the FastUpdatesConfiguration contract.
     * @return _value The value for the requested feed.
     * @return _decimals The decimal places for the requested feed.
     * @return _timestamp The timestamp of the last update.
     */
    function getFeedByIndex(uint256 _index)
        external view
        returns (
            uint256 _value,
            int8 _decimals,
            uint64 _timestamp
        );

    /**
     * Returns stored data of a feed.
     * A fee (calculated by the FeeCalculator contract) may need to be paid.
     * @param _feedId The id of the feed.
     * @return _value The value for the requested feed.
     * @return _decimals The decimal places for the requested feed.
     * @return _timestamp The timestamp of the last update.
     */
    function getFeedById(bytes21 _feedId)
        external view
        returns (
            uint256 _value,
            int8 _decimals,
            uint64 _timestamp
        );

    /**
     * Returns stored data of each feed.
     * A fee (calculated by the FeeCalculator contract) may need to be paid.
     * @param _indices Indices of the feeds, corresponding to feed ids in
     * the FastUpdatesConfiguration contract.
     * @return _values The list of values for the requested feeds.
     * @return _decimals The list of decimal places for the requested feeds.
     * @return _timestamp The timestamp of the last update.
     */
    function getFeedsByIndex(uint256[] calldata _indices)
        external view
        returns (
            uint256[] memory _values,
            int8[] memory _decimals,
            uint64 _timestamp
        );

    /**
     * Returns stored data of each feed.
     * A fee (calculated by the FeeCalculator contract) may need to be paid.
     * @param _feedIds The list of feed ids.
     * @return _values The list of values for the requested feeds.
     * @return _decimals The list of decimal places for the requested feeds.
     * @return _timestamp The timestamp of the last update.
     */
    function getFeedsById(bytes21[] calldata _feedIds)
        external view
        returns (
            uint256[] memory _values,
            int8[] memory _decimals,
            uint64 _timestamp
        );

    /**
     * Returns value in wei and timestamp of a feed.
     * A fee (calculated by the FeeCalculator contract) may need to be paid.
     * @param _index The index of the feed, corresponding to feed id in
     * the FastUpdatesConfiguration contract.
     * @return _value The value for the requested feed in wei (i.e. with 18 decimal places).
     * @return _timestamp The timestamp of the last update.
     */
    function getFeedByIndexInWei(
        uint256 _index
    )
        external view
        returns (
            uint256 _value,
            uint64 _timestamp
        );

    /**
     * Returns value in wei and timestamp of a feed.
     * A fee (calculated by the FeeCalculator contract) may need to be paid.
     * @param _feedId The id of the feed.
     * @return _value The value for the requested feed in wei (i.e. with 18 decimal places).
     * @return _timestamp The timestamp of the last update.
     */
    function getFeedByIdInWei(bytes21 _feedId)
        external view
        returns (
            uint256 _value,
            uint64 _timestamp
        );

    /** Returns value in wei of each feed and a timestamp.
     * For some feeds, a fee (calculated by the FeeCalculator contract) may need to be paid.
     * @param _indices Indices of the feeds, corresponding to feed ids in
     * the FastUpdatesConfiguration contract.
     * @return _values The list of values for the requested feeds in wei (i.e. with 18 decimal places).
     * @return _timestamp The timestamp of the last update.
     */
    function getFeedsByIndexInWei(uint256[] calldata _indices)
        external view
        returns (
            uint256[] memory _values,
            uint64 _timestamp
        );

    /** Returns value of each feed and a timestamp.
     * For some feeds, a fee (calculated by the FeeCalculator contract) may need to be paid.
     * @param _feedIds Ids of the feeds.
     * @return _values The list of values for the requested feeds in wei (i.e. with 18 decimal places).
     * @return _timestamp The timestamp of the last update.
     */
    function getFeedsByIdInWei(bytes21[] calldata _feedIds)
        external view
        returns (
            uint256[] memory _values,
            uint64 _timestamp
        );

    /**
     * Returns the index of a feed.
     * @param _feedId The feed id.
     * @return _index The index of the feed.
     */
    function getFeedIndex(bytes21 _feedId) external view returns (uint256 _index);

    /**
     * Returns the feed id at a given index. Removed (unused) feed index will return bytes21(0).
     * @param _index The index.
     * @return _feedId The feed id.
     */
    function getFeedId(uint256 _index) external view returns (bytes21 _feedId);

    /**
     * Checks if the feed data is valid (i.e. is part of the confirmed Merkle tree).
     * @param _feedData Structure containing data about the feed (FeedData structure) and Merkle proof.
     * @return true if the feed data is valid.
     */
    function verifyFeedData(FeedDataWithProof calldata _feedData) external view returns (bool);
}
// File: @flarenetwork/flare-periphery-contracts/coston2/ContractRegistry.sol


pragma solidity ^0.8.0;


// Auto generated imports
// AUTO GENERATED - DO NOT EDIT BELOW THIS LINE










































// END AUTO GENERATED - DO NOT EDIT ABOVE THIS LINE

// Library is intended to be used inline, so the strings are all memory allocated (instead of calldata)
library ContractRegistry {
    address internal constant FLARE_CONTRACT_REGISTRY_ADDRESS =
        0xaD67FE66660Fb8dFE9d6b1b4240d8650e30F6019;

    IFlareContractRegistry internal constant FLARE_CONTRACT_REGISTRY =
        IFlareContractRegistry(FLARE_CONTRACT_REGISTRY_ADDRESS);

    /**
     * @notice Returns contract address for the given name - might be address(0)
     * @param _name             name of the contract
     */
    function getContractAddressByName(
        string memory _name
    ) internal view returns (address) {
        return FLARE_CONTRACT_REGISTRY.getContractAddressByName(_name);
    }

    /**
     * @notice Returns contract address for the given name hash - might be address(0)
     * @param _nameHash         hash of the contract name (keccak256(abi.encode(name))
     */
    function getContractAddressByHash(
        bytes32 _nameHash
    ) internal view returns (address) {
        return FLARE_CONTRACT_REGISTRY.getContractAddressByHash(_nameHash);
    }

    /**
     * @notice Returns contract addresses for the given names - might be address(0)
     * @param _names            names of the contracts
     */
    function getContractAddressesByName(
        string[] memory _names
    ) internal view returns (address[] memory) {
        return FLARE_CONTRACT_REGISTRY.getContractAddressesByName(_names);
    }

    /**
     * @notice Returns contract addresses for the given name hashes - might be address(0)
     * @param _nameHashes       hashes of the contract names (keccak256(abi.encode(name))
     */
    function getContractAddressesByHash(
        bytes32[] memory _nameHashes
    ) internal view returns (address[] memory) {
        return FLARE_CONTRACT_REGISTRY.getContractAddressesByHash(_nameHashes);
    }

    /**
     * @notice Returns all contract names and corresponding addresses
     */
    function getAllContracts()
        internal
        view
        returns (string[] memory _names, address[] memory _addresses)
    {
        return FLARE_CONTRACT_REGISTRY.getAllContracts();
    }

    // Nice typed getters for all the important contracts
    // AUTO GENERATED - DO NOT EDIT BELOW THIS LINE
    function getPriceSubmitter() internal view returns (IPriceSubmitter) {
        return
            IPriceSubmitter(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("PriceSubmitter"))
                )
            );
    }

    function getGovernanceSettings()
        internal
        view
        returns (IGovernanceSettings)
    {
        return
            IGovernanceSettings(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("GovernanceSettings"))
                )
            );
    }

    function getFtsoRewardManager() internal view returns (IFtsoRewardManager) {
        return
            IFtsoRewardManager(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("FtsoRewardManager"))
                )
            );
    }

    function getFtsoRegistry() internal view returns (IFtsoRegistry) {
        return
            IFtsoRegistry(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("FtsoRegistry"))
                )
            );
    }

    function getVoterWhitelister() internal view returns (IVoterWhitelister) {
        return
            IVoterWhitelister(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("VoterWhitelister"))
                )
            );
    }

    function getDistributionToDelegators()
        internal
        view
        returns (IDistributionToDelegators)
    {
        return
            IDistributionToDelegators(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("DistributionToDelegators"))
                )
            );
    }

    function getFtsoManager() internal view returns (IFtsoManager) {
        return
            IFtsoManager(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("FtsoManager"))
                )
            );
    }

    function getWNat() internal view returns (IWNat) {
        return
            IWNat(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("WNat"))
                )
            );
    }

    function getGovernanceVotePower()
        internal
        view
        returns (IGovernanceVotePower)
    {
        return
            IGovernanceVotePower(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("GovernanceVotePower"))
                )
            );
    }

    function getClaimSetupManager() internal view returns (IClaimSetupManager) {
        return
            IClaimSetupManager(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("ClaimSetupManager"))
                )
            );
    }

    function getValidatorRewardManager()
        internal
        view
        returns (IGenericRewardManager)
    {
        return
            IGenericRewardManager(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("ValidatorRewardManager"))
                )
            );
    }

    function getFlareAssetRegistry()
        internal
        view
        returns (IFlareAssetRegistry)
    {
        return
            IFlareAssetRegistry(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("FlareAssetRegistry"))
                )
            );
    }

    function getValidatorRegistry() internal view returns (IValidatorRegistry) {
        return
            IValidatorRegistry(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("ValidatorRegistry"))
                )
            );
    }

    function getFlareContractRegistry()
        internal
        view
        returns (IFlareContractRegistry)
    {
        return
            IFlareContractRegistry(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("FlareContractRegistry"))
                )
            );
    }

    function getPollingFtso() internal view returns (IPollingFtso) {
        return
            IPollingFtso(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("PollingFtso"))
                )
            );
    }

    function getAddressBinder() internal view returns (IAddressBinder) {
        return
            IAddressBinder(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("AddressBinder"))
                )
            );
    }

    function getPChainStakeMirror() internal view returns (IPChainStakeMirror) {
        return
            IPChainStakeMirror(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("PChainStakeMirror"))
                )
            );
    }

    function getPChainStakeMirrorVerifier()
        internal
        view
        returns (IPChainStakeMirrorVerifier)
    {
        return
            IPChainStakeMirrorVerifier(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("PChainStakeMirrorVerifier"))
                )
            );
    }

    function getPChainStakeMirrorMultiSigVoting()
        internal
        view
        returns (IPChainStakeMirrorMultiSigVoting)
    {
        return
            IPChainStakeMirrorMultiSigVoting(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("PChainStakeMirrorMultiSigVoting"))
                )
            );
    }

    function getSubmission() internal view returns (ISubmission) {
        return
            ISubmission(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("Submission"))
                )
            );
    }

    function getEntityManager() internal view returns (IEntityManager) {
        return
            IEntityManager(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("EntityManager"))
                )
            );
    }

    function getVoterRegistry() internal view returns (IVoterRegistry) {
        return
            IVoterRegistry(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("VoterRegistry"))
                )
            );
    }

    function getFlareSystemsCalculator()
        internal
        view
        returns (IFlareSystemsCalculator)
    {
        return
            IFlareSystemsCalculator(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("FlareSystemsCalculator"))
                )
            );
    }

    function getFlareSystemsManager()
        internal
        view
        returns (IFlareSystemsManager)
    {
        return
            IFlareSystemsManager(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("FlareSystemsManager"))
                )
            );
    }

    function getRewardManager() internal view returns (IRewardManager) {
        return
            IRewardManager(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("RewardManager"))
                )
            );
    }

    function getRelay() internal view returns (IRelay) {
        return
            IRelay(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("Relay"))
                )
            );
    }

    function getWNatDelegationFee() internal view returns (IWNatDelegationFee) {
        return
            IWNatDelegationFee(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("WNatDelegationFee"))
                )
            );
    }

    function getFtsoInflationConfigurations()
        internal
        view
        returns (IFtsoInflationConfigurations)
    {
        return
            IFtsoInflationConfigurations(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("FtsoInflationConfigurations"))
                )
            );
    }

    function getFtsoRewardOffersManager()
        internal
        view
        returns (IFtsoRewardOffersManager)
    {
        return
            IFtsoRewardOffersManager(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("FtsoRewardOffersManager"))
                )
            );
    }

    function getFtsoFeedDecimals() internal view returns (IFtsoFeedDecimals) {
        return
            IFtsoFeedDecimals(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("FtsoFeedDecimals"))
                )
            );
    }

    function getFtsoFeedPublisher() internal view returns (IFtsoFeedPublisher) {
        return
            IFtsoFeedPublisher(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("FtsoFeedPublisher"))
                )
            );
    }

    function getFtsoFeedIdConverter()
        internal
        view
        returns (IFtsoFeedIdConverter)
    {
        return
            IFtsoFeedIdConverter(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("FtsoFeedIdConverter"))
                )
            );
    }

    function getFastUpdateIncentiveManager()
        internal
        view
        returns (IFastUpdateIncentiveManager)
    {
        return
            IFastUpdateIncentiveManager(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("FastUpdateIncentiveManager"))
                )
            );
    }

    function getFastUpdater() internal view returns (IFastUpdater) {
        return
            IFastUpdater(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("FastUpdater"))
                )
            );
    }

    function getFastUpdatesConfiguration()
        internal
        view
        returns (IFastUpdatesConfiguration)
    {
        return
            IFastUpdatesConfiguration(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("FastUpdatesConfiguration"))
                )
            );
    }

    function getRNat() internal view returns (IRNat) {
        return
            IRNat(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("RNat"))
                )
            );
    }

    function getFeeCalculator() internal view returns (IFeeCalculator) {
        return
            IFeeCalculator(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("FeeCalculator"))
                )
            );
    }

    function getFtsoV2() internal view returns (FtsoV2Interface) {
        return
            FtsoV2Interface(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("FtsoV2"))
                )
            );
    }

    function getTestFtsoV2() internal view returns (TestFtsoV2Interface) {
        return
            TestFtsoV2Interface(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("FtsoV2"))
                )
            );
    }

    function getProtocolsV2() internal view returns (ProtocolsV2Interface) {
        return
            ProtocolsV2Interface(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("ProtocolsV2"))
                )
            );
    }

    function getRandomNumberV2()
        internal
        view
        returns (RandomNumberV2Interface)
    {
        return
            RandomNumberV2Interface(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("RandomNumberV2"))
                )
            );
    }

    function getRewardsV2() internal view returns (RewardsV2Interface) {
        return
            RewardsV2Interface(
                FLARE_CONTRACT_REGISTRY.getContractAddressByHash(
                    keccak256(abi.encode("RewardsV2"))
                )
            );
    }

    // END AUTO GENERATED - DO NOT EDIT ABOVE THIS LINE
}

// File: contracts/BtcPriceOracle.sol


pragma solidity >=0.8.0 <0.9.0;

/* THIS IS A TEST IMPORT, in production use: import {FtsoV2Interface} from "@flarenetwork/flare-periphery-contracts/coston2/FtsoV2Interface.sol"; */


/**
 * THIS IS AN EXAMPLE CONTRACT.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */
contract FtsoV2FeedConsumer {
    TestFtsoV2Interface internal ftsoV2;
    // Feed IDs, see https://dev.flare.network/ftso/feeds for full list
    bytes21[] public feedIds = [
        bytes21(0x014254432f55534400000000000000000000000000), // BTC/USD
        bytes21(0x01555344542f555344000000000000000000000000), // USDT/USD
        bytes21(0x014554482f55534400000000000000000000000000), // ETH/USD
        bytes21(0x01534f4c2f55534400000000000000000000000000) //SOL/USD
    ];

    /**
     * Constructor initializes the FTSOv2 contract.
     * The contract registry is used to fetch the FtsoV2 contract address.
     */
    constructor() {
        ftsoV2 = ContractRegistry.getTestFtsoV2();
    }

    /**
     * Get the current value of the feeds.
     */
    function getFtsoV2CurrentFeedValues()
        external
        view
        returns (
            uint256[] memory _feedValues,
            int8[] memory _decimals,
            uint64 _timestamp
        )
    {
        return ftsoV2.getFeedsById(feedIds);
    }

    /**
     * Get the value of a specific feed by name (e.g., "BTC", "ETH").
     */
    function getFeedValueByName(string memory feedName)
        external
        view
        returns (
            uint256 feedValue,
            int8 decimals,
            uint64 timestamp
        )
    {
        (uint256[] memory feedValues, int8[] memory decimalsArray, uint64 fetchedTimestamp) = ftsoV2.getFeedsById(feedIds);

        if (keccak256(abi.encodePacked(feedName)) == keccak256(abi.encodePacked("BTC"))) {
            return (feedValues[0], decimalsArray[0], fetchedTimestamp);
        } else if (keccak256(abi.encodePacked(feedName)) == keccak256(abi.encodePacked("USDT"))) {
            return (feedValues[1], decimalsArray[1], fetchedTimestamp);
        } else if (keccak256(abi.encodePacked(feedName)) == keccak256(abi.encodePacked("ETH"))) {
            return (feedValues[2], decimalsArray[2], fetchedTimestamp);
        } else if (keccak256(abi.encodePacked(feedName)) == keccak256(abi.encodePacked("SOL"))) {
            return (feedValues[3], decimalsArray[3], fetchedTimestamp);
        } else {
            revert("Invalid feed name");
        }
    }

    /**
     * Get the value of a specific feed by feed ID.
     */
    function getFeedValueById(bytes21 feedId)
        internal
        view
        returns (
            uint256 feedValue,
            int8 decimals,
            uint64 timestamp
        )
    {
        (uint256[] memory feedValues, int8[] memory decimalsArray, uint64 fetchedTimestamp) = ftsoV2.getFeedsById(feedIds);

        if (feedId == feedIds[0]) {
            return (feedValues[0], decimalsArray[0], fetchedTimestamp);
        } else if (feedId == feedIds[1]) {
            return (feedValues[1], decimalsArray[1], fetchedTimestamp);
        } else if (feedId == feedIds[2]) {
            return (feedValues[2], decimalsArray[2], fetchedTimestamp);
        } else if (feedId == feedIds[3]) {
            return (feedValues[3], decimalsArray[3], fetchedTimestamp);    
        } else {
            revert("Invalid feed ID");
        }
    }

    function fetchOutcome(uint256 price) external view returns (bool) {
        (
            uint256 feedValue,
            int8 decimals,
            uint64 timestamp
        ) = getFeedValueById(bytes21(0x014254432f55534400000000000000000000000000));


        if (feedValue >= price) {
            return true;
        }

        return false;
    }
}
