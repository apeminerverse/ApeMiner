from scripts.functions import *

yart_airdrop_ipfs = 'https://nftstorage.link/ipfs/bafkreihmdyd4vwz2or5qdcibauvkunah6dvkabya7cj5maz5lixtbw44bm'
open_airdrop_ipfs = 'https://nftstorage.link/ipfs/bafkreier72vel7fvsonaalmvpm7pyiurbec45xy6oizmmyruyde6zaidie'
apeminer_ipfs = 'https://nftstorage.link/ipfs/bafkreiamehcsywzt3767uswrombs2qexunn2edlwxurzhduv4j27wdicma'


def main():
    active_network = network.show_active()
    print("Current Network:" + active_network)

    admin, creator, consumer, iwan = get_accounts(active_network)

    try:
        if active_network in LOCAL_NETWORKS:
            pass
        if active_network in TEST_NETWORKS:
            yarcht_party_nft = YachtPartyAirdrop[-1]
            public_airdrop_nft = ApeMinerAirdrop[-1]
            sale_nft = ApeMinerNFT[-1]

    except Exception:
        console.print_exception()
        # Test net contract address


if __name__ == "__main__":
    main()
