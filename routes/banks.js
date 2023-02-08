const BanksController = require("../app/controllers/BanksController");
const admin = require("../app/middlewares/admin");

function banksRoutes(app) {
    app.get("/banks", admin, BanksController().allBanks)
}

module.exports = banksRoutes
