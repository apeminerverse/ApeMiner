from scripts.functions import *

yart_airdrop_ipfs = 'ipfs://bafybeigtbwecpthwzq4nj4gkc7tfv4c2v4adh26ndw5khboaq4sghqgcva'
open_airdrop_ipfs = 'ipfs://bafkreihpaqicot6kjkpda676jp2poajzbbckgbc4ue67b6wnbremljxu3e'
apeminer_ipfs = 'ipfs://bafkreiamehcsywzt3767uswrombs2qexunn2edlwxurzhduv4j27wdicma'
mjolnir_ipfs = 'ipfs://bafybeidhaiyqhzlmwldshgdscirqb3lhdo33p24sk2n5cwf7jz7xjuqckq'

root = '19e4d685ca19421798eb3aebf98ce36a26e247067d5cca90a18361e2e5ac677e'


def main():
    active_network = network.show_active()
    print("Current Network:" + active_network)

    admin, creator, consumer, iwan, newbie, apeminer, apvs = get_accounts(
        active_network)

    try:
        if active_network in LOCAL_NETWORKS:
            # address = gen_accounts(215, "InfinityGauntlet")
            # print('[' + address[:-1] + ']')
            pass

        if active_network in TEST_NETWORKS:
            pass
            # yarcht_party_airdrop = ApeMinerInfinityGauntlet[-1]
            # apeminer_airdrop = ApeMinerTreasureChest[-1]
            # apuminer_mint = ApeMinerNFT[-1]
            # apeminer_airdrop_cn = ApeMinerTreasureChestCN[-1]
            # mjolnir = ApeMinerMjolnir[-1]
        if active_network in REAL_NETWORKS:
            pass
            # yarcht_party_airdrop = ApeMinerInfinityGauntlet[-1]
            # apeminer_airdrop = ApeMinerTreasureChest[-1]
            # apuminer_mint = ApeMinerNFT[-1]
            # apeminer_airdrop_cn = ApeMinerTreasureChestCN[-1]
            # mjolnir = ApeMinerMjolnir[-1]
    except Exception:
        console.print_exception()
        # Test net contract address


if __name__ == "__main__":
    main()
