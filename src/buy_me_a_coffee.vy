# # pragma version ^0.4.0
# # pragma enable-decimals
# """
# @license MIT
# @title A sample buy-me-a-coffee contract
# @author Abhinav Malik!
# @notice This contract is for creating a sample funding contract
# """
# from interfaces import AggregatorV3Interface
# import get_price_module
# # from eth.utils import as_wei_value

# # minimum_usd_decimals: public(constant(decimal)) = 50.0 
# # MINIMUM_USD: public(constant(uint256)) = 50  *(10**18)
# MINIMUM_USD: public(uint256) = 5 * 10**18
# # MINIMUM_USD: public(uint256) = as_wei_value(5, "ether")


# OWNER: public(immutable(address))

# funders: public(DynArray[address, 100])
# address_to_amount_funded: public(HashMap[address, uint256])
# PRICE_FEED: public(AggregatorV3Interface)

# @deploy
# def __init__(price_feed: address):
#     self.MINIMUM_USD = as_wei_value(5, "ether")

#     self.PRICE_FEED = AggregatorV3Interface(price_feed)
#     OWNER = msg.sender


# @internal
# def _only_owner():
#     assert msg.sender == OWNER, "Not the contract owner"


# @external
# @payable
# def fund():
#     usd_value_of_eth: uint256 = get_price_module._get_eth_to_usd_rate(self.PRICE_FEED, msg.value)
#     assert usd_value_of_eth >= self.MINIMUM_USD, "You need to spend more ETH!"
#     # assert usd_value_of_eth >= convert(MINIMUM_USD, uint256), "You need to spend more ETH!"
#     self.address_to_amount_funded[msg.sender] += msg.value
#     self.funders.append(msg.sender)


# @external
# def withdraw():
#     self._only_owner()
#     for funder: address in self.funders:
#         self.address_to_amount_funded[funder] = 0
#     self.funders = []
#     # send(OWNER, self.balance)
#     raw_call(OWNER, b"", value = self.balance)


# @external
# @view
# def get_version() -> uint256:
#     return staticcall self.PRICE_FEED.version()


# @external
# @view
# def get_funder(index: uint256) -> address:
#     return self.funders[index]


# @external
# @view
# def get_owner() -> address:
#     return OWNER

# @external
# @payable
# def __default__():
#     pass

# pragma version ^0.4.0
# pragma enable-decimals

"""
@license MIT
@title A sample buy-me-a-coffee contract
@author 
Abhinav Malik!
@notice This contract is for creating a sample funding contract
"""

from interfaces import AggregatorV3Interface
import get_price_module


# ----------------------------------
# STORAGE VARIABLES
# ----------------------------------

MINIMUM_USD: public(uint256)                # value set in __init__
OWNER: public(immutable(address))

funders: public(DynArray[address, 100])
address_to_amount_funded: public(HashMap[address, uint256])
PRICE_FEED: public(AggregatorV3Interface)


# ----------------------------------
# CONSTRUCTOR
# ----------------------------------
@deploy
def __init__(price_feed: address):
    # minimum contribution = 5 ETH worth of USD
    self.MINIMUM_USD = as_wei_value(5, "ether")

    self.PRICE_FEED = AggregatorV3Interface(price_feed)
    OWNER = msg.sender


# ----------------------------------
# INTERNAL: ONLY OWNER CHECK
# ----------------------------------
@internal
def _only_owner():
    assert msg.sender == OWNER, "Not the contract owner"


# ----------------------------------
# FUND FUNCTION
# ----------------------------------
@external
@payable
def fund():
    usd_value_of_eth: uint256 = get_price_module._get_eth_to_usd_rate(
        self.PRICE_FEED, msg.value
    )

    # check minimum requirement
    assert usd_value_of_eth >= self.MINIMUM_USD, "You need to spend more ETH!"

    self.address_to_amount_funded[msg.sender] += msg.value
    self.funders.append(msg.sender)


# ----------------------------------
# WITHDRAW FUNCTION
# ----------------------------------
@external
def withdraw():
    self._only_owner()

    # reset funders contributions
    for funder: address in self.funders:
        self.address_to_amount_funded[funder] = 0

    # reset array
    self.funders = []

    # send ETH to owner
    raw_call(OWNER, b"", value=self.balance)


# ----------------------------------
# VIEW FUNCTIONS
# ----------------------------------
@external
@view
def get_version() -> uint256:
    return staticcall self.PRICE_FEED.version()


@external
@view
def get_funder(index: uint256) -> address:
    return self.funders[index]


@external
@view
def get_eth_to_usd_rate(eth_amount: uint256) -> uint256:
    return get_price_module._get_eth_to_usd_rate(self.PRICE_FEED, eth_amount)


@external
@view
def get_owner() -> address:
    return OWNER


# ----------------------------------
# FALLBACK
# ----------------------------------
@external
@payable
def __default__():
    pass
