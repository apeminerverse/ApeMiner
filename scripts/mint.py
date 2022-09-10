from scripts.functions import *

url = 'https://bafybeid33sqhohn67wwlotseh4hczouzyxlllhevsipj5qseod7q56xohm.ipfs.nftstorage.link/'


def main():
    active_network = network.show_active()
    print("Current Network:" + active_network)

    admin, creator, consumer, iwan = get_accounts(active_network)

    try:
        if active_network in LOCAL_NETWORKS:
            # nft = YachtPartyAirdrop.deploy(url, '', addr(admin))

            # # abiEncode(nft)

            # nft.startAirdrop(addr(admin))
            # nft.testMint(addr(creator))

            bodyNFT = ApeMinerBodyNFT.deploy(url,  100, 50,  addr(admin))
            tx = bodyNFT.startPublicSale(addr(admin))
            tx.wait(1)

            tx = bodyNFT.publicSaleMint(admin, 5, addr2(creator, 600))
            tx.wait(1)

            bodyNFT.publicSaleMint(creator, 5, addr2(iwan, 600))

        if active_network in TEST_NETWORKS:
            # nft = YachtPartyAirdrop[-1]
            # nft.startAirdrop(addr(admin))
            # nft.testMint(addr(creator))

            bodyNFT = ApeMinerBodyNFT[-1]

            bodyNFT.publicSaleMint(0, 5, addr2(creator, 10))
            bodyNFT.publicSaleMint(creator, 5, addr2(iwan, 10))

        if active_network in REAL_NETWORKS:
            nft = YachtPartyAirdrop[-1]
            nft.startAirdrop(addr(admin))
            nft.testMint(addr(creator))

    except Exception:
        console.print_exception()
        # Test net contract address


if __name__ == "__main__":
    main()
