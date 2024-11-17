// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SocialPoster} from "../src/Social.sol";
import {console} from "forge-std/console.sol";

contract SocialPosterTest is Test {
    SocialPoster public socialPoster;

    function setUp() public {
        socialPoster = new SocialPoster();
    }

    function test_Post() public {
        
        uint256 newId = socialPoster.makePost("this is a stupid post", 0, 0);

        assertEq(newId, 1);

        newId = socialPoster.makePost("this is a stupid post again", 0, 0);

        assertEq(newId, 2);

        newId = socialPoster.makePost("this responding to a stupid post", 0, 1);

        assertEq(newId, 3);

        SocialPoster.Post[] memory comments = socialPoster.getComments(1);
        assertEq(comments.length, 1);
        assertEq(comments[0].id, 3);

        newId = socialPoster.makePost("this quoting a stupid post", 1, 0);

        assertEq(newId, 4);

        SocialPoster.Post[] memory quotes = socialPoster.getQuotes(1);
        assertEq(quotes.length, 1);
        assertEq(quotes[0].id, 4);
    }
}
