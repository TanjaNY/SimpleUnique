const simpleunique = artifacts.require('./SimpleUnique');

module.exports = function(deployer) {
	deployer.deploy(simpleunique);
	deployer.deploy(simpleunique,"NodeAndCode","SMPU");
};
