from scripts.functions import *

url = 'https://bafybeid33sqhohn67wwlotseh4hczouzyxlllhevsipj5qseod7q56xohm.ipfs.nftstorage.link/'


def main():
    active_network = network.show_active()
    print("Current Network:" + active_network)

    admin, creator, consumer, iwan = get_accounts(active_network)

    try:
        nft = YachtPartyAirdrop.deploy(url, addr(admin))
        flat_contract('YachtPartyAirdrop',
                      YachtPartyAirdrop.get_verification_info())

    except Exception:
        console.print_exception()
        # Test net contract address


if __name__ == "__main__":
    main()
