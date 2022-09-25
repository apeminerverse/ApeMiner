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
            # nft = YachtPartyAirdrop.deploy(url, '', addr(admin))
            yarcht_party_airdrop = YachtPartyAirdrop.deploy(yart_airdrop_ipfs,
                                                            addr(admin))
            apeminer_airdrop = ApeMinerAirdrop.deploy("", open_airdrop_ipfs,
                                                      addr(admin))
            apuminer_mint = ApeMinerNFT.deploy("", apeminer_ipfs,   0.5*10**18,
                                               addr(admin))
        if active_network in TEST_NETWORKS:
            yarcht_party_airdrop = YachtPartyAirdrop.deploy(yart_airdrop_ipfs,
                                                            addr(admin))
            apeminer_airdrop = ApeMinerAirdrop.deploy("", open_airdrop_ipfs,
                                                      addr(admin))
            apuminer_mint = ApeMinerNFT.deploy("", apeminer_ipfs, 0.5*10**18,
                                               addr(admin))

        if active_network in REAL_NETWORKS:
            yarcht_party_airdrop = YachtPartyAirdrop.deploy(yart_airdrop_ipfs,
                                                            addr(admin), publish_source=True)
            apeminer_airdrop = ApeMinerAirdrop.deploy("", open_airdrop_ipfs,
                                                      addr(admin), publish_source=True)
            apuminer_mint = ApeMinerNFT.deploy("", apeminer_ipfs, 0.5*10**18,
                                               addr(admin), publish_source=True)

    except Exception:
        console.print_exception()
        # Test net contract address


if __name__ == "__main__":
    main()
