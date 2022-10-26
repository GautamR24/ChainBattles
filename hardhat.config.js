require("dotenv").config();
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");

module.exports = {
  solidity: "0.8.10",
  networks: {
    mumbai: {
      url: process.env.TESTNET_RPC,
      accounts: [proces.env.PRIVATE_KEY]
    },
    etherscan: {
      apikey: process.env.POLYGONSCAN_API_KET
    }
  }
};