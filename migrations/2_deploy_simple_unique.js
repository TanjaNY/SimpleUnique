const simpleunique = artifacts.require('./SimpleUnique');

module.exports = function(deployer) {
	deployer.deploy(simpleunique);
};
