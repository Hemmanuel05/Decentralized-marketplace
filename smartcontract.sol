pragma solidity ^0.8.0;

contract DecentralizedMarketplace {
    // Mapping of digital assets to their owners
    mapping(address => mapping(uint256 => Asset)) public assets;

    // Struct to represent a digital asset
    struct Asset {
        uint256 id;
        string name;
        uint256 price;
        bool isForSale;
        address owner;
    }

    // Event emitted when a new asset is created
    event NewAsset(uint256 id, string name, uint256 price);

    // Event emitted when an asset is listed for sale
    event AssetListed(uint256 id, uint256 price);

    // Event emitted when an asset is sold
    event AssetSold(uint256 id, address buyer, uint256 price);

    // Event emitted when an asset is transferred
    event AssetTransferred(uint256 id, address from, address to);

    // Function to create a new digital asset
    function createAsset(uint256 _id, string memory _name, uint256 _price) public {
        // Create a new asset and add it to the mapping
        assets[msg.sender][_id] = Asset(_id, _name, _price, false, msg.sender);

        // Emit the NewAsset event
        emit NewAsset(_id, _name, _price);
    }

    // Function to list an asset for sale
    function listAssetForSale(uint256 _id, uint256 _price) public {
        // Check if the asset exists and is owned by the sender
        require(assets[msg.sender][_id].id == _id, "Asset does not exist or is not owned by sender");

        // Update the asset's price and for-sale status
        assets[msg.sender][_id].price = _price;
        assets[msg.sender][_id].isForSale = true;

        // Emit the AssetListed event
        emit AssetListed(_id, _price);
    }

    // Function to buy an asset
    function buyAsset(uint256 _id) public payable {
        // Check if the asset exists, is for sale, and the sender has enough ether
        require(assets[msg.sender][_id].id == _id, "Asset does not exist");
        require(assets[msg.sender][_id].isForSale, "Asset is not for sale");
        require(msg.value >= assets[msg.sender][_id].price, "Insufficient ether");

        // Transfer the asset ownership and update the for-sale status
        assets[msg.sender][_id].isForSale = false;
        assets[msg.sender][_id].owner = msg.sender;

        // Transfer the ether to the seller
        payable(assets[msg.sender][_id].owner).transfer(msg.value);

        // Emit the AssetSold event
        emit AssetSold(_id, msg.sender, msg.value);
    }

    // Function to transfer an asset
    function transferAsset(uint256 _id, address _to) public {
        // Check if the asset exists and is owned by the sender
        require(assets[msg.sender][_id].id == _id, "Asset does not exist or is not owned by sender");

        // Update the asset's ownership
        assets[msg.sender][_id].owner = _to;

        // Emit the AssetTransferred event
        emit AssetTransferred(_id, msg.sender, _to);
    }
}