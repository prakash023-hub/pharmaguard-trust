// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ComplianceAudit — Casper Agentic Buildathon: clinical lookup audit trail
/// @dev Deploy via Odra on Casper Testnet; agent pays via x402 for each lookup
contract ComplianceAudit {
    struct Lookup {
        bytes32 sessionId;
        bytes32 queryHash;
        address requester;
        uint256 paidAmount;
        uint256 timestamp;
    }

    mapping(bytes32 => Lookup) public lookups;
    bytes32[] public lookupIds;
    uint256 public lookupFee;

    event LookupRecorded(
        bytes32 indexed sessionId,
        bytes32 queryHash,
        address requester,
        uint256 paidAmount
    );

    constructor(uint256 _lookupFee) {
        lookupFee = _lookupFee;
    }

    function recordLookup(bytes32 sessionId, bytes32 queryHash) external payable {
        require(msg.value >= lookupFee, "Insufficient x402 payment");
        lookups[sessionId] = Lookup({
            sessionId: sessionId,
            queryHash: queryHash,
            requester: msg.sender,
            paidAmount: msg.value,
            timestamp: block.timestamp
        });
        lookupIds.push(sessionId);
        emit LookupRecorded(sessionId, queryHash, msg.sender, msg.value);
    }

    function lookupCount() external view returns (uint256) {
        return lookupIds.length;
    }
}
