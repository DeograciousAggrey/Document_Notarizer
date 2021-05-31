//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.0;

contract ProofOfExistence {
    mapping (bytes32 => bool) private proofs;

    //Store proof of existence in the contract state
    function storeProof(bytes32 proof) private {
        proofs[proof] = true;
    }

    //Calculate and store proof for a document
    function notarize(string memory document) public {
        storeProof(proofFor(document));
    }

    //Helper function to get a document's hash sha256
    function proofFor(string memory document) private pure returns (bytes32) {
        return sha256(bytes(document));
    }

    //Check if a document has been notarized
    function checkDocument(string memory document) public view returns (bool) {
        return proofs[proofFor(document)];
    }
}