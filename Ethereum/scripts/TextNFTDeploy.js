const TextNFT = async () => {
	const nftContractFactory = await ethers.getContractFactory('TextNFT')
	const nftContract = await nftContractFactory.deploy()
	await nftContract.deployed()
	console.log('Contract deployed to:', nftContract.address)
}

const runMain = async () => {
	try {
		await TextNFT()
		process.exit(0)
	} catch (error) {
		console.log(error)
		process.exit(1)
	}
}

runMain()
