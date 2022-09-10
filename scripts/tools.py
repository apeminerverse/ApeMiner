from rich.console import Console
from brownie import network, interface, alert, chain, accounts, Contract
from eth_account import Account
from eth_account.messages import encode_structured_data
import eth_utils
import json
from rich import print
from rich import pretty
pretty.install()
#from pprint import pprint
console = Console(style="white on blue", stderr=True)


def addr(account):
    return {"from": account}


def addr2(account, eth):
    return {'from': account, 'value': eth}


def b(amnt):
    return network.web3.fromWei(amnt, 'ether')


def show3():
    return "admin=" + str(b(accounts[0].balance())) + " creator=" + str(b(accounts[1].balance())) + " consumer=" + str(b(accounts[2].balance()))


def balance_alert(account, name):
    alert.new(account.balance, msg=name +
              " Balance change from {} to {}", repeat=True)


def loadContract(name, address, abi):
    abi = json.loads(abi)
    return Contract.from_abi(name, address, abi)


def sign_ownerken_permit(
    token,
    owner: Account,  # NOTE: Must be a eth_key account, not Brownie
    spender: str,
    allowance: int = 2 ** 256 - 1,  # Allowance to set with `permit`
    deadline: int = 0,  # 0 means no time limit
    override_nonce: int = None,
):
    # ganache bug https://github.com/trufflesuite/ganache/issues/1643
    chain_id = network.chain.id
    if override_nonce:
        nonce = override_nonce
    else:
        nonce = token.nonces(owner.address)
    data = {
        "types": {
            "EIP712Domain": [
                {"name": "name", "type": "string"},
                {"name": "version", "type": "string"},
                {"name": "chainId", "type": "uint256"},
                {"name": "verifyingContract", "type": "address"},
            ],
            "Permit": [
                {"name": "owner", "type": "address"},
                {"name": "spender", "type": "address"},
                {"name": "value", "type": "uint256"},
                {"name": "nonce", "type": "uint256"},
                {"name": "deadline", "type": "uint256"},
            ],
        },
        "domain": {
            "name": token.name(),
            "version": "1",
            "chainId": chain_id,
            "verifyingContract": str(token),
        },
        "primaryType": "Permit",
        "message": {
            "owner": owner.address,
            "spender": spender,
            "value": allowance,
            "nonce": nonce,
            "deadline": deadline,
        },
    }
    permit = encode_structured_data(data)
    return owner.sign_message(permit)


def tokenApprove(token, owner, spender, amount):
    if(token.allowance(owner, spender) < amount):
        tx = token.approve(spender, amount, addr(owner))
        # tx.wait(1)
        return tx
    return None


def addressApprove(token_address, owner, spender, amount):
    token = interface.IERC20(token_address)
    return tokenApprove(token, owner, spender, amount)


def getWeth(weth_address, _from, amount=0.01 * 10 ** 18):
    """Mints WETH by depositing ETH."""
    weth = interface.IWETH(weth_address)
    tx = weth.deposit(addr2(_from, amount))
    # tx.wait(1)
    return tx


def withdrawETH(weth_address, _from, amount=0.01 * 10 ** 18):
    weth = interface.IWETH(weth_address)
    tx = weth.withdraw(amount, addr(_from))
    # tx.wait(1)
    return tx


def loadLocalConfig(config_file):
    try:
        with open(config_file, 'r') as file:
            return json.load(file)
    except:
        return None


def encode_function_data(function=None, *args):
    """Encodes the function call so we can work with an initializer.

    Args:
        initializer ([brownie.network.contract.ContractTx], optional):
        The initializer function we want to call. Example: `box.store`.
        Defaults to None.

        args (Any, optional):
        The arguments to pass to the initializer function

    Returns:
        [bytes]: Return the encoded bytes.
    """
    if len(args) == 0 or not function:
        return eth_utils.to_bytes(hexstr="0x")
    else:
        return function.encode_input(*args)


def move_blocks(amount):
    for _ in range(amount):
        accounts[0].transfer(accounts[0], "0 ether")
    print(chain.height)
