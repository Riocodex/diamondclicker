// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract CookieClickerGame {
    address public owner;
    uint256 public totalDiamonds;
    uint256 public autoMinerRate;
    uint256 public upgradeCost;
    mapping(address => uint256) public playerDiamonds;//mapping to store diamonds
    mapping(address => uint256) public lastClaimTime;//mapping to store time 
    mapping(address => uint256) public autoMinerLevels; // Mapping to store users and their autominer levels

    constructor() {
        owner = msg.sender;
        totalDiamonds = 0;//total diamonds mined in this contract
        autoMinerRate = 1; // Diamonds mined per click
        upgradeCost = 50; // Cost to purchase an upgrade
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier hasAutoMiner() {
        require(autoMinerLevels[msg.sender] > 0, "You didn't buy an auto-miner, can't use it");
        _;
    }

    function click() external {
        // Mining a diamond by clicking
        playerDiamonds[msg.sender] += autoMinerRate;
        totalDiamonds += autoMinerRate;
        lastClaimTime[msg.sender] = block.timestamp;
    }

    function claim() external hasAutoMiner {
        // Claim all auto-mined diamonds
        uint256 timeSinceLastClaim = block.timestamp - lastClaimTime[msg.sender];
        uint256 diamondsEarned = autoMinerRate * timeSinceLastClaim * autoMinerLevels[msg.sender];
        playerDiamonds[msg.sender] += diamondsEarned;
        totalDiamonds += diamondsEarned;
        lastClaimTime[msg.sender] = block.timestamp;
    }

    function upgrade(uint256 upgradeAmount) external {
        // Purchase upgrades for auto-miners
        uint256 upgradeCostTotal = upgradeCost * upgradeAmount;
        require(playerDiamonds[msg.sender] >= upgradeCostTotal, "Insufficient diamonds");
        require(autoMinerLevels[msg.sender] + upgradeAmount <= 10, "Max auto-miner level reached");

        autoMinerLevels[msg.sender] += upgradeAmount;
        autoMinerRate += 60 * upgradeAmount;
        playerDiamonds[msg.sender] -= upgradeCostTotal;
    }

    
}
