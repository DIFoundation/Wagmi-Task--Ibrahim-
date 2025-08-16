import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre from "hardhat";

describe("Lock", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployDAOContract() {
    
    const [address1, address2, address3, address4] = await hre.ethers.getSigners();

    const Lock = await hre.ethers.getContractFactory("DAO");
    const lock = await Lock.deploy(address1.address, address2.address, address3.address);

    return { lock, address1, address2, address3, address4 };
  }

  describe("Deployment", function () {
    it("Should set new member", async function () {
      const { lock, address1, address2, address3, address4 } = await loadFixture(deployDAOContract);

      const joinAddress = await lock.joinDAO(address4);

      expect(joinAddress).to.equal(address4.address);
    });

    it("Should revert for existing member", async function () {
      const { lock, address1, address2, address3, address4 } = await loadFixture(deployDAOContract);

      const reJoinAddress = await lock.joinDAO(address2.address);

      expect(reJoinAddress).to.revertedWith("Already a member");
    });
  });
});
