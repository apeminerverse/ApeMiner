from scripts.functions import *
yart_airdrop_ipfs = 'ipfs://bafybeigtbwecpthwzq4nj4gkc7tfv4c2v4adh26ndw5khboaq4sghqgcva'
open_airdrop_ipfs = 'ipfs://bafkreihpaqicot6kjkpda676jp2poajzbbckgbc4ue67b6wnbremljxu3e'
apeminer_ipfs = 'ipfs://bafkreiamehcsywzt3767uswrombs2qexunn2edlwxurzhduv4j27wdicma'
mjolnir_ipfs = 'ipfs://bafybeidhaiyqhzlmwldshgdscirqb3lhdo33p24sk2n5cwf7jz7xjuqckq'


def main():
    active_network = network.show_active()
    print("Current Network:" + active_network)

    admin, creator, consumer, iwan, newbie, apeminer = get_accounts(
        active_network)

    try:
        if active_network in LOCAL_NETWORKS:
            # nft = YachtPartyAirdrop.deploy(url, '', addr(admin))
            yarcht_party_airdrop = ApeMinerInfinityGauntlet.deploy(yart_airdrop_ipfs,
                                                                   addr(admin))
            apeminer_airdrop = ApeMinerTreasureChest.deploy("", open_airdrop_ipfs,
                                                            addr(admin))
            sale_nft = ApeMinerNFT.deploy("", apeminer_ipfs,   0.5*10**18,
                                          addr(admin))

            mjolnir = ApeMinerMjolnir.deploy(mjolnir_ipfs, addr(admin))

        if active_network in TEST_NETWORKS:
            # mjolnir = ApeMinerMjolnir.deploy(mjolnir_ipfs, addr(apeminer))
            # yarcht_party_airdrop = ApeMinerInfinityGauntlet.deploy(yart_airdrop_ipfs,
            #                                                        addr(admin))
            apeminer_airdrop = ApeMinerTreasureChest.deploy("", open_airdrop_ipfs,
                                                            addr(apeminer))

            apeminer_airdrop_cn = ApeMinerTreasureChestCN.deploy("", open_airdrop_ipfs,
                                                                 addr(apeminer))
            # sale_nft = ApeMinerNFT.deploy("", apeminer_ipfs, 0.005*10**18,
            #                               addr(admin))
            # tx = sale_nft.startPublicSale(addr(admin))
            # tx.wait(1)
            # mjolnir.mint(apeminer, 1000, addr(apeminer))

        if active_network in REAL_NETWORKS:
            # mjolnir = ApeMinerMjolnir.deploy(
            # mjolnir_ipfs, addr(apeminer), publish_source=True)
            # yarcht_party_airdrop = ApeMinerInfinityGauntlet.deploy(yart_airdrop_ipfs,
            #                                                        addr(admin), publish_source=True)
            # apeminer_airdrop = ApeMinerTreasureChest.deploy("", open_airdrop_ipfs,
            # addr(apeminer), publish_source=True)
            apeminer_airdrop_cn = ApeMinerTreasureChestCN.deploy("", open_airdrop_ipfs,
                                                                 addr(apeminer), publish_source=True)
            # # sale_nft = ApeMinerNFT.deploy("", apeminer_ipfs, 0.5*10**18,
            # #                               addr(admin), publish_source=True)

    except Exception:
        console.print_exception()
        # Test net contract address


if __name__ == "__main__":
    main()
