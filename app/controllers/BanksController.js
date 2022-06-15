function BanksController() {
    return {
        allBanks(req, res, next) {
            res.render("banks/list")
        }
    }
}

module.exports = BanksController
