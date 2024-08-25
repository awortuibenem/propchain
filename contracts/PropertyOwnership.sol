// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PropertyOwnership {
    struct Property {
        uint256 id;
        string location;
        address owner;
        bool isForSale;
    }

    mapping(uint256 => Property) public properties;
    mapping(address => uint256[]) public ownerToProperties;

    uint256 public nextPropertyId;

    event PropertyRegistered(uint256 id, string location, address owner);
    event PropertyTransferred(uint256 id, address newOwner);
    event PropertyListedForSale(uint256 id, bool isForSale);

    function registerProperty(string memory _location) public {
        uint256 propertyId = nextPropertyId++;
        properties[propertyId] = Property(propertyId, _location, msg.sender, false);
        ownerToProperties[msg.sender].push(propertyId);

        emit PropertyRegistered(propertyId, _location, msg.sender);
    }

    function transferOwnership(uint256 _id, address _newOwner) public {
        require(properties[_id].owner == msg.sender, "Only the owner can transfer");
        properties[_id].owner = _newOwner;
        properties[_id].isForSale = false;

        // Remove property from current owner
        removePropertyFromOwner(msg.sender, _id);
        // Add property to new owner
        ownerToProperties[_newOwner].push(_id);

        emit PropertyTransferred(_id, _newOwner);
    }

    function listPropertyForSale(uint256 _id, bool _isForSale) public {
        require(properties[_id].owner == msg.sender, "Only the owner can list for sale");
        properties[_id].isForSale = _isForSale;

        emit PropertyListedForSale(_id, _isForSale);
    }

    function removePropertyFromOwner(address _owner, uint256 _id) internal {
        uint256[] storage propertyIds = ownerToProperties[_owner];
        for (uint256 i = 0; i < propertyIds.length; i++) {
            if (propertyIds[i] == _id) {
                propertyIds[i] = propertyIds[propertyIds.length - 1];
                propertyIds.pop();
                break;
            }
        }
    }

    function getOwnerProperties(address _owner) public view returns (uint256[] memory) {
        return ownerToProperties[_owner];
    }

    function getProperty(uint256 _id) public view returns (Property memory) {
        return properties[_id];
    }
}
