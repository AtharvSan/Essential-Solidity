// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Cheatsheet} from "../src/Cheatsheet.sol";
import {proxy} from "../src/Cheatsheet.sol";

contract CheatsheetTest is Test {
    Cheatsheet public c;
    proxy public p;
    address public deployer = 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496;
    // enum male{alpha, beta, sigma}
    struct office {
        string brandName;
        uint256 funding;
        // male candidate;
        bool recomendation;
    }

    function setUp() public {
        c = new Cheatsheet{value: 1.5 ether}();
    }

    function test_ethBalance() public {
        assertEq(address(c).balance, 1.5 ether);
    }

    function test_flag() public {
        assertEq(c.flag(), true);
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
        assertEq(string.concat(c.name(),"chewale"), "atharvachewale");
    }
    function test_selector() public {
        assertEq(c.selector(), hex"1a1b1c1d");
        // assertEq(c.selector(), 0x1a1b1c1d);
    }
    function test_ternary() public {
        c.ternary_on_x();
        assertEq(c.x(), 99);
    }
    function test_x() public {
        assertEq(c.x(), 10**2);
    }
    
    function test_struct_setup() public {
        c.initialize_struct_diffusionLabs();
        (string memory b,uint256 f, bool r) = c.diffusionLabs();
        assertEq(f, 1000_000);
        assertEq(b, "diffusion labs");
        assertEq(r, true);
    }

    function test_delegatecall() public {
        p = new proxy{value:1 ether}();
        (bool success, bytes memory data) = p.delegatecall_to_fallback(address(c));
        assertEq(success, true);
        assertEq(data, "random data_done");
    }

    function test_delegatecall_update_x() public {
        p = new proxy{value:1 ether}();
        assertEq(p.x(), 0);
        (bool success,) = p.delegatecall_to_update_x(address(c));
        assertEq(success, true);
        assertEq(p.x(), 500);
    }

    function test_call_update_x() public {
        p = new proxy{value:1 ether}();
        assertEq(c.x(), 100);
        (bool success,) = p.call_to_update_x(address(c));
        assertEq(success, true);
        assertEq(c.x(), 500);
    }

}
