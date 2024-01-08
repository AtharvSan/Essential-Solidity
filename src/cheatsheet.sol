// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
// pragma abicoder v2;

import {parent} from "./parent.sol";

contract Cheatsheet is parent {
    /////////////////////////
    // value type are 6
    /* 1 */bool public flag = true;
    /* 2 */uint256 public x = 1e2; // 1_00 also valid
    /* 3 */address public owner; address payable public client;
    /* 4 */proxy user;
    /* 5 */bytes4 public selector = 0x1a1b1c1d;// 2 hex char needs 1 byte
           bytes8 public selector1 = "1a1b1c1d";// 1 string char needs 1 byte(utf-8bits)
           bytes16 public selector2 = unicode"text";
           bytes32 public hashed = keccak256("chewale");
    /* 6 */enum male{alpha, beta, sigma}
           male ceo = male.sigma;
    
    /////////////////////////
    // reference type are 
    /* 1 */struct office {
                string brandName;
                uint256 funding;
                // male candidate;
                bool recomendation;
           }
           office public diffusionLabs = office({brandName:"diffusion labs", funding:1_000_000, recomendation:true});
    /* 2.1 */string public name = "ath" "arva";//multiple string with space are concatenated
    /* 2.2 */bytes public about = "solidity developer";
             bytes public about2 = hex"1b1b1b1b1b1b";
             bytes public about3 = unicode"1000";
    /* 2.3 */uint256[3] public list = [11,12,13]; //slices still remaining
             uint256[] public list2 = [21,22,23];
    /* 5 */mapping(string=>uint256) public table;
    
    function initialize_struct_diffusionLabs() public{
        diffusionLabs.brandName = "diffusion labs";
        diffusionLabs.funding= 1_000_000;
        diffusionLabs.recomendation= true;
    }    

    event newOwner(address indexed owner);
        
    error gadbad();

    constructor() parent() payable {
        owner = msg.sender;
        emit newOwner(owner);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    receive() external payable {}

    fallback(bytes calldata _shipment) external payable returns(bytes memory){
        string memory payload = abi.decode(_shipment,(string));
        return bytes(string.concat(payload, "_done"));
    }

    function update_x(uint256 amt) public {
        // if (!flag) { revert gadbad();}
        x = amt;
    }
    function toggleFlag() public onlyOwner {
        flag = !flag;
    }

    function ternary_on_x() public {
        !flag ? x++ : x-- ;
    }

    function update_list() public {
        uint256 l2= list2.length;
        for(uint256 i=0;i<l2;i++) {
            list2.push(list2[i]*2);
        }
        uint256 l= list.length;
        for(uint256 i=0;i<l;i++) {
            delete list[i];
        }
    }

    uint256 public oneWei = 1 wei;
    bool public isOneWei = (1 wei == 1);// 1 wei is equal to 1

    uint256 public oneEther = 1 ether;
    bool public isOneEther = (1 ether == 1e18);// 1 ether is equal to 10^18 wei

    uint256 tame = 1 ;
}

contract proxy {
    bool public flag = true;
    uint256 public x;

    constructor() payable {}

    function delegatecall_to_fallback(
            address c
        ) public returns (bool success,bytes memory data) {
        string memory payload = "random data";
        bytes memory shipment = abi.encode(payload);
        (success, data) = c.delegatecall(shipment);
        require(success);
    }

    function delegatecall_to_update_x(
            address c
        ) public returns (bool success,bytes memory data) {
        bytes memory fnshipment = abi.encodeWithSelector(Cheatsheet.update_x.selector, 500);
        (success, data) = c.delegatecall(fnshipment);
        require(success);
    }

    function call_to_update_x(address c) public returns (bool success,bytes memory data){
        bytes memory fnshipment = abi.encodeWithSelector(Cheatsheet.update_x.selector, 500);
        (success, data) = c.call(fnshipment);
        require(success);
    }

}