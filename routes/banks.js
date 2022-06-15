const VehiclesController = require("../app/controllers/VehiclesController");
const auth = require("../app/middlewares/auth");
const BanksController = require("../app/controllers/BanksController");

function banksRoutes(app) {
    app.get("/banks", BanksController().allBanks)
}

module.exports = banksRoutes
