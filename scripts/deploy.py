from scripts.functions import *
url = 'https://bafybeid33sqhohn67wwlotseh4hczouzyxlllhevsipj5qseod7q56xohm.ipfs.nftstorage.link/'


def main():
    active_network = network.show_active()
    print("Current Network:" + active_network)

    admin, creator, consumer, iwan = get_accounts(active_network)

    try:
        if active_network in LOCAL_NETWORKS:
            # nft = YachtPartyAirdrop.deploy(url, addr(admin))
            bodyNFT = ApeMinerBodyNFT.deploy(url, 100, 50, addr(admin))

        if active_network in TEST_NETWORKS:
            # nft = YachtPartyAirdrop.deploy(url, addr(admin))
            bodyNFT = ApeMinerBodyNFT.deploy(url,  100, 50,  addr(admin))
            bodyNFT.startPublicSale(addr(admin))

        if active_network in REAL_NETWORKS:
            # nft = YachtPartyAirdrop.deploy(url, addr(admin))
            bodyNFT = ApeMinerBodyNFT.deploy(url,  100, 50, addr(admin))

    except Exception:
        console.print_exception()
        # Test net contract address


if __name__ == "__main__":
    main()
