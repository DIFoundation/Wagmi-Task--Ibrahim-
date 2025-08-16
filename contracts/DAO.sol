// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DAO {

    struct Proposal {
        uint id;
        string description;
        ProposalStatus status;
        uint approvals;
        uint rejections;
        mapping(address => bool) voted;
    }

    enum ProposalStatus { Pending, Passed, Failed }

    address[] public admins; // 3 admins
    mapping(address => bool) public isAdmin;
    mapping(address => bool) public isMember;

    uint public proposalCount;
    mapping(uint => Proposal) private proposals; // proposals by id

    constructor(address[] memory _admins) {
        require(_admins.length == 3, "Must provide exactly 3 admins");
        for (uint i = 0; i < 3; i++) {
            admins.push(_admins[i]);
            isAdmin[_admins[i]] = true;
            isMember[_admins[i]] = true; // admins are also members
        }
    }

    function joinDAO() external {
        require(!isMember[msg.sender], "Already a member");
        isMember[msg.sender] = true;
    }

    function createProposal(string memory _description) external {
        require(isMember[msg.sender], "Not a DAO member");
        proposalCount++;
        Proposal storage newProposal = proposals[proposalCount];
        newProposal.id = proposalCount;
        newProposal.description = _description;
        newProposal.status = ProposalStatus.Pending;
    }

    function voteOnProposal(uint proposalId, bool approve) external {
        require(isAdmin[msg.sender], "Only admins can vote");
        Proposal storage newProposal = proposals[proposalId];
        require(newProposal.status == ProposalStatus.Pending, "Proposal not pending");
        require(!newProposal.voted[msg.sender], "Admin already voted");

        newProposal.voted[msg.sender] = true;
        if (approve) {
            newProposal.approvals++;
        } else {
            newProposal.rejections++;
        }
    }

    function getProposal(uint proposalId) external view returns (
        uint id,
        string memory description,
        ProposalStatus status,
        uint approvals,
        uint rejections
    ) {
        Proposal storage p = proposals[proposalId];
        return (p.id, p.description, p.status, p.approvals, p.rejections);
    }

}
