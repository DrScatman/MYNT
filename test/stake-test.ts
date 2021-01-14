// import { ethers } from "hardhat";
// import { expect, assert } from "chai";

// describe("Stake", function () {
//   it("Should return the new stake", async function () {
//     const UniswapRouter = await ethers.getContractFactory("UniswapV2Router02");
//     const WiseToken = await ethers.getContractFactory("WiseToken");
//     const uniswapRouter = await UniswapRouter.deploy(
//       "0x57079e0d0657890218C630DA5248A1103a1b4ad0",
//       "0xEb59fE75AC86dF3997A990EDe100b90DDCf9a826"
//     );
//     const wiseToken = await WiseToken.deploy();

//     await uniswapRouter.deployed();
//     await wiseToken.deployed();
//     const [owner, addr1] = await ethers.getSigners();

//     console.log(uniswapRouter.address);
//     await wiseToken.createStakeWithETH(1, wiseToken.address);
//     await wiseToken;
//   });
// });
