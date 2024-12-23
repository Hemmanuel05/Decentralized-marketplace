// Import Web3 library
const Web3 = require('web3');

// Set up Web3 provider
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));

// Set up contract ABI and address
const contractAbi = [...]; // Replace with the contract ABI
const contractAddress = '0x...'; // Replace with the contract address

// Set up contract instance
const contract = new web3.eth.Contract(contractAbi, contractAddress);

// Get assets for sale
contract.methods.getAssetsForSale().call()
    .then((assets) => {
        const assetsList = document.getElementById('assets-list');
        assets.forEach((asset) => {
            const listItem = document.createElement('li');
            listItem.textContent = `${asset.name} - ${asset.price} ETH`;
            assetsList.appendChild(listItem);
        });
    })
    .catch((error) => {
        console.error(error);
    });

// Create asset form submission handler
document.getElementById('create-asset-form').addEventListener('submit', (event) => {
    event.preventDefault();

    const assetName = document.getElementById('asset-name').value;
    const assetPrice = document.getElementById('asset-price').value;

    contract.methods.createAsset(assetName, assetPrice).send({ from: web3.eth.accounts[0] })
        .then((receipt) => {
            console.log(receipt);
        })
        .catch((error) => {
            console.error(error);
        });
});