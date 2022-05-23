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

    enum STATE {
        ACCEPTED,
        REJECTED,
        PENDING
    }

    struct manufacture
    {
        address manufacture_address;
        uint manufacture_id;
        string manufacture_name;
    }

    struct vehicle_data
    {
        uint vehicle_id;
        string vehicle_name;
        string vehicle_type;
        string vehicle_model;
        string vehicle_motornumber;
        string vehicle_chasea_number;
        uint vehicle_manufacture_id;
        address vehicle_owner;
        string vehicle_color;
        string vehicle_production_Year;
        bool isBlocked;
        STATE state;
    }

    struct user
    {
        address user_address;
        uint user_id;
        string user_name;
        string user_email;
        // hash password when register with any encrypt on solidity
        // and when try to login hash the password user enterd to equals with password stored.
        string user_password;
        //string user_phone;
        string user_gender;
        string user_birthday;
        string user_living_address;
        string user_national_id;
        uint user_bank_id;
        string user_bank_account;
    }

    struct bank
    {
        address bank_address;
        uint bank_id;
        string bank_name;
    }


    // Traffic Violation
    struct traffic_violation
    {
        uint id;
        uint vehicle_id;
        string violation_type;
        string violation_description;
        string violation_status;
    }

    //Transactions struct
    struct transaction
    {
        uint trx_id;
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
        uint license_id;
        uint user_id;
        uint car_id;
        string status;
        string expireat;
        uint security_directorate_id;
        STATE state;

    }

    struct security_directorate
    {
        uint directorate_id;
        string directorate_name;
    }

    string mm = "Mina Sameh";

    manufacture[] manufactures;
    bank[] banks;
    vehicle_data[] vehicles;
    user[] users;
    traffic_violation[] traffic_violations;
    transaction[] transactions;
    license[] licenses;
    security_directorate[] sec_dir;

    address private deployer;



    constructor() {
        deployer = msg.sender;
    }

    mapping(string => string) public xx;

    function set_status(string memory _s, string memory _sx) public {
        xx[_s] = _sx;
    }

    function get_status(string memory _s, string memory _ss) public view returns (string memory){
        return string(abi.encodePacked(xx[_s], " ", _ss));
    }

    function testPrint() public view returns (string memory){
        return mm;
    }

    function add_security_directorate(uint passed_id, string memory passed_name) public returns (bool)
    {
        security_directorate memory temp_sec_dir = security_directorate(passed_id, passed_name);
        sec_dir.push(temp_sec_dir);
        return true;
    }

    function register(address _user_address, uint _user_id, string memory _user_name, string memory _user_email, string memory _user_password, string memory _user_gender, string memory _user_birthday, string memory _user_living_address, string memory _user_national_id, uint _user_bank_id, string memory _user_bank_account) public returns (bool)
    {
        // removed phone number -> limit 11 var passing | more -> bug
        // validation if needed to implement
        user memory temp_hold_user = user(_user_address, _user_id, _user_name, _user_email, _user_password, _user_gender, _user_birthday, _user_living_address, _user_national_id, _user_bank_id, _user_bank_account);
        users.push(temp_hold_user);
        return true;
    }

    function login(string memory passed_user_name, string memory passed_user_password) public view returns (bool)
    {
        for (uint i = 0; i < users.length; i++)
        {
            string memory user_name = users[i].user_name;
            string memory user_password = users[i].user_password;
            if (compareStrings(user_name, passed_user_name))
            {
                if (compareStrings(user_password, passed_user_password))
                {
                    return true;
                }
            }
        }
        return false;
    }

    function edit_user(uint _user_id, string memory _user_email, string memory _user_password, string memory _user_gender, string memory _user_birthday, string memory _user_living_address, uint _user_bank_id, string memory _user_bank_account) public returns (bool)
    {
        // edit every thing
        // based on our desition
        for (uint i = 0; i < users.length; i++)
        {
            uint user_id = users[i].user_id;
            if (compareUint(user_id, _user_id))
            {
                //user founded
                //update information
                //users[i].user_address = _user_address; // logical we can't change this
                //users[i].user_id = _user_id;
                //users[i].user_name = _user_name;
                users[i].user_email = _user_email;
                // hash password when register with any encrypt on solidity
                // and when try to login hash the password user enterd to equals with password stored.
                users[i].user_password = _user_password;
                //string user_phone;
                users[i].user_gender = _user_gender;
                users[i].user_birthday = _user_birthday;
                users[i].user_living_address = _user_living_address;
                users[i].user_national_id = _user_living_address;
                users[i].user_bank_id = _user_bank_id;
                users[i].user_bank_account = _user_bank_account;
                return true;
            }
        }
        return false;
    }


    function add_manufacture_data(address add, uint id, string memory name) public onlyDeployer {
        manufacture memory manufacture_1;
        manufacture_1.manufacture_address = add;
        manufacture_1.manufacture_id = id;
        manufacture_1.manufacture_name = name;
        manufactures.push(manufacture_1);
    }

    function edit_manufacture(address passed_manufacture_address, uint passed_manufacture_id, string memory passed_manufacture_name) public returns (bool)
    {
        for (uint i = 0; i < manufactures.length; i++)
        {
            uint current_manufacture_id = manufactures[i].manufacture_id;
            if (compareUint(current_manufacture_id, passed_manufacture_id))
            {
                //make edits
                manufactures[i].manufacture_address = passed_manufacture_address;
                manufactures[i].manufacture_name = passed_manufacture_name;
                return true;
            }
        }
        return false;
    }

    function delete_manufature(uint passed_manufacture_id) public onlyDeployer returns (bool)
    {
        for (uint i = 0; i < manufactures.length; i++) {
            if (compareUint(passed_manufacture_id, manufactures[i].manufacture_id)) {
                uint index = i;
                for (uint j = index; j < banks.length - 1; j++) {
                    manufactures[j].manufacture_address = manufactures[j + 1].manufacture_address;
                    manufactures[j].manufacture_id = manufactures[j + 1].manufacture_id;
                    manufactures[j].manufacture_name = manufactures[j + 1].manufacture_name;
                }
                delete manufactures[manufactures.length - 1];
                manufactures.pop();
                return true;
            }
        }
        return false;
    }

    function add_license(uint passed_license_id, uint passed_user_id, uint passed_car_id, string memory passed_status, string memory passed_expireat, uint passed_security_directorate_id) public returns (bool)
    {
        license memory temp_license = license(passed_license_id, passed_user_id, passed_car_id, passed_status, passed_expireat, passed_security_directorate_id, STATE.ACCEPTED);
        licenses.push(temp_license);
        return true;
    }

    function edit_license(uint passed_license_id, uint passed_car_id, string memory passed_status, uint passed_security_directorate_id) public returns (bool)
    {
        for (uint i = 0; i < licenses.length; i++)
        {
            uint license_id = licenses[i].license_id;
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

    function delete_license(uint passed_license_id) public returns (bool)
    {
        for (uint i = 0; i < licenses.length; i++)
        {
            uint license_id = licenses[i].license_id;
            if (compareUint(license_id, passed_license_id))
            {
                //found license | delete
                licenses[i] = licenses[licenses.length - 1];
                //use pop
                delete licenses[licenses.length - 1];
                licenses.pop();

                return true;
            }
        }
        return false;
    }

    function request_to_renewal_licence(uint L_id) public view returns (bool)
    {
        for (uint i = 0; i < licenses.length; i++) {
            if (compareUint(L_id, licenses[i].license_id)) {
                add_transaction;
                return true;
            }
        }
        return false;
    }

    function accept_to_renewal_license(uint L_id) public returns (bool) {
        for (uint i = 0; i < licenses.length; i++)
        {
            uint license_id = licenses[i].license_id;
            if (compareUint(license_id, L_id))
            {
                licenses[i].state = STATE.ACCEPTED;
                return true;
            }
        }
        return false;
    }

    function reject_to_renewal_license(uint L_id) public returns (bool) {
        for (uint i = 0; i < licenses.length; i++)
        {
            uint license_id = licenses[i].license_id;
            if (compareUint(license_id, L_id))
            {
                licenses[i].state = STATE.REJECTED;
                return true;
            }
        }
        return false;
    }

    function pending_to_renewal_license(uint L_id) public returns (bool) {
        for (uint i = 0; i < licenses.length; i++)
        {
            uint license_id = licenses[i].license_id;
            if (compareUint(license_id, L_id))
            {
                licenses[i].state = STATE.PENDING;
                return true;
            }
        }
        return false;
    }

    function renewal_license(uint passed_license_id, string memory exp) public returns (bool)
    {
        for (uint i = 0; i < licenses.length; i++)
        {
            uint license_id = licenses[i].license_id;
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


    function add_traffic_violation(uint id, uint passed_vehicle_id, string memory vio_type, string memory vio_des, string memory vio_status) public returns (bool)
    {
        traffic_violation memory temp_violation = traffic_violation(id, passed_vehicle_id, vio_type, vio_des, vio_status);
        traffic_violations.push(temp_violation);
        return true;
    }

    function edit_traffic_violation(uint vio_id, /*uint passed_vehicle_id, */string memory vio_type, string memory vio_des, string memory vio_status) public returns (bool)
    {
        for (uint i = 0; i < traffic_violations.length; i++)
        {
            uint vio = traffic_violations[i].id;
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

    function delete_traffic_violation(uint vio_id) public returns (bool)
    {
        for (uint i = 0; i < traffic_violations.length; i++)
        {
            uint vio = traffic_violations[i].id;
            if (compareUint(vio, vio_id))
            {
                // Found | Delete
                traffic_violations[i] = traffic_violations[traffic_violations.length - 1];
                //use pop
                delete traffic_violations[traffic_violations.length - 1];
                traffic_violations.pop();

                return true;
            }
        }
        return false;
    }

    function add_transaction(uint passed_trx_id, uint passed_user_id, string memory passed_amount, string memory passed_status, uint passed_bank_id, string memory passed_created_at, string memory passed_updated_at) public returns (bool)
    {
        transaction memory temp_transaction = transaction(passed_trx_id, passed_user_id, passed_amount, passed_status, passed_bank_id, passed_created_at, passed_updated_at);
        transactions.push(temp_transaction);
        return true;
    }

    function edit_transaction(uint passed_trx_id, string memory passed_status, string memory passed_updated_at) public returns (bool)
    {
        for (uint i = 0; i < transactions.length; i++)
        {
            uint trx_id = transactions[i].trx_id;
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
            if (compareUint(v_id, vehicles[i].vehicle_id)) {
                add_transaction;
                return true;
            }
        }
        return false;
    }

    function accept_to_remove_block(uint v_id) public returns (bool) {
        bool ok = false;
        for (uint i = 0; i < banks.length; i++) {
            if (compareAdresses(msg.sender, banks[i].bank_address)) {
                ok = true;
            }
        }
        require(ok == true, "Sorry Only A Bank Can Accept A Request !");
        for (uint i = 0; i < vehicles.length; i++) {
            if (compareUint(v_id, vehicles[i].vehicle_id)) {
                vehicles[i].state = STATE.ACCEPTED;
                return true;
            }
        }
        return false;
    }

    function reject_to_remove_block(uint v_id) public returns (bool) {
        bool ok = false;
        for (uint i = 0; i < banks.length; i++) {
            if (compareAdresses(msg.sender, banks[i].bank_address)) {
                ok = true;
            }
        }
        require(ok == true, "Sorry Only A Bank Can Reject A Request !");
        for (uint i = 0; i < vehicles.length; i++) {
            if (compareUint(v_id, vehicles[i].vehicle_id)) {
                vehicles[i].state = STATE.REJECTED;
                return true;
            }
        }
        return false;
    }

    function pending_to_remove_block(uint v_id) public returns (bool) {
        bool ok = false;
        for (uint i = 0; i < banks.length; i++) {
            if (compareAdresses(msg.sender, banks[i].bank_address)) {
                ok = true;
            }
        }
        require(ok == true, "Sorry Only A Bank Can Pending A Request !");
        for (uint i = 0; i < vehicles.length; i++) {
            if (compareUint(v_id, vehicles[i].vehicle_id)) {
                vehicles[i].state = STATE.PENDING;
                return true;
            }
        }
        return false;
    }


    function add_bank_data(address add, uint id, string memory name) public onlyDeployer {
        bank memory bank_1;
        bank_1.bank_address = add;
        bank_1.bank_id = id;
        bank_1.bank_name = name;
        banks.push(bank_1);
    }

    function edit_bank(address add, uint id, string memory name) public onlyDeployer returns (bool)
    {
        for (uint i = 0; i < banks.length; i++) {
            if (compareUint(id, banks[i].bank_id)) {
                banks[i].bank_address = add;
                banks[i].bank_id = id;
                banks[i].bank_name = name;
                return true;
            }
        }
        return false;
    }

    function delete_bank(uint id) public onlyDeployer returns (bool)
    {
        for (uint i = 0; i < banks.length; i++) {
            if (compareUint(id, banks[i].bank_id)) {
                uint index = i;
                for (uint j = index; j < banks.length - 1; j++) {
                    banks[j].bank_address = banks[j + 1].bank_address;
                    banks[j].bank_id = banks[j + 1].bank_id;
                    banks[j].bank_name = banks[j + 1].bank_name;

                }
                delete banks[banks.length - 1];
                banks.pop();
                return true;
            }
        }
        return false;
    }

    function add_vehicle(address add, uint id, uint manufacture_id, string memory model, string memory motornum, string memory chasea, string memory color) public {
        bool ok = false;
        for (uint i = 0; i < manufactures.length; i++) {
            if (compareAdresses(msg.sender, manufactures[i].manufacture_address)) {
                ok = true;
            }
        }
        require(ok == true, "Sorry Only A Manufacture Can Add vechial !");
        vehicle_data memory vechial_1;
        vechial_1.vehicle_id = id;
        vechial_1.vehicle_model = model;
        vechial_1.vehicle_motornumber = motornum;
        vechial_1.vehicle_chasea_number = chasea;
        vechial_1.vehicle_manufacture_id = manufacture_id;
        vechial_1.vehicle_owner = add;
        vechial_1.vehicle_color = color;
        vehicles.push(vechial_1);
    }

    function edit_vehicle(address add, uint id, uint manufacture_id, string memory model, string memory motornum, string memory chasea, string memory color) public returns (bool)
    {
        bool ok = false;
        for (uint i = 0; i < manufactures.length; i++) {
            if (compareAdresses(msg.sender, manufactures[i].manufacture_address)) {
                ok = true;
            }
        }
        require(ok == true, "Sorry Only A Manufacture Can Edit A vechial !");
        for (uint i = 0; i < vehicles.length; i++) {
            if (compareUint(id, vehicles[i].vehicle_id)) {
                vehicles[i].vehicle_id = id;
                vehicles[i].vehicle_model = model;
                vehicles[i].vehicle_motornumber = motornum;
                vehicles[i].vehicle_chasea_number = chasea;
                vehicles[i].vehicle_manufacture_id = manufacture_id;
                vehicles[i].vehicle_owner = add;
                vehicles[i].vehicle_color = color;
                return true;
            }
        }
        return false;

    }

    function delete_vehicle(uint id) public returns (bool)
    {
        bool ok = false;
        for (uint i = 0; i < manufactures.length; i++) {
            if (compareAdresses(msg.sender, manufactures[i].manufacture_address)) {
                ok = true;
            }
        }
        require(ok == true, "Sorry Only A Manufacture Can Delete A vechial !");
        for (uint i = 0; i < vehicles.length; i++) {
            if (compareUint(id, vehicles[i].vehicle_id)) {
                uint index = i;
                for (uint j = index; j < vehicles.length - 1; j++) {
                    vehicles[j].vehicle_id = vehicles[j + 1].vehicle_id;
                    vehicles[j].vehicle_model = vehicles[j + 1].vehicle_model;
                    vehicles[j].vehicle_motornumber = vehicles[j + 1].vehicle_motornumber;
                    vehicles[j].vehicle_chasea_number = vehicles[j + 1].vehicle_chasea_number;
                    vehicles[j].vehicle_manufacture_id = vehicles[j + 1].vehicle_manufacture_id;
                    vehicles[j].vehicle_owner = vehicles[j + 1].vehicle_owner;
                    vehicles[j].vehicle_color = vehicles[j + 1].vehicle_color;
                }
                delete vehicles[vehicles.length - 1];
                vehicles.pop();
                return true;
            }
        }
        return false;
    }

    function change_ownership(address new_owner, uint id) public {
        for (uint i = 0; i < vehicles.length; i++) {
            if (compareUint(id, vehicles[i].vehicle_id)) {
                if (compareAdresses(msg.sender, vehicles[i].vehicle_owner)) {
                    vehicles[i].vehicle_owner = new_owner;
                }
            }
        }
        // return true if success or false
    }

    function car_change_block_status(uint id, bool blocked) public {
        bool ok = false;
        for (uint i = 0; i < banks.length; i++) {
            if (compareAdresses(msg.sender, banks[i].bank_address)) {
                ok = true;
            }
        }
        require(ok == true, "Sorry Only A Bank Can block A Car !");
        for (uint i = 0; i < vehicles.length; i++) {
            if (compareUint(id, vehicles[i].vehicle_id)) {
                vehicles[i].isBlocked = blocked;
            }
        }
    }

    modifier onlyDeployer() {
        require(msg.sender == deployer, "Access denied!");
        _;
    }
    function compareAdresses(address a, address b) public pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }

    function compareUint(uint a, uint b) public pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }

    function compareStrings(string memory a, string memory b) public pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));}
}
