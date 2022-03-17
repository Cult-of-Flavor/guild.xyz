// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


// meant to be inherited by other contracts that want staking capabilities
contract Stakeable {
    // this contract is not meant to be used without inheritance
    constructor () {
        // This push is needed so we avoid index 0 causing bug of index-1
        stakeholders.push();
    }

    // This struct represents the way we store stakes, address, amount staked, and when staked.
    struct Stake {
        address user;
        uint256 amount;
        uint256 since;
        uint256 claimable;
    }

    // A staker who has active stakes
    struct Stakeholder{
        address user;
        Stake[] address_stakes;
     }

     /**
     * @notice
     * StakingSummary is a struct that is used to contain all stakes performed by a certain account
     */ 
    struct StakingSummary{
        uint256 total_amount;
        Stake[] stakes;
    }

    // This is where all Stakes will be stored on the contract, stored at certain indexes
    Stakeholder[] internal stakeholders; 

    // keeping track of the indexes here
    mapping(address => uint256) internal stakes;


    // Staked event is triggered whenever a user stakes tokens, address is indexed
    event Staked(address indexed user, uint256 amount, uint256 timestamp);

    uint256 internal rewardPerHour = 1000;

    // adding a stakeholder to the stakeholders array
    function _addStakeholder(address staker) internal returns (uint256) {
        //  push a empty item to the Array to make space for our new stakeholder
        stakeholders.push();
        // calculating the index of the last item in the array by len-1
        uint256 userIndex = stakeholders.length - 1;
        // assign the address to the new index;
        stakeholders[userIndex].user = staker;
        // Add index to the stakeHolders
        stakes[staker] = userIndex;
        return userIndex;
    }

    // _stake is used to make a stake for a sender. it will remove the amount staked from the stakers account and place those tokens inside a stake container
    function _stake(uint256 _amount) internal{
        // this is the check the user does not stake 0
        require(_amount > 0, "Cannot stake nothing");

        // Mappings in solidity creates all values, but empty, so we can just check the address
        uint256 index = stakes[msg.sender];
        // block.timestamp = timestamp of the current block in seconds since the epoch
        uint256 timestamp = block.timestamp;

        // see if the staker already has an existing index, or its their first time
        if(index == 0) {
            // this stakeholder stakes for the first timestamp, therefore add stake holder and return index of the new stakeholder
            index = _addStakeholder(msg.sender);
        }

        // Use the index to push a new Staked
        // push a newly created Stake with the current block timestamp.
        stakeholders[index].address_stakes.push(Stake(msg.sender, _amount, timestamp, 0));

        // emit an event that the stake has occured
        emit Staked(msg.sender, _amount, timestamp);

    }

    // used to calculate how much a user should be rewarded for their stakes and the duration their stakes has been active
    function calculateStakeReward(Stake memory _current_stake) internal view returns(uint256){
    // first calculate how long the stake has been active
    // use current seconds since epoch- the seconds since epoch the stake was made
    // The output will be duration in SECONDS, 
    // hours = seconds / 3600
    // multiply each token by the hours staked, then divide by the reward per hour rate
        return (((block.timestamp - _current_stake.since) / 1 hours) * _current_stake.amount) / rewardPerHour;
    } 

    // takes in an amount and an index of the stake and will remove tokens from that stake,
    function _withdrawStake(uint256 amount, uint256 index) internal returns(uint256) {
        // Grab user_index which is the index to use to grab the Stake[]     
        uint256 user_index = stakes[msg.sender];
        Stake memory current_stake = stakeholders[user_index].address_stakes[index];
        require(current_stake.amount >= amount, "Staking: Cannot withdraw more than you have staked");

        // calculate available reward first before we start modifying data
        uint256 reward = calculateStakeReward(current_stake);
        // remove by subtracting the money unstaked
        current_stake.amount = current_stake.amount - amount;
        // if stake is empty, 0, then remove it from the array of stakes
        if(current_stake.amount == 0){
            delete stakeholders[user_index].address_stakes[index];
        } else {
            // if not empty then replace the value of it
            stakeholders[user_index].address_stakes[index].amount = current_stake.amount - reward;
            // reset timer of stake
            stakeholders[user_index].address_stakes[index].since = block.timestamp;
        }
        return amount + reward;
    }

    //  hasStake is used to check if an account has stakes and the total amount along with separate stakes
    function hasStake(address _staker) public view returns(StakingSummary memory){
        // totalStakeAmount is used to count total staked amount of the address
        uint256 totalStakeAmount;
        // Keep a summary in memory since we need to calculate this
        StakingSummary memory summary = StakingSummary(0, stakeholders[stakes[_staker]].address_stakes);

        // Iterate all stakes and grab amount of stakes
        for(uint256 s = 0; s < summary.stakes.length; s += 1) {
            uint256 availableReward = calculateStakeReward(summary.stakes[s]);
            summary.stakes[s].claimable = availableReward;
            totalStakeAmount = totalStakeAmount+summary.stakes[s].amount;
        }

        // Assign calculated amount to summary
        summary.total_amount = totalStakeAmount;
        return summary;

    }

}