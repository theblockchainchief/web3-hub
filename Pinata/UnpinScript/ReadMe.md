# JS script to unpin all files from pinata ipfs

Added a JS script file (unpin.js) that can be used to unpin all the files from Pinata IPFS using a function where the user needs to pass on their Pinata API Key and Pinata API secret Key.

## How this is built

- To interact with Pinata API through JavaScript, axios npm library is being used
- The function **userPinList** fetches all the records for the content currently pinned by passing the pinataApiKey and pinataSecretApiKey, stores the ipfs_pin_hash for each pinned file
in a list (pinnedFiles) and calls the function **unPinFiles** to unpin all the files.
- In the function **removePinFromIPFS**, we pass in the pin we wish to remove from Pinata and set it as the value for the "hashToUnpin" key in our request URL. This function is used to unpin a single file.
- The function **unPinFiles** iterates overs the list of the CID's of pinned files and unpins each file using removePinFromIPFS function.

## Tech Stack Used

- JavaScript
- axios npm library

## Steps to Run

Just call the function **userPinList** from the script by passing the user's pinataApiKey and pinataSecretApiKey as arguments.

## Output Screenshots(Required)

![image](https://user-images.githubusercontent.com/64766655/154789739-3dec7719-aa86-4bd1-b3d1-f9ffe9ca6f8c.png)

