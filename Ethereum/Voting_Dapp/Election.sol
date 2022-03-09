// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Election {
    //--------------------------------------------------------------------
    // VARIABLES

    address public admin;
    uint256 public totalNumberOfVoters = 0;
    uint256 public numberOfCandidates = 0;

    ElectionState public electionCurrentState;
    uint256 public voteEndTimestamp;

    enum ElectionState {
        NOTOPENYET,
        OPEN,
        ENDED
    }

    struct Candidate {
        uint8 id;
        string name;
        uint32 votesCount;
    }

    struct Vote {
        bool hasVoted;
        uint256 candidateId;
    }

    Candidate[] public candidatesList;
    mapping(address => Vote) votes;

    //--------------------------------------------------------------------
    // EVENTS

    event VoteOpened(uint256 timestamp);
    event VoteEnded(uint256 timestamp);
    event CandidateAdded(uint256 id, string name);

    //--------------------------------------------------------------------
    // MODIFIERS

    modifier onlyAdmin() {
        require(msg.sender == admin, "only admin functions");
        _;
    }

    modifier isElectionState(ElectionState _state) {
        require(_state == electionCurrentState, "");
        _;
    }

    //--------------------------------------------------------------------
    // CONSTRUCTOR

    constructor() {
        admin = msg.sender;
        electionCurrentState = ElectionState.NOTOPENYET;
    }

    //--------------------------------------------------------------------
    // FUNCTIONS

    function vote(uint256 _candidateId)
        public
        isElectionState(ElectionState.OPEN)
    {
        require(_candidateId < numberOfCandidates);
        require(!votes[msg.sender].hasVoted, "Already voted");
        votes[msg.sender] = Vote(true, _candidateId);
        candidatesList[_candidateId].votesCount++;
        totalNumberOfVoters++;
    }

    function getVoteCount(uint256 _candidateId) public view returns (uint256) {
        return candidatesList[_candidateId].votesCount;
    }

    function getUserVote(address _user) public view returns (uint256) {
        require(votes[_user].hasVoted, "User Didn't vote");
        return votes[_user].candidateId;
    }

    function getCandidatesList() public view returns (Candidate[] memory) {
        return candidatesList;
    }

    function getResult()
        public
        view
        isElectionState(ElectionState.ENDED)
        returns (Candidate memory)
    {
        uint256 maxCount = 0;
        uint256 winnerId = 0;

        for (uint256 i = 0; i < numberOfCandidates; i++) {
            if (candidatesList[i].votesCount > maxCount) {
                maxCount = candidatesList[i].votesCount;
                winnerId = i;
            }
        }
        return candidatesList[winnerId];
    }

    //--------------------------------------------------------------------
    // ADMIN FUNCTIONS

    function openVoting(uint256 _voteDuration)
        public
        onlyAdmin
        isElectionState(ElectionState.NOTOPENYET)
    {
        require(
            candidatesList.length > 0,
            "Can't open election with no candidate"
        );
        voteEndTimestamp = block.timestamp + _voteDuration;
        electionCurrentState = ElectionState.OPEN;

        emit VoteOpened(block.timestamp);
    }

    function addCandidate(string memory _name)
        public
        onlyAdmin
        isElectionState(ElectionState.NOTOPENYET)
    {
        uint256 newId = numberOfCandidates;
        candidatesList.push(Candidate(uint8(newId), _name, 0));
        numberOfCandidates++;

        emit CandidateAdded(newId, _name);
    }

    function endVoting() external onlyAdmin {
        require(block.timestamp >= voteEndTimestamp, "Vote duration not ended");
        electionCurrentState = ElectionState.ENDED;

        emit VoteEnded(block.timestamp);
    }
}
