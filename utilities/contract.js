const Web3 = require("web3");
const VehicleSystem = require("../build/contracts/VehicleSystem.json");

async function contract() {
    const web3 = new Web3(new Web3.providers.HttpProvider(process.env.WEB3_PROVIDER_URL || "http://127.0.0.1:7545"));
    let abi = VehicleSystem.abi
    const contract_address = VehicleSystem.networks[process.env.NETWORK_ID].address
    // return {
    //     contract: new web3.eth.Contract(abi, contract_address),
    //     accounts: await web3.eth.getAccounts()
    // }
    return new web3.eth.Contract(abi, contract_address);
}


module.exports = contract

