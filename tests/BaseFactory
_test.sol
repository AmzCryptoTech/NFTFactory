// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "remix_tests.sol";
import "../contracts/BaseFactory.sol";

contract BaseFactoryTest {

    BaseFactory s;
    function beforeAll () public {
        s = new BaseFactory();
    }

    function testTokenNameAndSymbol () public {
        /*Assert.equal(s.name(), "MyToken", "token name did not match");
        Assert.equal(s.symbol(), "MTK", "token symbol did not match");*/
    }
}