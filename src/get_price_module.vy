# from interfaces import AggregatorV3Interface

# PRECISION: constant(uint256) = 1 * (10 ** 18)


# @internal
# @view
# def _get_eth_to_usd_rate(price_feed: AggregatorV3Interface, eth_amount: uint256) -> uint256:
#     """
#     Chris sent us 0.01 ETH for us to buy a coffee
#     Is that more or less than $5?
#     """
#     price: int256 = staticcall price_feed.latestAnswer() 
#     eth_price: uint256 = (convert(price, uint256)) * (10**10)
#     eth_amount_in_usd: uint256 = (eth_price * eth_amount) // PRECISION
#     return eth_amount_in_usd # 18 0's, 18 decimal places

from interfaces import AggregatorV3Interface

PRECISION: constant(uint256) = 1 * (10**18)

@internal
@view
def _get_eth_to_usd_rate(price_feed: AggregatorV3Interface, eth_amount: uint256) -> uint256:
    # Check the conversion rate
    a: uint80 = 0
    price: int256 = 0
    b: uint256 = 0
    c: uint256 = 0
    d: uint80 = 0
    (a, price, b, c, d) = staticcall price_feed.latestRoundData()
    # We know the price has 8 decimals, so we need to add 10
    eth_price: uint256 = (convert(price, uint256)) * (10**10)
    eth_amount_in_usd: uint256 = (eth_price * eth_amount) // PRECISION
    return eth_amount_in_usd