//SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract VehicleSystem
{

    enum Role{
        CUSTOMER,
        MANUFACTURE,
        BANK,
        ADMIN
    }

    enum LicenseRequestType{
        FIRST_TIME_LICENSE,
        RENEWAL_LICENSE
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

    struct bank
    {
        uint user_id;
        string bank_name;
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
    }

    struct user
    {
        address user_address;
        string user_name;
        string user_email;
        string user_password;
        string user_phone;
        string user_national_id;
        Role role;
    }

    struct traffic_violation
    {
        uint vehicle_id;
        string violation_description;
        string violation_type;
    }

    struct license
    {
        uint user_id;
        uint car_id;
        string expire_at;
    }

    struct license_request
    {
        uint user_id;
        uint car_id;
        LicenseRequestType license_request_type;
        State state;
    }

    struct ban_sale_request {
        uint user_id;
        uint car_id;
        State state;
    }

    manufacture[] public manufactures;
    bank[] public banks;
    vehicle[] public vehicles;
    user[] public users;
    traffic_violation[] public traffic_violations;
    license[] public licenses;
    license_request[] public licenses_requests;
    ban_sale_request[] public ban_sale_requests;

    function register(address _user_address, string memory _user_name, string memory _user_email, string memory _user_phone, string memory _user_password, string memory _user_national_id, Role role) public returns (bool)
    {
        user memory temp_hold_user = user(_user_address, _user_name, _user_email, _user_password, _user_phone, _user_national_id, role);
        users.push(temp_hold_user);
        return true;
    }

    function login(string memory _user_email, string memory _user_password) public view returns (int)
    {
        for (uint i = 0; i < users.length; i++)
        {
            string memory user_name = users[i].user_email;
            string memory user_password = users[i].user_password;
            if (compareStrings(user_name, _user_email))
            {
                if (compareStrings(user_password, _user_password))
                {
                    return int(i);
                }
            }
        }
        return - 1;
    }

    function get_user(uint user_id) public view returns (user memory){
        return users[user_id];
    }

    function get_user_id_with_address(address _user_address) public view returns (int){
        for (uint i = 0; i < users.length; i++)
        {
            if (compareAddress(_user_address, users[i].user_address))
            {
                return int(i);
            }
        }
        return - 1;
    }

    function edit_user(uint _user_id, string memory _user_phone, string memory _user_password) public returns (bool)
    {
        for (uint i = 0; i < users.length; i++)
        {
            if (compareUint(i, _user_id))
            {
                users[i].user_password = _user_password;
                users[i].user_phone = _user_phone;
                return true;
            }
        }
        return false;
    }

    function get_users() public view returns (user[] memory){
        return users;
    }

    function users_length() public view returns (uint){
        return users.length;
    }

    function add_manufacture(uint _user_id, string memory _manufacture_name) public {
        manufacture memory _manufacture = manufacture(_user_id, _manufacture_name);
        manufactures.push(_manufacture);
    }

    function edit_manufacture(uint _manufacture_id, string memory _manufacture_name) public
    {
        for (uint i = 0; i < manufactures.length; i++)
        {
            uint current_manufacture_id = i;
            if (compareUint(current_manufacture_id, _manufacture_id))
            {
                manufactures[i].manufacture_name = _manufacture_name;
            }
        }
    }

    function get_manufactures() public view returns (manufacture[] memory){
        return manufactures;
    }

    function manufactures_length() public view returns (uint){
        return manufactures.length;
    }

    function add_bank_data(uint _user_id, string memory _name) public {
        bank memory new_bank = bank(_user_id, _name);
        banks.push(new_bank);
    }

    function edit_bank(uint _bank_id, uint _user_id, string memory _name) public
    {
        for (uint i = 0; i < banks.length; i++) {
            if (compareUint(_bank_id, i)) {
                banks[i].user_id = _user_id;
                banks[i].bank_name = _name;
            }
        }
    }

    function get_bank(uint _bank_id) public view returns (bank memory){
        return banks[_bank_id];
    }

    function get_banks() public view returns (bank[] memory){
        return banks;
    }

    function banks_length() public view returns (uint){
        return banks.length;
    }

    function add_vehicle(
        uint _manufacture_user_id,
        string memory _vehicle_name,
        string memory _vehicle_type,
        string memory _vehicle_model,
        string memory _vehicle_motor_number,
        string memory _vehicle_chase_number,
        string memory _vehicle_color,
        string memory _vehicle_production_Year,
        bool _isBlocked,
        uint _owner_id
    ) public {
        vehicle memory new_vehicle = vehicle(
            _vehicle_name,
            _vehicle_type,
            _vehicle_model,
            _vehicle_motor_number,
            _vehicle_chase_number,
            _manufacture_user_id,
            _vehicle_color,
            _vehicle_production_Year,
            _isBlocked,
            _owner_id
        );
        vehicles.push(new_vehicle);
    }

    function edit_vehicle(
        uint _vehicle_id,
        uint _owner_id,
        string memory _vehicle_color
    ) public
    {
        for (uint i = 0; i < vehicles.length; i++) {
            if (compareUint(_vehicle_id, i)) {
                vehicles[i].vehicle_color = _vehicle_color;
                vehicles[i].user_id = _owner_id;
            }
        }
    }

    function get_vehicle(uint _vehicle_id) public view returns (vehicle memory){
        return vehicles[_vehicle_id];
    }

    function get_vehicles() public view returns (vehicle[] memory){
        return vehicles;
    }

    function vehicles_length() public view returns (uint){
        return vehicles.length;
    }

    function add_license(uint _user_id, uint _car_id, string memory _expire_at) public
    {
        license memory new_license = license(_user_id, _car_id, _expire_at);
        licenses.push(new_license);
    }

    function edit_license(uint _license_id, uint _user_id) public
    {
        for (uint i = 0; i < licenses.length; i++)
        {
            if (compareUint(i, _license_id))
            {
                licenses[i].user_id = _user_id;
            }
        }
    }

    function request_to_renewal_licence(uint _license_id, uint _car_id, uint _user_id) public
    {
        for (uint i = 0; i < licenses.length; i++) {
            if (compareUint(i, _license_id)) {
                license_request memory new_license_request = license_request(_user_id, _car_id, LicenseRequestType.RENEWAL_LICENSE, State.PENDING);
                licenses_requests.push(new_license_request);
            }
        }
    }

    function request_to_first_time_licence(uint _car_id, uint _user_id) public
    {

        license_request memory new_license_request = license_request(_user_id, _car_id, LicenseRequestType.FIRST_TIME_LICENSE, State.PENDING);
        licenses_requests.push(new_license_request);
    }

    function accept_to_request_renewal_license(uint _license_request_id, uint _license_id, string memory _expire_at) public {
        for (uint i = 0; i < licenses_requests.length; i++)
        {
            if (compareUint(i, _license_request_id))
            {
                licenses_requests[i].state = State.ACCEPTED;
            }
        }
        licenses[_license_id].expire_at = _expire_at;
    }

    function accept_to_request_first_time_license(uint _license_request_id, string memory _expire_at) public {
        license_request memory current_licenses_request;
        for (uint i = 0; i < licenses_requests.length; i++)
        {
            if (compareUint(i, _license_request_id))
            {
                current_licenses_request = licenses_requests[i];
                licenses_requests[i].state = State.ACCEPTED;
            }
        }
        license memory new_license = license(current_licenses_request.user_id, current_licenses_request.car_id, _expire_at);
        licenses.push(new_license);
    }

    function reject_to_request_renewal_license(uint _license_request_id, uint _license_id, string memory _expire_at) public {
        for (uint i = 0; i < licenses_requests.length; i++)
        {
            if (compareUint(i, _license_request_id))
            {
                licenses_requests[i].state = State.REJECTED;
            }
        }
        licenses[_license_id].expire_at = _expire_at;
    }

    function reject_to_request_first_time_license(uint _license_request_id, string memory _expire_at) public {
        license_request memory current_licenses_request;
        for (uint i = 0; i < licenses_requests.length; i++)
        {
            if (compareUint(i, _license_request_id))
            {
                current_licenses_request = licenses_requests[i];
                licenses_requests[i].state = State.REJECTED;
            }
        }
        license memory new_license = license(current_licenses_request.user_id, current_licenses_request.car_id, _expire_at);
        licenses.push(new_license);
    }


    function add_traffic_violation(uint _vehicle_id, string memory _vio_type, string memory _vio_des) public
    {
        traffic_violation memory temp_violation = traffic_violation(_vehicle_id, _vio_type, _vio_des);
        traffic_violations.push(temp_violation);
    }

    function edit_traffic_violation(uint _vio_id, string memory _vio_type, string memory _vio_des) public
    {
        for (uint i = 0; i < traffic_violations.length; i++)
        {
            if (compareUint(i, _vio_id))
            {
                traffic_violations[i].violation_type = _vio_type;
                traffic_violations[i].violation_description = _vio_des;
            }
        }
    }

    function request_to_remove_ban_sale(uint _car_id, uint _user_id) public
    {

        ban_sale_request memory new_ban_sale_request = ban_sale_request(_user_id, _car_id, State.PENDING);
        ban_sale_requests.push(new_ban_sale_request);
    }

    function accept_to_request_renewal_license(uint _ban_sale_request_id, uint _car_id) public {
        for (uint i = 0; i < ban_sale_requests.length; i++)
        {
            if (compareUint(i, _ban_sale_request_id))
            {
                ban_sale_requests[i].state = State.ACCEPTED;
            }
        }
        vehicles[_car_id].isBlocked = false;
    }

    function reject_to_request_renewal_license(uint _ban_sale_request_id, uint _car_id) public {
        for (uint i = 0; i < ban_sale_requests.length; i++)
        {
            if (compareUint(i, _ban_sale_request_id))
            {
                ban_sale_requests[i].state = State.REJECTED;
            }
        }
        vehicles[_car_id].isBlocked = true;
    }


    function get_traffic_violations() public view returns (traffic_violation[] memory){
        return traffic_violations;
    }

    function get_licenses() public view returns (license[] memory){
        return licenses;
    }

    function traffic_violations_length() public view returns (uint){
        return traffic_violations.length;
    }

    function licenses_length() public view returns (uint){
        return licenses.length;
    }

    function compareAddress(address a, address b) public pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }

    function compareUint(uint a, uint b) public pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }

    function compareStrings(string memory a, string memory b) public pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
    }
}
