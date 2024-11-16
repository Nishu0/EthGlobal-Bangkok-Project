// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

interface Router {
    function fetchOutcome(uint256 data) external returns(bool);
}

contract Polymarket {
    address public owner;
    address public polyToken;
    Router public router;

    uint256 public totalQuestions = 0;

    constructor(address _polyToken, address router_) {
        owner = msg.sender;
        polyToken = _polyToken;
        router = Router(router_);
    }

    function changeToken(address token_) public {
        require(msg.sender == owner);
        polyToken = token_;
    }

    function changeRouter(address router_) public {
        require(msg.sender == owner);
        router = Router(router_);
    }

    mapping(uint256 => Questions) public questions;
    mapping(uint256 => bool) public outcomes;

    struct Questions {
        uint256 id;
        uint256 question;
        uint256 timestamp;
        uint256 endTimestamp;
        address createdBy;
        string creatorImageHash;
        AmountAdded[] yesCount;
        AmountAdded[] noCount;
        uint256 totalAmount;
        uint256 totalYesAmount;
        uint256 totalNoAmount;
        bool eventCompleted;
        string description;
    }

    struct AmountAdded {
        address user;
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => uint256) public winningAmount;
    address[] public winningAddresses;
    

    event QuestionCreated(
        uint256 id,
        uint256 question,
        uint256 timestamp,
        address createdBy,
        uint256 totalAmount,
        uint256 totalYesAmount,
        uint256 totalNoAmount
    );

    function createQuestion(
        uint256 _question,
        uint256 duration
    ) public {
        require(msg.sender == owner, "Unauthorized");

        uint256 timestamp = block.timestamp;

        Questions storage question = questions[totalQuestions];

        question.id = totalQuestions++;
        question.question = _question;
        question.timestamp = timestamp;
        question.createdBy = msg.sender;
        question.totalAmount = 0;
        question.totalYesAmount = 0;
        question.totalNoAmount = 0;
        question.description = "Is price above than?";
        question.endTimestamp = block.timestamp + duration;

        emit QuestionCreated(
            totalQuestions,
            _question,
            timestamp,
            msg.sender,
            0,
            0,
            0
        );
    }

    function addYesBet(uint256 _questionId, uint256 _value) public {
        Questions storage question = questions[_questionId];
        ERC20(polyToken).transferFrom(msg.sender, address(this), _value);
        AmountAdded memory amountAdded = AmountAdded(
            msg.sender,
            _value,
            block.timestamp
        );

        question.totalYesAmount += _value;
        question.totalAmount += _value;
        question.yesCount.push(amountAdded);
    }

    function addNoBet(uint256 _questionId, uint256 _value) public {
        Questions storage question = questions[_questionId];
        ERC20(polyToken).transferFrom(msg.sender, address(this), _value);
        AmountAdded memory amountAdded = AmountAdded(
            msg.sender,
            _value,
            block.timestamp
        );

        question.totalNoAmount += _value;
        question.totalAmount += _value;
        question.noCount.push(amountAdded);
    }

    function getGraphData(uint256 _questionId)
        public
        view
        returns (AmountAdded[] memory, AmountAdded[] memory)
    {
        Questions storage question = questions[_questionId];
        return (question.yesCount, question.noCount);
    }

    function fetchOutcome(uint256 data, uint256 id) internal returns(bool outcome){
        require(msg.sender == owner);
        outcome = router.fetchOutcome(data);
        outcomes[id] = outcome;
    }

    function distributeWinningAmount(uint256 _questionId)
        public
        payable
    {
        bool eventOutcome = fetchOutcome(questions[_questionId].question, _questionId);
        require(block.timestamp > questions[_questionId].endTimestamp);
        require(msg.sender == owner, "Unauthorized");
                Questions storage question = questions[_questionId];
        if (eventOutcome) {
            for (uint256 i = 0; i < question.yesCount.length; i++) {
                uint256 amount = (question.totalNoAmount *
                    question.yesCount[i].amount) / question.totalYesAmount;
                winningAmount[question.yesCount[i].user] += (amount +
                    question.yesCount[i].amount);
                winningAddresses.push(question.yesCount[i].user);
            }

            for (uint256 i = 0; i < winningAddresses.length; i++) {
                address payable _address = payable(winningAddresses[i]);
                ERC20(polyToken).transfer(_address, winningAmount[_address]);
                delete winningAmount[_address];
            }
            delete winningAddresses;
        } else {
            for (uint256 i = 0; i < question.noCount.length; i++) {
                uint256 amount = (question.totalYesAmount *
                    question.noCount[i].amount) / question.totalNoAmount;
                winningAmount[question.noCount[i].user] += (amount +
                    question.noCount[i].amount);
                winningAddresses.push(question.noCount[i].user);
            }

            for (uint256 i = 0; i < winningAddresses.length; i++) {
                address payable _address = payable(winningAddresses[i]);
                ERC20(polyToken).transfer(_address, winningAmount[_address]);
                delete winningAmount[_address];
            }
            delete winningAddresses;
        }
        question.eventCompleted = true;
    }

    function isAdmin() public view returns (bool) {
        if (msg.sender == owner) return true;
        else return false;
    }
}
