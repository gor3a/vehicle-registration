function ManufacturersController() {
    return {
        allManufacturers(req, res, next) {
            res.render("manufacturers/list")
        }
    }
}

module.exports = ManufacturersController
