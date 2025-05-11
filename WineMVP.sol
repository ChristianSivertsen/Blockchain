// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract WineTraceability {

    struct WineBottle {
        string vineyardLocation;
        string grapeType;
        string cultivationDetails;
        string productionDetails;
        string distributionDetails;
        uint256 timestamp;
        address producer;
        bool exists;
    }

    mapping(string => WineBottle) public wineBottles;

    event BottleRegistered(string bottleId, address indexed producer);
    event StageUpdated(string bottleId, string stage);

    modifier onlyProducer(string memory bottleId) {
        require(wineBottles[bottleId].producer == msg.sender, "Not the bottle producer");
        _;
    }

    function registerBottle(
        string memory bottleId,
        string memory vineyardLocation,
        string memory grapeType
    ) public {
        require(!wineBottles[bottleId].exists, "Bottle already registered");

        wineBottles[bottleId] = WineBottle({
            vineyardLocation: vineyardLocation,
            grapeType: grapeType,
            cultivationDetails: "",
            productionDetails: "",
            distributionDetails: "",
            timestamp: block.timestamp,
            producer: msg.sender,
            exists: true
        });

        emit BottleRegistered(bottleId, msg.sender);
    }

    function updateCultivationDetails(string memory bottleId, string memory details)
        public onlyProducer(bottleId)
    {
        wineBottles[bottleId].cultivationDetails = details;
        emit StageUpdated(bottleId, "Cultivation");
    }

    function updateProductionDetails(string memory bottleId, string memory details)
        public onlyProducer(bottleId)
    {
        wineBottles[bottleId].productionDetails = details;
        emit StageUpdated(bottleId, "Production");
    }

    function updateDistributionDetails(string memory bottleId, string memory details)
        public onlyProducer(bottleId)
    {
        wineBottles[bottleId].distributionDetails = details;
        emit StageUpdated(bottleId, "Distribution");
    }

    function getBottleDetails(string memory bottleId)
        public view returns (
            string memory vineyardLocation,
            string memory grapeType,
            string memory cultivationDetails,
            string memory productionDetails,
            string memory distributionDetails,
            uint256 timestamp,
            address producer
        )
    {
        require(wineBottles[bottleId].exists, "Bottle not found");
        WineBottle memory wb = wineBottles[bottleId];
        return (
            wb.vineyardLocation,
            wb.grapeType,
            wb.cultivationDetails,
            wb.productionDetails,
            wb.distributionDetails,
            wb.timestamp,
            wb.producer
        );
    }
}
