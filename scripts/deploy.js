const hre = require("hardhat");

const main = async () => {
    try {
        const nftcontractFactory = await hre.ethers.getContractFactory("ChainBattles");
        const nftcontract = await nftcontractFactory.deploy();
        await nftcontract.deployed();
        console.log("Contract deployed at", nftcontract.address);
        process.exit(0);

    } catch (error) {

        console.log(error);
        process.exit(1);
    }
};

main();