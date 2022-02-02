# Bank : Smart Contract

Here is a simple bank smart contract where you can 
1. Create Account 
2. Deposit Ether & convert to account balance
3. Withdraw from account balance
4. Transfer Ether (Within Bank)
5. Check account balance & details.

After You request for amount withdrawl, your `available balance` will be reduced by the amount you requested & `pending balance` will be the previous `available balance` + the amount you requested until the transaction is approved by the bank else it will be reverted back to your account. (Just Like : NEFT, RTGS)

`Note:` All deposit ethers are stored & withdrawl are done the `Bank's` ether address. (Just like real banks collects your physical currency & in return they give you the same currency in digital form as account balance.) 

---
## Tech Stack:
1. Ethereum
2. Solidity
3. Remix IDE
---
## Compile & Deploy:

1. Open **`Remix` IDE** from [here](https://remix.ethereum.org/).
2. Click on `Sure` and then `Done`.
3. Under `default_workshop`, click on `create new file`.
4. Rename it as `Bank.sol`.

Now, click on the `Solidity Compile` option in the left sidebar.

5. Select compiler version `0.5.16+`
6. Then click on `Bank.sol`

Click on the `Deploy & Run Transactions` option in the left sidebar.

7. Choose `Environment` > `JavaScript VM (London)`
8. Now click on `Deploy`

---

## Screenshots: 
### 1. Account Created : 
<img width="1229" alt="Account Created" src="https://user-images.githubusercontent.com/82683890/152252531-77a3b8d9-0cf8-4d63-8cc7-f43fbc5e5d76.png">

### 2. Deposit Ether : 
<img width="1229" alt="Ether Deposit" src="https://user-images.githubusercontent.com/82683890/152252529-2cb3a979-7a02-4901-b343-e3eec63c9f95.png">

### 3. Account Balance & Details :
<img width="1229" alt="Account Details" src="https://user-images.githubusercontent.com/82683890/152252527-63a965c5-d187-4384-a9c1-592692b9456d.png">

### 4. Withdraw Request :
<img width="1229" alt="Screenshot 2022-02-03 at 4 32 30 AM" src="https://user-images.githubusercontent.com/82683890/152252525-53d86269-81d2-4757-b526-85ae32703e15.png">

>#### After Withdrawl Request Account Balance :
><img width="1229" alt="Screenshot 2022-02-03 at 4 32 45 AM" src="https://user-images.githubusercontent.com/82683890/152252518-d938e672-6c1d-4548-beac-3511c79ea127.png">

### Approve Withdraw Request by Bank :
<img width="1229" alt="Screenshot 2022-02-03 at 4 33 27 AM" src="https://user-images.githubusercontent.com/82683890/152252514-b59d67d1-cc6a-42a9-a804-828cf7841749.png">

>#### After approval Account Balance :
><img width="1229" alt="Screenshot 2022-02-03 at 4 33 56 AM" src="https://user-images.githubusercontent.com/82683890/152252501-8532ee5d-c5e4-46b8-a3c8-f0eaddf857d5.png">



