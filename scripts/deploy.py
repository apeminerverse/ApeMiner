from scripts.functions import *
yart_airdrop_ipfs = 'ipfs://bafybeigtbwecpthwzq4nj4gkc7tfv4c2v4adh26ndw5khboaq4sghqgcva'
open_airdrop_ipfs = 'https://nftstorage.link/ipfs/bafkreieg5pevnrjjjlialkigmogahpmkltdjwuka6rwyosbydqigbdv7ke'
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
            sale_nft = ApeMinerNFT.deploy("", apeminer_ipfs,   0.5*10**18,
                                          addr(admin))
        if active_network in TEST_NETWORKS:
            # yarcht_party_airdrop = YachtPartyAirdrop.deploy(yart_airdrop_ipfs,
            #                                                 addr(admin))
            # apeminer_airdrop = ApeMinerAirdrop.deploy("", open_airdrop_ipfs,
            #                                           addr(admin))
            sale_nft = ApeMinerNFT.deploy("", apeminer_ipfs, 0.005*10**18,
                                          addr(admin))
            tx = sale_nft.startPublicSale(addr(admin))
            tx.wait(1)

        if active_network in REAL_NETWORKS:
            yarcht_party_airdrop = YachtPartyAirdrop.deploy(yart_airdrop_ipfs,
                                                            addr(admin), publish_source=True)
            # apeminer_airdrop = ApeMinerAirdrop.deploy("", open_airdrop_ipfs,
            #                                           addr(admin), publish_source=True)
            # sale_nft = ApeMinerNFT.deploy("", apeminer_ipfs, 0.5*10**18,
            #                               addr(admin), publish_source=True)

    except Exception:
        console.print_exception()
        # Test net contract address


if __name__ == "__main__":
    main()
