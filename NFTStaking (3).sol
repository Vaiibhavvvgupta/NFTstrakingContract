// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}

contract NFTStraking {
    IERC20 public usdtToken;

    mapping(address => uint256) public lastUpdateTime;
    mapping(address => uint256) public mintingTokens;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => uint256) balances;
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Staked(address indexed user, uint256 amount);
    event claim_(address indexed user, uint256 amount, uint256 rewards);
    event Transfer(address indexed from, address indexed to, uint256 value);

    uint256 public StratToken = 0;
    uint256 public dailyRewardPercentage = 50;
    // address private volt1 = 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e;
    // address private volt2 = 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e;

    address private ownner_;



    struct CustomerRecord {
    uint256 totalVotes;
    uint256 TotalNFTStaking;
    uint256 totalPoints;
    mapping(uint256 => bool) votedTopics;
}
mapping(address => CustomerRecord) public customerRecords;
event Voted(address indexed voter, uint256 topicId, bool vote);
// uint256 public maxTopicId; 



  struct VoteRecord {
        uint256 startDate;
        uint256 endDate;
        uint256 totalYes;
        uint256 totalNo;
        bool finish;
    }

    mapping(uint256 => VoteRecord) public voteRecords;

    constructor(address _usdtToken) {
        usdtToken = IERC20(_usdtToken);
        balances[msg.sender] = StratToken;
        ownner_ = msg.sender;
    }

    function Owner() internal view returns (address) {
        return ownner_;
    }

    function totalSupply() public pure returns (uint256) {
        return 300_000_000 * 10**18;
    }

    function balanceof(address owner) public view returns (uint256) {
        return balances[owner];
    }

    function approve(address _spender, uint256 _value) external returns (bool) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool) {
        require(balances[_from] >= _value, "Insufficient balance");
        require(
            allowance[_from][msg.sender] >= _value,
            "Not allowed to transfer"
        );
        balances[_from] -= _value;
        balances[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function BuyNFT(uint256 _amount) external {
        require(_amount % 100 == 0, "amount should be multiple of 100");
        require(_amount > 0, "Amount must be greater than 0");

        usdtToken.transferFrom(msg.sender, address(this), _amount);

        balances[msg.sender] += _amount;
        customerRecords[msg.sender].TotalNFTStaking = _amount;
        
        // balances[address(this)] += _amount;
        // VoltTransfer(_amount);

        emit Staked(msg.sender, _amount);
    }

    function Check_Claim_Amount() public view returns (uint256 reward) {
        require(balances[msg.sender] * 3 >= mintingTokens[msg.sender] );
        uint256 stakedAmount = balances[msg.sender];
        require(stakedAmount > 0, "No staked amount");
        require(
            block.timestamp - lastUpdateTime[msg.sender] >= 1 days,
            "Can only claim once per day"
        );
        uint256 add;

        uint256 stakingDays = (block.timestamp - lastUpdateTime[msg.sender]) /
            1 days;
        uint256 rewards = (stakedAmount * 50) / 10000;

        if (block.timestamp - lastUpdateTime[msg.sender] > 1 days) {
            add = rewards;
            for (uint256 i = 1 days; i < stakingDays; i++) {
                add += (add * 50) / 10000;
                if(balances[msg.sender] * 3 == add ){
                    break ;
                }
            }
            return add;
        }
        return rewards;
    }

    function claim() external {
        uint256 stakedAmount = balances[msg.sender];
        require(stakedAmount > 0, "No staked amount");
         require(balances[msg.sender] * 3 > mintingTokens[msg.sender] );
        require(
            block.timestamp - lastUpdateTime[msg.sender] >= 1 days,
            "Can only claim once per day"
        );

        uint256 add;
        uint256 stakingDays = (block.timestamp - lastUpdateTime[msg.sender]) /
            1 days;
        uint256 rewards = (stakedAmount * 50) / 10000;
        if (block.timestamp - lastUpdateTime[msg.sender] > 1 days) {
            add = rewards;
            for (uint256 i = 1 days; i < stakingDays; i++) {
                add += (add * 50) / 10000;
                if(balances[msg.sender] * 3 == add){
                    break ;
                }
            }
            mintingTokens[msg.sender] = add;
            if(balances[msg.sender] * 3 == mintingTokens[msg.sender] ){
                balances[msg.sender] = 0;
            }
            StratToken += rewards;
            lastUpdateTime[msg.sender] = block.timestamp;
            emit claim_(msg.sender, stakedAmount, rewards);
        } else {
            mintingTokens[msg.sender] = rewards;
            StratToken += rewards;
            emit claim_(msg.sender, stakedAmount, rewards);
            lastUpdateTime[msg.sender] = block.timestamp;
        }
    }

    // function VoltTransfer(uint256 amount) internal {
    //     uint256 voli1Amount = (amount * 70) / 100;
    //     uint256 voli2Amount = (amount * 30) / 100;
    //     usdtToken.transferFrom(address(this), volt1, voli1Amount);
    //     usdtToken.transferFrom(address(this), volt2, voli2Amount);
    // }



    function createVote(uint256 _voteId, uint256 _startDate, uint256 _endDate) external {
        require(msg.sender == Owner(), "Only the owner can create votes");
        voteRecords[_voteId].startDate = _startDate;
        voteRecords[_voteId].endDate = _endDate;
    }
    function setFinishVote(uint256 _voteId, bool setFinish) external {
        require(msg.sender == Owner(),"Only Owner can wants to finish the voting");
        voteRecords[_voteId].finish = setFinish;
    }

    function vote(uint256 _voteId, bool _vote) external {
        require(voteRecords[_voteId].finish,"Owner already finish the voting");
        require(block.timestamp >= voteRecords[_voteId].startDate, "Voting has not started");
        require(block.timestamp <= voteRecords[_voteId].endDate, "Voting has ended");
        require(balances[msg.sender] >= 100 * 10**18, "Insufficient balance to vote");

        require(!customerRecords[msg.sender].votedTopics[_voteId], "Already voted for this topic");

        uint256 usdtBalance = balances[msg.sender];
        uint256 points = usdtBalance / (100 * 10**18);

        customerRecords[msg.sender].totalVotes += 1;
        customerRecords[msg.sender].totalPoints += points;
        customerRecords[msg.sender].votedTopics[_voteId] = _vote;

        if (_vote) {
            voteRecords[_voteId].totalYes += points;
        } else {
            voteRecords[_voteId].totalNo += points;
        }

        emit Voted(msg.sender,_voteId, _vote);
    }


function getCustomerRecord(address _customer, uint24 _voteId) external view returns (uint256 totalVotes, uint256 totalPoints, bool votedTopics) {
    totalVotes = customerRecords[_customer].totalVotes;
    totalPoints = customerRecords[_customer].totalPoints;
      votedTopics = customerRecords[_customer].votedTopics[_voteId];
}
    function getVoteRecord(uint256 _voteId) external view returns (uint256 startDate, uint256 endDate, uint256 totalYes, uint256 totalNo) {
        startDate = voteRecords[_voteId].startDate;
        endDate = voteRecords[_voteId].endDate;
        totalYes = voteRecords[_voteId].totalYes;
        totalNo = voteRecords[_voteId].totalNo;
    }
}
