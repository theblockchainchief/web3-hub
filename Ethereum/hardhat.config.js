require('@nomiclabs/hardhat-waffle')
require('dotenv').config()

module.exports = {
	defaultNetwork: 'hardhat',
	networks: {
		hardhat: {},
		localhost: {},
	},
	solidity: {
		compilers: [
			{
				version: '0.8.7',
			},
			{
				version: '0.8.3',
			},
			{
				version: '0.6.6',
			},
			{
				version: '0.4.24',
			},
		],
	},
	mocha: {
		timeout: 300000,
	},
}
