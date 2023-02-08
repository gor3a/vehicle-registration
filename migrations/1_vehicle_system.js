const VehicleSystem = artifacts.require("VehicleSystem");

module.exports = function (deployer) {
    deployer.deploy(VehicleSystem);
};
