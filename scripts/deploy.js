const {ethers} = require('hardhat');

async function main(){
    //parameters
    const salt = 55555;
    const owner = await ethers.getSigner();

    //Deploy the Deploywithcreate2 contract

    const Deploywithcreate2 = await ethers.getContractFactory("DeployWithCreate2");
    const deployWithCreate2 = await Deploywithcreate2.deploy(owner.address);
    await deployWithCreate2.deployed();

    console.log("DeployWithCreate2 contract Deployed to", deployWithCreate2.address);

    //Deploy Create2Factory
    
    const Create2Factory = await ethers.getContractFactory("Create2Factory");
    const create2Factory = await Create2Factory.deploy();
    await create2Factory.deployed();

    console.log("Create2Factory contract deployed to", create2Factory.address);

    //Calculate the predicted address for DeployWithCreate2 contract using Create2

    const bytecode = await create2Factory.getByteCode(owner.address); 
    const predictedAddress = await create2Factory.computeAddress(bytecode, salt);

    console.log("Predicted address for DeployWithCreate2 contract using CREATE2:",predictedAddress);

    //Deploy the DeployWithCreate2 contract using Create2Factory
    await create2Factory.deploy(salt);
    console.log("DeployWithCreate2 Contract deployed using CREATE2.");

    //verify the deployed address
    const deployedAddress = await create2Factory.computeAddress(bytecode, salt);
    console.log("Deployed contract address:", deployedAddress);

    if (deployedAddress == predictedAddress){
        console.log("Deployment successfull! Contract address matched predicted address.");
    } else{
        console.log("Deployment Failed. Contract address does not match predicted address.");

    }

}
main().catch((error) =>{
    console.error(error);
    process.exit(1);
});