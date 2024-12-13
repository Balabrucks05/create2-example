// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

// Contract to be deployed with CREATE2
contract DeployWithCreate2 {
    address public owner;
    uint256 public creationTime;

    // Constructor to set the owner and store the creation time
    constructor(address _owner) {
        owner = _owner;
        creationTime = block.timestamp;
    }

    // Function to return contract creation time
    function getCreationTime() external view returns(uint256) {
        return creationTime;
    }
}
