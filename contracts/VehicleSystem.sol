//SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract VehicleSystem
{

    // struct for traffic violations
    // struct for transications
    // struct for licenses and make a relation with users and cars
    // enum for status pending_payment, compelete, failed
    // enum types of trffic violations like (Skip the top speed, etc..) | can add a custom one if not any of other we store?
    // struct for users reuqests to remove block on cars

    enum Role{
        CUSTOMER,
        MANUFACTURE,
        BANK,
        ADMIN
    }

    enum State {
        ACCEPTED,
        REJECTED,
        PENDING
    }

    struct manufacture
    {
        uint user_id;
        string manufacture_name;
    }

    struct vehicle
    {
        string vehicle_name;
        string vehicle_type;
        string vehicle_model;
        string vehicle_motor_number;
        string vehicle_chase_number;
        uint vehicle_manufacture_id;
        string vehicle_color;
        string vehicle_production_Year;
        bool isBlocked;
        uint user_id;
        State state;
    }

    struct user
    {
        address user_address;
        string user_name;
        string user_email;
        string user_password;
        string user_phone;
        string user_national_id;
    }

    struct bank
    {
        uint user_id;
        string bank_name;
    }

    // Traffic Violation
    struct traffic_violation
    {
        uint vehicle_id;
        string violation_type;
        string violation_description;
        string violation_status;
    }

    //Transactions struct
    struct transaction
    {
        uint user_id;
        string amount; // there is no floating point must bo string
        string status;
        uint bank_id;
        string created_at;
        string updated_at;
        // no updated at -> tranactions is only one time
    }

    struct license
    {
        uint user_id;
        uint car_id;
        string status;
        string expireat;
        uint security_directorate_id;
        State state;
    }

    manufacture[] public manufactures;
    bank[] public banks;
    vehicle[] public vehicles;
    user[] public users;
    traffic_violation[] public traffic_violations;
    transaction[] public transactions;
    license[] public licenses;

    address private deployer;

    constructor() {
        deployer = msg.sender;
    }

    function register(address _user_address, string memory _user_name, string memory _user_email, string memory _user_phone, string memory _user_password, string memory _user_national_id) public returns (bool)
    {
        user memory temp_hold_user = user(_user_address, _user_name, _user_email, _user_password, _user_phone, _user_national_id);
        users.push(temp_hold_user);
        return true;
    }

    function login(string memory passed_user_email, string memory passed_user_password) public view returns (int)
    {
        for (uint i = 0; i < users.length; i++)
        {
            string memory user_name = users[i].user_email;
            string memory user_password = users[i].user_password;
            if (compareStrings(user_name, passed_user_email))
            {
                if (compareStrings(user_password, passed_user_password))
                {
                    return int(i);
                }
            }
        }
        return -1;
    }

     function get_user(uint user_id) public view returns (user memory){
         return users[user_id];
     }

    function edit_user(uint _user_id, string memory _user_email, string memory _user_password, string memory _user_national_id) public returns (bool)
    {
        for (uint i = 0; i < users.length; i++)
        {
            uint user_id = i;
            if (compareUint(user_id, _user_id))
            {
                users[i].user_email = _user_email;
                users[i].user_password = _user_password;
                users[i].user_national_id = _user_national_id;
                return true;
            }
        }
        return false;
    }


    function add_manufacture_data(uint _manufacture_id, string memory _manufacture_name) public onlyDeployer {
        manufacture memory _manufacture = manufacture(_manufacture_id, _manufacture_name);
        manufactures.push(_manufacture);
    }

    function edit_manufacture(uint _manufacture_id, string memory _manufacture_name) public returns (bool)
    {
        for (uint i = 0; i < manufactures.length; i++)
        {
            uint current_manufacture_id = i;
            if (compareUint(current_manufacture_id, _manufacture_id))
            {
                manufactures[i].manufacture_name = _manufacture_name;
                return true;
            }
        }
        return false;
    }

    function add_license(uint passed_user_id, uint passed_car_id, string memory passed_status, string memory passed_expireat, uint passed_security_directorate_id) public returns (bool)
    {
        license memory temp_license = license(passed_user_id, passed_car_id, passed_status, passed_expireat, passed_security_directorate_id, State.ACCEPTED);
        licenses.push(temp_license);
        return true;
    }

    function edit_license(uint passed_license_id, uint passed_car_id, string memory passed_status, uint passed_security_directorate_id) public returns (bool)
    {
        for (uint i = 0; i < licenses.length; i++)
        {
            uint license_id = i;
            if (compareUint(license_id, passed_license_id))
            {
                //found license | edit
                //edit only car and status
                licenses[i].car_id = passed_car_id;
                licenses[i].status = passed_status;
                licenses[i].security_directorate_id = passed_security_directorate_id;
                return true;
            }
        }
        return false;
    }

    function request_to_renewal_licence(uint L_id) public view returns (bool)
    {
        for (uint i = 0; i < licenses.length; i++) {
            if (compareUint(L_id, i)) {
                add_transaction;
                return true;
            }
        }
        return false;
    }

    function accept_to_renewal_license(uint L_id) public returns (bool) {
        for (uint i = 0; i < licenses.length; i++)
        {
            uint license_id = i;
            if (compareUint(license_id, L_id))
            {
                licenses[i].state = State.ACCEPTED;
                return true;
            }
        }
        return false;
    }

    function reject_to_renewal_license(uint L_id) public returns (bool) {
        for (uint i = 0; i < licenses.length; i++)
        {
            uint license_id = i;
            if (compareUint(license_id, L_id))
            {
                licenses[i].state = State.REJECTED;
                return true;
            }
        }
        return false;
    }

    function pending_to_renewal_license(uint L_id) public returns (bool) {
        for (uint i = 0; i < licenses.length; i++)
        {
            uint license_id = i;
            if (compareUint(license_id, L_id))
            {
                licenses[i].state = State.PENDING;
                return true;
            }
        }
        return false;
    }

    function renewal_license(uint passed_license_id, string memory exp) public returns (bool)
    {
        for (uint i = 0; i < licenses.length; i++)
        {
            uint license_id = i;
            if (compareUint(license_id, passed_license_id))
            {
                //found license | edit
                //edit only car and status
                licenses[i].expireat = exp;
                return true;
            }
        }
        return false;
    }


    function add_traffic_violation(uint passed_vehicle_id, string memory vio_type, string memory vio_des, string memory vio_status) public returns (bool)
    {
        traffic_violation memory temp_violation = traffic_violation(passed_vehicle_id, vio_type, vio_des, vio_status);
        traffic_violations.push(temp_violation);
        return true;
    }

    function edit_traffic_violation(uint vio_id, /*uint passed_vehicle_id, */string memory vio_type, string memory vio_des, string memory vio_status) public returns (bool)
    {
        for (uint i = 0; i < traffic_violations.length; i++)
        {
            uint vio = i;
            if (compareUint(vio, vio_id))
            {
                //found vio | edit
                traffic_violations[i].violation_type = vio_type;
                traffic_violations[i].violation_description = vio_des;
                traffic_violations[i].violation_status = vio_status;
                return true;
            }
        }
        return false;
    }

    function add_transaction(uint passed_user_id, string memory passed_amount, string memory passed_status, uint passed_bank_id, string memory passed_created_at, string memory passed_updated_at) public returns (bool)
    {
        transaction memory temp_transaction = transaction(passed_user_id, passed_amount, passed_status, passed_bank_id, passed_created_at, passed_updated_at);
        transactions.push(temp_transaction);
        return true;
    }

    function edit_transaction(uint passed_trx_id, string memory passed_status, string memory passed_updated_at) public returns (bool)
    {
        for (uint i = 0; i < transactions.length; i++)
        {
            uint trx_id = i;
            if (compareUint(trx_id, passed_trx_id))
            {
                //found -> edit
                transactions[i].status = passed_status;
                transactions[i].updated_at = passed_updated_at;
                return true;
            }
        }
        return false;
    }

    function request_to_remove_block(uint v_id) public view returns (bool)
    {
        for (uint i = 0; i < vehicles.length; i++) {
            if (compareUint(v_id, i)) {
                add_transaction;
                return true;
            }
        }
        return false;
    }

    function accept_to_remove_block(uint v_id, uint user_id) public returns (bool) {
        bool ok = false;
        for (uint i = 0; i < banks.length; i++) {
            if (compareUint(user_id, banks[i].user_id)) {
                ok = true;
            }
        }
        require(ok == true, "Sorry Only A Bank Can Accept A Request !");
        for (uint i = 0; i < vehicles.length; i++) {
            if (compareUint(v_id, i)) {
                vehicles[i].state = State.ACCEPTED;
                return true;
            }
        }
        return false;
    }

    function reject_to_remove_block(uint v_id, uint user_id) public returns (bool) {
        bool ok = false;
        for (uint i = 0; i < banks.length; i++) {
            if (compareUint(user_id, banks[i].user_id)) {
                ok = true;
            }
        }
        require(ok == true, "Sorry Only A Bank Can Reject A Request !");
        for (uint i = 0; i < vehicles.length; i++) {
            if (compareUint(v_id, i)) {
                vehicles[i].state = State.REJECTED;
                return true;
            }
        }
        return false;
    }

    function pending_to_remove_block(uint v_id, uint user_id) public returns (bool) {
        bool ok = false;
        for (uint i = 0; i < banks.length; i++) {
            if (compareUint(user_id, banks[i].user_id)) {
                ok = true;
            }
        }
        require(ok == true, "Sorry Only A Bank Can Pending A Request !");
        for (uint i = 0; i < vehicles.length; i++) {
            if (compareUint(v_id, i)) {
                vehicles[i].state = State.PENDING;
                return true;
            }
        }
        return false;
    }

    function add_bank_data(uint user_id, string memory name) public onlyDeployer {
        bank memory bank_1 = bank(user_id, name);
        banks.push(bank_1);
    }

    function edit_bank(uint bank_id, uint user_id, string memory name) public onlyDeployer returns (bool)
    {
        for (uint i = 0; i < banks.length; i++) {
            if (compareUint(bank_id, i)) {
                banks[i].user_id = user_id;
                banks[i].bank_name = name;
                return true;
            }
        }
        return false;
    }

    function add_vehicle(uint manufacture_user_id, string memory vehicle_name, string memory vehicle_type, string memory vehicle_model, string memory vehicle_motor_number, string memory vehicle_chase_number, string memory vehicle_color, string memory vehicle_production_Year, bool isBlocked, State vehicle_state) public {
        bool ok = false;
        for (uint i = 0; i < manufactures.length; i++) {
            if (compareUint(manufacture_user_id, manufactures[i].user_id)) {
                ok = true;
            }
        }
        require(ok == true, "Sorry Only A Manufacture Can Add vehicle !");
        vehicle memory vehicle_1 = vehicle(vehicle_name, vehicle_type, vehicle_model, vehicle_motor_number, vehicle_chase_number, manufacture_user_id, vehicle_color, vehicle_production_Year, isBlocked, manufacture_user_id, vehicle_state);
        vehicles.push(vehicle_1);
    }

    function edit_vehicle(uint manufacture_user_id, uint vehicle_id, string memory vehicle_color, bool isBlocked, State vehicle_state) public returns (bool)
    {
        bool ok = false;
        for (uint i = 0; i < manufactures.length; i++) {
            if (compareUint(manufacture_user_id, manufactures[i].user_id)) {
                ok = true;
            }
        }
        require(ok == true, "Sorry Only A Manufacture Can Edit A vehicle !");
        for (uint i = 0; i < vehicles.length; i++) {
            if (compareUint(vehicle_id, i)) {
                vehicles[i].vehicle_color = vehicle_color;
                vehicles[i].state = vehicle_state;
                vehicles[i].isBlocked = isBlocked;
                return true;
            }
        }
        return false;

    }

    function change_ownership(uint new_owner_user_id, uint old_owner_user_id, uint vehicle_id) public {
        for (uint i = 0; i < vehicles.length; i++) {
            if (compareUint(vehicle_id, i)) {
                if (compareUint(old_owner_user_id, vehicles[i].user_id)) {
                    vehicles[i].user_id = new_owner_user_id;
                }
            }
        }
    }

    function car_change_block_status(uint bank_user_id, uint vehicle_id, bool blocked) public {
        bool ok = false;
        for (uint i = 0; i < banks.length; i++) {
            if (compareUint(bank_user_id, banks[i].user_id)) {
                ok = true;
            }
        }
        require(ok == true, "Sorry Only A Bank Can block A Car !");
        for (uint i = 0; i < vehicles.length; i++) {
            if (compareUint(vehicle_id, i)) {
                vehicles[i].isBlocked = blocked;
            }
        }
    }

    function users_length() public view returns (uint){
        return users.length;
    }

    function vehicles_length() public view returns (uint){
        return vehicles.length;
    }

    function banks_length() public view returns (uint){
        return banks.length;
    }

    function traffic_violations_length() public view returns (uint){
        return traffic_violations.length;
    }

    function manufactures_length() public view returns (uint){
        return manufactures.length;
    }

    function transactions_length() public view returns (uint){
        return transactions.length;
    }

    function licenses_length() public view returns (uint){
        return licenses.length;
    }

    modifier onlyDeployer() {
        require(msg.sender == deployer, "Access denied!");
        _;
    }
    function compareAddress(address a, address b) public pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }

    function compareUint(uint a, uint b) public pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }

    function compareStrings(string memory a, string memory b) public pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));}
}
