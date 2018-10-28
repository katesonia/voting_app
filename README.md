# voting_app
An app for voting

**Phase 1: (current implementation)**
Every account can cast one vote.

**Phase 2:**
Only account with at least 1 DotToken can cast 1 vote, and after voting, 1 DotToken will be destroyed.

**Reference:**
https://truffleframework.com/tutorials/pet-shop

## How to install tools and login account

1. Install truffle
```
npm install -g truffle
```

2. Install Ganache
```
https://truffleframework.com/ganache
```

3. Intall MetaMask, choose custom RPC, and set it to:
```
HTTP://127.0.0.1:7545
```

4. Login one account from Ganache

## How to compile, deploy and run local server

5. Clone voting app
```
git clone https://github.com/katesonia/voting_app.git
```

6. Go to the root dir, and compile smart contract
```
truffle compile
```

7. Deploy smartcontract to your local testnet
```
truffle migrate
```

8. Run local sever
```
npm run dev
```