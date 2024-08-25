const PropertyOwnership = artifacts.require("PropertyOwnership");

contract("PropertyOwnership", (accounts) => {
  let instance;

  before(async () => {
    instance = await PropertyOwnership.deployed();
  });

  it("should register a property", async () => {
    await instance.registerProperty("1234 Elm Street", { from: accounts[0] });
    const property = await instance.getProperty(0);
    assert.equal(property.location, "1234 Elm Street", "Property location should match");
    assert.equal(property.owner, accounts[0], "Property owner should match");
  });

  it("should transfer property ownership", async () => {
    await instance.transferOwnership(0, accounts[1], { from: accounts[0] });
    const property = await instance.getProperty(0);
    assert.equal(property.owner, accounts[1], "Property owner should match the new owner");
  });

  it("should list property for sale", async () => {
    await instance.listPropertyForSale(0, true, { from: accounts[1] });
    const property = await instance.getProperty(0);
    assert.equal(property.isForSale, true, "Property should be listed for sale");
  });

  it("should return the correct properties for an owner", async () => {
    const properties = await instance.getOwnerProperties(accounts[1]);
    assert.equal(properties.length, 1, "Owner should have one property");
    assert.equal(properties[0].toNumber(), 0, "Property ID should match");
  });
});
