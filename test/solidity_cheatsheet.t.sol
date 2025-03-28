// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "../src/solidity_cheatsheet.sol";

contract solidity_cheatsheetTest is Test {
    solidity_cheatsheet public c;
    address public deployer = 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496;

    function setUp() public {
        c = new solidity_cheatsheet{value: 1.5 ether}();
    }

    function test_bigNumber() public {
        assertEq(c.bigNumber(), 115792089237316195423570985008687907853269984665640564039457584007913129639935);
    }
    
    function test_fallback() public {
        // bytes memory payload = "0x93824";
        string memory payload = "lksdfj";
        bytes memory shipment = abi.encode(payload);
        (bool success,bytes memory res) = address(c).call{value: 100 wei}(shipment); 
        require(success);
        assertEq(res, "lksdfj_done");
    }

    
    function test_name() public {
        // console log output from name 
        console2.log(c.name());
    }

    function test_getter_for_array_returns_full_array() public {
        assertEq(c.fixed_integer_array(0), 1);
    }

    
}
