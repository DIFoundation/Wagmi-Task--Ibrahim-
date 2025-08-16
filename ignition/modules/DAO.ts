import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const address1 = "0x6Cac76f9e8d6F55b3823D8aEADEad970a5441b67";
const address2 = "0x6Cac76f9e8d6F55b3823D8aEADEad970a5441b67";
const address3 = "0x6Cac76f9e8d6F55b3823D8aEADEad970a5441b67";

const LockModule = buildModule("LockModule", (m) => {
  const daoSC = m.contract("DAO", [address1, address2, address3]);

  return { daoSC };
});

export default LockModule;
