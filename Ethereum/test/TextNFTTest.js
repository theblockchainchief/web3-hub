const { assert } = require('chai')

describe('TextNFT Contract', async () => {
	let nft
	let nftContractAddress
	let tokenId

	// Deploys the TextNFT contract and the EternalMarket contract before each test
	beforeEach('Setup Contract', async () => {
		const TextNFT = await ethers.getContractFactory('TextNFT')
		nft = await TextNFT.deploy()
		await nft.deployed()
		nftContractAddress = await nft.address
	})

	// Tests address for the TextNFT contract
	it('Should have an address', async () => {
		assert.notEqual(nftContractAddress, 0x0)
		assert.notEqual(nftContractAddress, '')
		assert.notEqual(nftContractAddress, null)
		assert.notEqual(nftContractAddress, undefined)
	})

	// Tests name for the token of TextNFT contract
	it('Should have a name', async () => {
		// Returns the name of the token
		const name = await nft.collectionName()

		assert.equal(name, 'TextNFT')
	})

	// Tests symbol for the token of TextNFT contract
	it('Should have a symbol', async () => {
		// Returns the symbol of the token
		const symbol = await nft.collectionSymbol()

		assert.equal(symbol, 'TNFT')
	})

	// Tests for NFT minting function of TextNFT contract using tokenID of the minted NFT
	it('Should be able to mint NFT', async () => {
		// Mints a NFT
		let txn = await nft.createTextNFT()
		let tx = await txn.wait()

		// tokenID of the minted NFT
		let event = tx.events[0]
		let value = event.args[2]
		tokenId = value.toNumber()

		assert.equal(tokenId, 0)

		// Mints another NFT
		txn = await nft.createTextNFT()
		tx = await txn.wait()

		// tokenID of the minted NFT
		event = tx.events[0]
		value = event.args[2]
		tokenId = value.toNumber()

		assert.equal(tokenId, 1)
	})
})
