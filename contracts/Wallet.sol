// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract MultiSignerWallet{
    address[] public owners;
    uint256 public threashold;

    struct Transfer{
        uint id;
        uint amount;
        address payable to;
        uint approval;
        bool sent;
    }

    Transfer[] public transfer;
    mapping (address => mapping (uint => bool)) approval;

    constructor(address[] memory _owners, uint256 _threshold){
        owners = _owners;
        threashold =_threshold;
    }

    function getOwner() external view returns(address[] memory){
        return owners;
    }

    function createTransfer(uint amount, address payable to )external{
        transfer.push(Transfer(
            transfer.length,
            amount,
            to,
            0,
            false
        ));
    }

    function getTransfers() external view returns(Transfer[] memory){
        return transfer;
    }

    function approveTransfer(uint id)external{
        require(transfer[id].sent == false, "Transfer sent");
        require(approval[msg.sender][id] == false,"cannot approve transfer again");

        approval[msg.sender][id]== true;
        transfer[id].approval++;

        if(transfer[id].approval >= threashold){
            transfer[id].sent = true;
            address payable to = transfer[id].to;
            uint amount = transfer[id].amount;
            to.transfer(amount);
        }
    }

    function deposit() external payable{}
}
