import './App.css';
import React,{useEffect,useState} from "react";
// import { ethers } from 'ethers';
import {getErc20Balance, safeMint, transfer, transferFrom} from "./utils/erc20Util"
import {buyWithETH} from "./utils/nftMarketUtil";

function App() {
    const [walletAddress, setWallet] = useState("");
    const [balanceof,setBalance]=useState("0");
    const [address,setAddress] = useState("0x")

    useEffect(() => {
        addWalletListener();
        getWalletAddress();

    }, [balanceof]);

    function addWalletListener() {
        if (window.ethereum) {
            window.ethereum.on("accountsChanged", (accounts) => {
                if (accounts.length > 0) {
                    setWallet(accounts[0]);
                } else {
                    setWallet("");
                }
            });
        }
    }

    const getWalletAddress = async () => {
        if (window.ethereum) {
            try {
                const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
                setWallet(accounts[0]); // Set the first account as the connected account
            } catch (error) {
                console.error('Error connecting to wallet:', error);
            }
        }
    };
    const balanceQuery = async () => {
        let balance = await getErc20Balance(walletAddress)
        setBalance(balance.toString())
    }
    const mint = async () => {
        let ethereumAddressRegex = /^(0x)?[0-9a-fA-F]{40}$/;
        if (ethereumAddressRegex.test(address))
        await safeMint(address)
        else {
            window.alert("请输入正确的以太坊地址")
        }
    }

    const transFerValue = async () => {
     await transfer("0x5E0ff5E6EE4B77A5b2f7633257EF0F2161917d1f","10000000")
    }

    const transFerFromValue = async () => {
        await transferFrom(walletAddress,"0x5E0ff5E6EE4B77A5b2f7633257EF0F2161917d1f","10000000")
    }
    const buyNFT = async () => {
      await buyWithETH(0)
    }



  return (
    <div>
        <input value={address} onChange={(e)=>{setAddress(e.target.value)}} />
       <br/>
       address:{address}
      <button onClick={mint}>erc20发币</button>
        <br/>
      <button onClick={balanceQuery}>erc20查看余额</button>
        <br/>
        erc20余额:{balanceof}
        <br/>
        <button onClick={transFerValue}>交易</button>
        <button onClick={transFerFromValue}>代交易</button>
        <p>Account Address: {walletAddress}</p><br/>
        <button onClick={buyNFT}>购买NFT</button>
    </div>
  );
}

export default App;
