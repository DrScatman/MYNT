import React, { useContext, useState } from "react";
import { WiseTokenContext } from "./../../hardhat/SymfoniContext";

interface Props {}

export const Stake: React.FC<Props> = () => {
  const wiseToken = useContext(WiseTokenContext);
  const [ethAddr, setEthAddr] = useState(
    "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
  );
  const ethereum = window.ethereum;
  if (ethereum) {
    ethereum.on("accountsChanged", function (accounts: [string]) {
      setEthAddr(accounts[0]);
    });
  }
  const createStake = async (
    e: React.MouseEvent<HTMLButtonElement, MouseEvent>
  ) => {
    e.preventDefault();
    if (wiseToken.instance) {
      const tx = await wiseToken.instance.createStakeWithToken(
        ethAddr, // wallet addr
        1, // amount
        1, // stake days
        wiseToken.instance.address // referer addr
      );
      console.log("WiseToken tx", tx);
      await tx.wait();
      console.log("New stake mined, result: ", await wiseToken.instance);
    } else {
      throw Error("WiseToken instance not ready");
    }
  };

  return (
    <div>
      <p>{ethAddr}</p>
      <button onClick={(e) => createStake(e)}>Create Stake</button>
    </div>
  );
};
