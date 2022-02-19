const axios = require('axios');
var pinnedFiles = [];

// function to unpin a single file with provided hash
const removePinFromIPFS = (pinataApiKey, pinataSecretApiKey, hashToUnpin) => {
    const url = `https://api.pinata.cloud/pinning/unpin/${hashToUnpin}`;
    return axios
        .delete(url, {
            headers: {
                pinata_api_key: pinataApiKey,
                pinata_secret_api_key: pinataSecretApiKey
            }
        })
        .then(function (response) {
            console.log("Unpinned Successfully!")
        })
        .catch(function (error) {
            console.log(error);
        });
};

// Iterating through all the pins and unpinning them
const unPinFiles = (pinataApiKey, pinataSecretApiKey, pinnedFiles) => {
    for(var i=0; i<pinnedFiles.length; i++){
        removePinFromIPFS(pinataApiKey, pinataSecretApiKey , pinnedFiles[i]);
    }
    return;
}

// getting a list of pinned files and unpinning them
const userPinList = (pinataApiKey, pinataSecretApiKey) => {
    
    const url = `https://api.pinata.cloud/data/pinList?status=pinned`;
    return axios
        .get(url, {
            headers: {
                pinata_api_key: pinataApiKey,
                pinata_secret_api_key: pinataSecretApiKey
            }
        })
        .then(function (response) {
            for(var i=0; i<response.data["count"] ; i++){
                pinnedFiles.push(response.data["rows"][i]["ipfs_pin_hash"]);
            }
            console.log(pinnedFiles);
            unPinFiles(pinataApiKey, pinataSecretApiKey, pinnedFiles);
        })
        .catch(function (error) {
            console.log(error)
        });
};

// execute: userPinList(Your_Pinata_API_Key, Your_Pinata_Secret_API_Key);