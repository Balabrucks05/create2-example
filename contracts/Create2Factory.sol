//SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

//Importing the DeployWithCreate2 contract
import "./DeployWithCreate2.sol";

contract Create2Factory{

    event ContractDeployed(address addr);
    event saltUsed(uint256 salt);

    //Functions to deploy contract with Create2

    function deploy(uint salt) external{
        bytes memory bytecode = getByteCode(msg.sender);
        address predictedAddress = computeAddress(bytecode, salt);
        
        new DeployWithCreate2{salt: bytes32(salt)}(msg.sender);

         
        emit ContractDeployed(predictedAddress); 
        emit saltUsed(salt);  
    } 

    //Computes the address before contract deployment
    function computeAddress(bytes memory bytecode, uint _salt) public view returns (address) {
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                _salt,
                keccak256(bytecode)
            )
        );
        return address (uint160(uint(hash)));  //Returns the predicted contract address
    }
        function getByteCode(address owner) public pure returns (bytes memory){
            bytes memory bytecode = type(DeployWithCreate2).creationCode; //Get the contract creation code
            return abi.encodePacked(bytecode, abi.encode(owner));  //Encode bytecode with the creator's address
        }

        //Function to calculate contract creation time
        function predictCreationTime(bytes memory bytecode, uint _salt) public view returns(uint256) {
            address predictedAddress = computeAddress(bytecode, _salt);

            return DeployWithCreate2(predictedAddress).getCreationTime();
        }

}
