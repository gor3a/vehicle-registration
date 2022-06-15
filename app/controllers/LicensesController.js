function LicensesController() {
    return {
        allLicenses(req, res, next) {
            res.render('licenses/list')
        }
    }
}

module.exports = LicensesController
