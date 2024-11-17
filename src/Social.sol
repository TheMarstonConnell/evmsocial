// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;


contract SocialPoster {

    struct Post {
        uint256 id;
        address author;
        string content;
        uint createdAt;
        uint256 quoting;
        uint256 parent;
        uint256 likeCount;
    }

    uint256 private postCounter = 1;

    mapping(uint256 => Post) private posts;
    mapping(uint256 => uint256[]) private comments;
    mapping(uint256 => uint256[]) private quotes;
    mapping(uint256 => mapping(address => bool)) private likes;

    function createPost(Post memory post) private returns (uint256) {
        uint256 i = postCounter;
        post.id = i;
        posts[postCounter] = post;  
        postCounter ++;

        return i;
    }

    function makePost(string memory content, uint256 quoting, uint256 parent) public returns (uint256){
        require ((quoting == 0 && parent > 0) || (quoting > 0 && parent == 0) || (quoting == 0 && parent == 0), "cannot quote and reply in the same post");

        Post memory post = Post({
            id: 0, 
            author: msg.sender, 
            content: content, 
            createdAt: block.number,
            quoting: quoting,
            parent: parent,
            likeCount: 0
        });
        uint256 id = createPost(post);

        if (parent > 0) {
            comments[parent].push(id);
        }
        if (quoting > 0) {
            quotes[quoting].push(id);
        }

        return id;
    }

    function like(uint256 postId) public {
        require( posts[postId].id > 0, "post does not exist");

        require( !likes[postId][msg.sender], "you've already liked this post before");

        likes[postId][msg.sender] = true;
        posts[postId].likeCount ++;
    }

    function unlike(uint256 postId) public {
        require( posts[postId].id > 0, "post does not exist");

        require(likes[postId][msg.sender], "you haven't liked this post yet");

        likes[postId][msg.sender] = false;
        posts[postId].likeCount --;
    }


    function getComments(uint256 postId) public view returns (Post[] memory) {
        require( posts[postId].id > 0, "post does not exist");

        uint256[] memory coms = comments[postId];

        Post[] memory commentPosts = new Post[](coms.length);


        for (uint i = 0; i < coms.length; i ++) {
            commentPosts[i] = posts[coms[i]];
        }

        return commentPosts;
    }

    function getQuotes(uint256 postId) public view returns (Post[] memory) {
        require( posts[postId].id > 0, "post does not exist");

        uint256[] memory quos = quotes[postId];

        Post[] memory quotePosts = new Post[](quos.length);


        for (uint i = 0; i < quos.length; i ++) {
            quotePosts[i] = posts[quos[i]];
        }

        return quotePosts;
    }
}