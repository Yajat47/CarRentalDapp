require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: "https://eth-goerli.gateway.pokt.network/v1/lb/17622449d5763869b66dbd6a",
      accounts: ["7e1901b8695e66731eb52902d0e71b44c5c5d04104ddd26e843c4fa8a4e52b67"]
    } 
  },
};
