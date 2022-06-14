function roles(role) {
    const allRoles = [
        'customer',
        'manufacture',
        'bank',
        'admin'
    ]
    return allRoles[role]
}

module.exports = roles
