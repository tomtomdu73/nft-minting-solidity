pragma solidity 0.8.0;

// We need some util functions for strings.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";

contract DogNStyleNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
  // So, we make a baseSvg variable here that all our NFTs can use.
  string svgPart1 = '<svg height="200px" viewBox="-26 -12 120 120" width="200px" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><defs><clipPath id="a"><path d="M200.717,629.505c-.18-4.393-1.786-3.772-3.649-2.408-.944.691-2.627,1.605-2.846,2.408s1.533,1.532,3.248,1.532C200.352,631.037,200.754,630.4,200.717,629.505Z" fill="none"/></clipPath><clipPath id="b"><path d="M215.5,629.505c.18-4.393,1.786-3.772,3.649-2.408.944.691,2.627,1.605,2.846,2.408s-1.533,1.532-3.248,1.532C215.866,631.037,215.464,630.4,215.5,629.505Z" fill="none"/></clipPath></defs><g transform="translate(-173.628 -605.862)"><path d="M190.406,619.808a16.418,16.418,0,0,0-4.248,7.15c-1.478,4.755-6.1,11.757-9.051,18.876s-.924,20.13-.554,25.077-4.987,15.475-2.032,22.864,19.461,12.854,21.09,1.871.706-26.633,1.075-32.261-3.273-21.429-3.391-24.889S190.406,619.808,190.406,619.808Z" fill="';
  string svgPart2 = '"/><path d="M195.611,695.646c1.629-10.984.706-26.633,1.075-32.261s-3.273-21.429-3.391-24.889c-.013-.37-.057-.882-.124-1.489l-3.33-1.607s2.165,15.522,2.442,25.127c.253,8.751,2.343,33.449.618,39.969A6.93,6.93,0,0,0,195.611,695.646Z" fill="';
  string svgPart3 = '"/><path d="M208.107,605.862c-11.363,0-14.76,5.463-16.864,9.931s-3.272,10.84-3.272,17.074,2.3,6.513,4.89,18.91,2.265,20.571,6.31,21.818a34.927,34.927,0,0,0,8.936,1.225Z" fill="';
  string svgPart4 = '"/><path d="M202.3,666.964s.228,6.891,0,13.8,1.886,9.552,5.816,9.552V666.068Z" fill="#f37777"/><path d="M208.107,664.933a7.361,7.361,0,0,1-2.029,5.158c-2.3,2.673-2.158,5.677-6.591,4.729s-6.65-9.314-4.156-14.828,2.215-10.646,5.748-15.492,5.473-8.49,5.473-17.542-10.456-19.569,1.564-20Z" fill="';
  string svgPart5 = '"/><path d="M200.717,629.505c-.18-4.393-1.786-3.772-3.649-2.408-.944.691-2.627,1.605-2.846,2.408s1.533,1.532,3.248,1.532C200.352,631.037,200.754,630.4,200.717,629.505Z" fill="#f5f1db"/><g clip-path="url(#a)"><ellipse cx="2.365" cy="2.439" fill="#a05132" rx="2.365" ry="2.439" transform="translate(195.5 626.059)"/><ellipse cx="1.428" cy="1.472" fill="#3d2a2e" rx="1.428" ry="1.472" transform="translate(196.437 627.025)"/><ellipse cx="0.441" cy="0.454" fill="#fbfcfc" rx="0.441" ry="0.454" transform="translate(196.296 627.194)"/></g><path d="M208.116,651.846c-3.642,0-7.208,5.606-7.037,6.763s7.037,1.383,7.037,1.383Z" fill="';
  string svgPart6 = '"/><path d="M208.107,656.2s-7.028-.753-7.028,2.41,3.966,6.324,7.028,6.324Z" fill="#4c383d"/><path d="M204.593,662.373s-2.761-2.56-.954-2.71S207.572,664.064,204.593,662.373Z" fill="#3d2a2e"/><path d="M193.684,624.845c.476.344,5.051-2.411,6.334-2.285s1.792,2.348,2.3,2.6-.063-2.919-1.205-4.125-1.97.191-3.65,1.27S192.984,624.337,193.684,624.845Z" fill="';
  string svgPart7 = '"/><path d="M225.812,619.808a16.425,16.425,0,0,1,4.249,7.15c1.477,4.755,6.1,11.757,9.05,18.876s.924,20.13.554,25.077,4.988,15.475,2.032,22.864-19.461,12.854-21.09,1.871-.705-26.633-1.075-32.261,3.273-21.429,3.391-24.889S225.812,619.808,225.812,619.808Z" fill="';
  string svgPart8 = '"/><path d="M220.607,695.646c-1.629-10.984-.705-26.633-1.075-32.261s3.273-21.429,3.391-24.889c.013-.37.058-.882.124-1.489l3.33-1.607s-2.165,15.522-2.442,25.127c-.253,8.751-2.343,33.449-.618,39.969A6.93,6.93,0,0,1,220.607,695.646Z" fill="';
  string svgPart9 = '"/><path d="M208.112,605.862c11.362,0,14.76,5.463,16.863,9.931s3.272,10.84,3.272,17.074-2.3,6.513-4.89,18.91-2.265,20.571-6.31,21.818a34.917,34.917,0,0,1-8.935,1.225Z" fill="';
  string svgPart10 = '"/><path d="M213.918,666.964s-.227,6.891,0,13.8-1.885,9.552-5.816,9.552V666.068Z" fill="#f37777"/><path d="M208.112,664.933a7.363,7.363,0,0,0,2.028,5.158c2.3,2.673,2.158,5.677,6.591,4.729s6.65-9.314,4.156-14.828-2.215-10.646-5.748-15.492-5.473-8.49-5.473-17.542,10.456-19.569-1.564-20Z" fill="';
  string svgPart11 = '"/><path d="M215.5,629.505c.18-4.393,1.786-3.772,3.649-2.408.944.691,2.627,1.605,2.846,2.408s-1.533,1.532-3.248,1.532C215.866,631.037,215.464,630.4,215.5,629.505Z" fill="#f5f1db"/><g clip-path="url(#b)"><ellipse cx="2.365" cy="2.439" fill="#a05132" rx="2.365" ry="2.439" transform="translate(215.989 626.059)"/><ellipse cx="1.428" cy="1.472" fill="#3d2a2e" rx="1.428" ry="1.472" transform="translate(216.926 627.025)"/><ellipse cx="0.441" cy="0.454" fill="#fbfcfc" rx="0.441" ry="0.454" transform="translate(219.04 627.194)"/></g><path d="M208.1,651.846c3.642,0,7.208,5.606,7.037,6.763s-7.037,1.383-7.037,1.383Z" fill="';
  string svgPart12 = '"/><path d="M208.112,656.2s7.027-.753,7.027,2.41-3.965,6.324-7.027,6.324Z" fill="#4c383d"/><path d="M211.625,662.373s2.761-2.56.954-2.71S208.647,664.064,211.625,662.373Z" fill="#3d2a2e"/><path d="M222.534,624.845c-.475.344-5.05-2.411-6.334-2.285s-1.791,2.348-2.3,2.6.063-2.919,1.206-4.125,1.969.191,3.65,1.27S223.235,624.337,222.534,624.845Z" fill="';


  // I create three arrays, each with their own theme of random words.
  // Pick some random funny words, names of anime characters, foods you like, whatever! 
  string[] darkEarColorA = ["#5cd119", "#bf1ed8", "#19ccd6", "#d33017"];
  string[] earColorA = ["#73E831", "#d13ee8", "#2cdee8", "#dd452e"];
  string[] skinColorA = ["#7c512f", "#c48321", "#6d4305", "#382913"];
  string[] lightSkinColorA = ["#f5f1db", "#d3ba94", "#c9c1b5"];

  event NewDogNFTTMinted(address sender, uint256 tokenId);

  constructor() ERC721 ("Dog n' Style", "DOGNSTYLE") {
    console.log("This is my NFT contract. Woah!");
  }

  // I create a function to randomly pick a word from each array.
  function pickEarColor(uint256 tokenId) public view returns (uint256) {
    // I seed the random generator. More on this in the lesson. 
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
    return rand % earColorA.length;
  }

  function pickSkinColor(uint256 tokenId) public view returns (uint256) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    return rand = rand % skinColorA.length;
  }

  function pickLightSkinColor(uint256 tokenId) public view returns (uint256) {
    uint256 rand = random(string(abi.encodePacked("THIRDOIOI_WORD", Strings.toString(tokenId))));
    return rand = rand % lightSkinColorA.length;
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  function getTotalNFTMinted() public view returns (uint256){
    uint256 newItemId = _tokenIds.current();
    return newItemId;
  }

  // Mint an NFT
  function makeDogNStyleNFT() public {
    uint256 newItemId = _tokenIds.current();

    require(
        newItemId+1 <= 50,
        "You cannot mint more than 50 dogs"
    );

    uint256 number1 = pickEarColor(newItemId);
    uint256 number2 = pickSkinColor(newItemId);
    uint256 number3 = pickLightSkinColor(newItemId);

    // We go and randomly grab one word from each of the three arrays.
    string memory earColor = earColorA[number1];
    string memory darkEarColor = darkEarColorA[number1];
    string memory skinColor = skinColorA[number2];
    string memory lightSkinColor = lightSkinColorA[number3];

    // I concatenate it all together, and then close the <text> and <svg> tags.
    string memory finalSvg1 = string(abi.encodePacked(svgPart1, earColor, svgPart2, darkEarColor, svgPart3, skinColor, svgPart4, lightSkinColor, svgPart5, skinColor, svgPart6, earColor));
    string memory finalSvg2 = string(abi.encodePacked(svgPart7, earColor, svgPart8, darkEarColor, svgPart9, skinColor, svgPart10, lightSkinColor, svgPart11, skinColor));
    string memory finalSvg3 = string(abi.encodePacked(svgPart12, earColor, '"/></g></svg>'));
    string memory finalSvg = string(abi.encodePacked(finalSvg1, finalSvg2, finalSvg3));

    // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    string(abi.encodePacked('Dog # ', Strings.toString(newItemId+1))),
                    '", "description": "A collection of Dogs with Style.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log(finalTokenUri);

    _safeMint(msg.sender, newItemId);
  
    // We'll be setting the tokenURI later!
    _setTokenURI(newItemId, finalTokenUri);
  
    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    emit NewDogNFTTMinted(msg.sender, newItemId);
  }
}