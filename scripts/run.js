const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory('DogNStyleNFT');
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);

  // Call the function.
  let txn = await nftContract.makeDogNStyleNFT()
  // Wait for it to be mined.
  await txn.wait()

  let nftMinted = await nftContract.getTotalNFTMinted()
  console.log(nftMinted.toString())

  // Mint another NFT for fun.
  txn = await nftContract.makeDogNStyleNFT()
  // Wait for it to be mined.
  await txn.wait()
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();