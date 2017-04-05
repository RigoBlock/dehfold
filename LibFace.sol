//! Library Interface contract.
//! By Gabriele Rigo (Rigo Investment), 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.8;

library LibInterface {
  struct S { uint i; }

  function getUint(S storage s) returns (uint);
  function setUint(S storage s, uint i);
}
