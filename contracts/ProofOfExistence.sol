//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.0;

contract ProofOfExistence {
    mapping (bytes32 => bool) private proofs;

    //---Events---//
    event DocumentNotarized (address from,string text,bytes32 hash);
    event NotarizationError ( address from, string text, string reason);

 //Store proof of existence in the contract state
    function storeProof(bytes32 proof) private {
        proofs[proof] = true;
    }

    //Calculate and store proof for a document
    function notarize(string memory document) public payable {
       // require(msg.value == 1 ether);

        //Check if the string was previously notarized
        if(proofs[proofFor(document)]) {

            //Emit the event
            emit NotarizationError(msg.sender, document, "The document exists so it cannot be Notarized");
           
            //Refund the ether
            msg.sender.transfer(msg.value);
           
            //Exit the function
            return;
        }

        //Check the value of ether sent to the contract
        if(msg.value != 1 ether){
            //Emit the error event
            emit NotarizationError(msg.sender, document, "Incorrect Amount of Ether Paid");

            //Refund back the ether
            msg.sender.transfer(msg.value);

            //Exit the Function
            return;
        } 
    
        //Store the hash of the string    
        storeProof(proofFor(document));

        //Emit the success event
        emit DocumentNotarized(msg.sender, document, proofFor(document));
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