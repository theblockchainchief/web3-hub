const SupplyChain = async () => {
	const supplyChain = await ethers.getContractFactory('SupplyChain')
	const supplyChainContract = await supplyChain.deploy()
	await supplyChainContract.deployed()
	console.log('Contract deployed to:', supplyChainContract.address)
}

const runSupplyChain = async () => {
	try {
		await SupplyChain()
		process.exit(0)
	} catch (error) {
		console.log(error)
		process.exit(1)
	}
}

runSupplyChain()
